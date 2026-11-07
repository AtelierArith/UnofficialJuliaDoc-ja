# Julia + MMTk

Julia 内部の GC コードをリファクタリングし、外部 GC をサポートするために、これまで多くの取り組みが行われてきました。Julia で異なる GC アルゴリズムを使えるようにするための第一歩として、[GC interface](https://docs.google.com/document/d/1v0jtSrIpdEDNOxj5S9g1jPqSpuAkNWhr_T8ToFC9RLI/edit?usp=sharing) の設計と実装が行われました。このインターフェースを利用するため、Julia を [MMTk](https://www.mmtk.io)（Memory Management Toolkit）とともにビルドできるようにしました。Julia と MMTk を組み合わせることで、さまざまな GC 実装をテストでき、開発者は Julia をソースからビルドする際に特定の実装を選択できます。Julia と MMTk は *バインディング* を介して接続されます。バインディングは言語ランタイムと MMTk コアを結び付けるものです。mmtk-julia バインディングは Rust で書かれており、[this repository](https://github.com/mmtk/mmtk-julia) にあります。

> [!NOTE] 別の GC を使うには、Julia をソースからビルドする必要があります。実行時に実装を切り替えることはできません。現在使用中の GC のバージョンを確認するには、Julia REPL で `versioninfo()` を実行してください。バージョンは `GC: ...` に表示されます。


## Building Julia with MMTk

MMTk とともに Julia をビルドする方法は 3 通りあります。バインディングの固定リリース版を使ってソースからビルドする方法、mmtk-julia の [repository](https://github.com/mmtk/mmtk-julia) でカスタムバージョンをチェックアウトする方法、Julia の BinaryBuilder が提供するプリコンパイル済みバイナリを使う方法です。最も簡単なのは BinaryBuilder のバイナリを使う方法です。まず、サードパーティ製 GC として MMTk を有効にするため、変数 `WITH_THIRD_PARTY_GC` を `mmtk` に設定します。次に、たとえば Immix を GC として使うには、変数 `MMTK_PLAN=Immix` を設定し、通常どおり Julia をビルドします。

以下の変数を使って、さまざまな構成を指定できます。変数は `Make.user` ファイル内、または環境変数として設定できます。現時点では、`MMTK_PLAN=StickyImmix`（世代別バージョンの Immix を使用）または `MMTK_MOVING=1`（オブジェクトの移動を有効化）を設定すると、これらの構成への対応がまだ追加されていないため、セグメンテーション違反などのビルドエラーが発生する可能性が高いことに注意してください。`MMTK_BUILD=debug` を設定すると、バインディングがデバッグビルドになり、MMTk 固有のエラーの特定に役立つログ情報が出力されます。

|            変数 |         |             |
| -------------:| -------:| -----------:|
|   `MMTK_PLAN` |   Immix | StickyImmix |
| `MMTK_MOVING` |       0 |           1 |
|  `MMTK_BUILD` | release |       debug |

`MMTK_PLAN` だけを設定した場合、デフォルトでは非移動型のリリースビルドになります。

### Building mmtk-julia from source

バインディングをソースからビルドすることもできます。その場合は変数 `USE_BINARYBUILDER_MMTK_JULIA=0` を設定します。バインディングの最新リリース版がダウンロードされ、Julia のビルド時にあわせてビルドされます。この方法には Rust ツールチェーンのインストールが必要です。

[git repository](https://github.com/mmtk/mmtk-julia) からチェックアウトしたカスタムバージョンのバインディングをビルドすることもできます。その場合は、バインディングを含むパスを値として、変数 `MMTK_JULIA_DIR` を設定します。

MMTk とともに Julia をビルドする方法の詳細については、バインディングリポジトリにある [README](https://github.com/mmtk/mmtk-julia/blob/master/README.md) ファイルを参照してください。

### I've got a build error when building Julia with MMTk, what should I do?

MMTk とともに Julia をビルドしようとしてエラーが発生した場合、Julia の変更がまだバインディングに反映されていないか、Julia 内の MMTk 固有コードに問題がある可能性があります。変更の例を以下に示します。

(1) **Julia のオブジェクトのメモリレイアウトを変更する**。バインディングでは、Julia のコードから自動生成される Rust FFI バインディングを利用しています。これらのファイルは、[`rust-bindgen`](https://github.com/rust-lang/rust-bindgen) という名前のクレートを使って生成されます。ファイルを再生成するには、最新バージョンの `mmtk-julia` バインディングをチェックアウトし、ビルド対象の Julia のパスを変数 `JULIA_PATH` に設定してから、バインディングのディレクトリで `make regen-bindgen-ffi` を実行します。これにより、現在の FFI バインディングが削除され、`JULIA_PATH` の Julia コードに基づく新しいバージョンが生成されます。

(2) **GC に渡すルートオブジェクトを変更する**。Julia は関数 [gc*mark*roots](https://github.com/JuliaLang/julia/blob/fbe865657942da7d73cc02f76064f9ba9cdef56c/src/gc-stock.c#L2846) で、オブジェクトの集合をルートとして GC に渡します。現時点では、この集合は Stock GC と MMTk の両方で一致している必要があります（関数 [`jl_gc_scan_vm_specific_roots`](https://github.com/JuliaLang/julia/blob/fbe865657942da7d73cc02f76064f9ba9cdef56c/src/gc-mmtk.c#L496)）。

(3) **オブジェクトのスキャン方法を変更する**。MMTk は、Julia のオブジェクト内の参照を見つけるために、標準の GC と同じ方法を使います（[gc*mark*outrefs](https://github.com/JuliaLang/julia/blob/fbe865657942da7d73cc02f76064f9ba9cdef56c/src/gc-stock.c#L2227C19-L2227C34) を参照）。この関数のロジックを変更した場合は、バインディング内の Rust コードにも反映する必要があります。該当するコードは [scan Julia objects](https://github.com/mmtk/mmtk-julia/blob/c9e046baf3a0d52fe75d6c8b28f6afd69b045d95/mmtk/src/julia_scanning.rs#L68) にあります。

上記のいずれにも該当しない場合は、Julia リポジトリに issue を作成し、`GC: MMTK` ラベルを付けてください。
