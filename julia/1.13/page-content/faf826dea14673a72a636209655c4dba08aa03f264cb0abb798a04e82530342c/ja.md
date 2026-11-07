# Custom LLVM Passes

Julia には、独自の LLVM パスがいくつかあります。大きく分けると、Julia のセマンティクスを維持するために実行が必須のパスと、Julia のセマンティクスを利用して LLVM IR を最適化するパスに分類できます。

## Semantic Passes

これらのパスは、LLVM IR を CPU 上で実行可能なコードに変換するために使われます。主な目的は、コード生成でより単純な IR を出力できるようにすることです。これにより、ほかの LLVM パスが一般的なパターンを最適化できるようになります。

### CPUFeatures

  * ファイル名: `llvm-cpufeatures.cpp`
  * クラス名: `CPUFeaturesPass`
  * 最適化名: `module(CPUFeatures)`

このパスは、`julia.cpu.have_fma.(f32|f64)` intrinsic を、ターゲットアーキテクチャと関数に設定されたターゲット機能に応じて true または false に変換します。この intrinsic は、高速な [fused multiply-add](https://en.wikipedia.org/wiki/Multiply%E2%80%93accumulate_operation#Fused_multiply%E2%80%93add) 命令に依存するアルゴリズムを使うほうが、そのような命令に依存しない標準的なアルゴリズムを使うよりも適切かどうかを判定するためによく使われます。

### DemoteFloat16

  * ファイル名: `llvm-demote-float16.cpp`
  * クラス名: `DemoteFloat16Pass`
  * 最適化名: `function(DemoteFloat16)`

このパスは、float16 命令をネイティブにサポートしないアーキテクチャで、[float16](https://en.wikipedia.org/wiki/Half-precision_floating-point_format) 命令を float32 命令に置き換えます。そのために、float16 命令の前後に `fpext` 命令と `fptrunc` 命令を挿入します。float16 命令をネイティブにサポートするアーキテクチャでは、このパスは何も行いません。

### LateGCLowering

  * ファイル名: `llvm-late-gc-lowering.cpp`
  * クラス名: `LateLowerGCPass`
  * 最適化名: `function(LateLowerGCFrame)`

このパスは、GC セーフポイント間のポインターを追跡するために必要な GC rooting 処理の大部分を行います。また、いくつかの intrinsic を対応する命令変換に変換します。さらに、以前に確立された非整数型の不変条件に違反することが許可されています（ここでは `pointer_from_objref` が `ptrtoint` 命令に変換されます）。セーフポイントで生存するオブジェクトの数を最小限に抑えるデータフローアルゴリズムを使うため、通常、このパスは Julia 独自のパスの中で最も実行時間が長くなります。

### FinalGCLowering

  * ファイル名: `llvm-final-gc-lowering.cpp`
  * クラス名: `FinalLowerGCPass`
  * 最適化名: `module(FinalLowerGC)`

このパスは、`libjulia` ライブラリ内の関数を対象に、残りのいくつかの intrinsic を最終形に変換します。この処理を `LateGCLowering` から分離することで、ほかのバックエンド（GPU コンパイルなど）がこれらの intrinsic に独自の変換処理を提供できるようになり、Julia のパイプラインをそれらのバックエンドでも利用できます。

### RemoveNI

  * ファイル名: `llvm-remove-ni.cpp`
  * クラス名: `RemoveNIPass`
  * 最適化名: `module(RemoveNI)`

このパスは、モジュールのデータレイアウト文字列から非整数型アドレス空間を削除します。これにより、バックエンドは、すべてのポインター操作をアドレス空間 0 に書き換えるコストの高い処理を行わずに、Julia 独自のアドレス空間を直接マシンコードに変換できます。

### SIMDLoop

  * ファイル名: `llvm-simdloop.cpp`
  * クラス名: `LowerSIMDLoopPass`
  * 最適化名: `loop(LowerSIMDLoop)`

このパスは、`@simd` アノテーションを処理する主要なドライバーです。コード生成では、ループの後方分岐に `!llvm.loopid` マーカーを挿入します。このパスはそのマーカーを使って、もともと `@simd` でマークされていたループを特定します。次に、リダクションを構成する浮動小数点演算の連鎖を探し、再結合（ひいてはベクトル化）を可能にするため、`contract` と `reassoc` の fast math フラグを追加します。このパスはループ情報も推論の正しさも保持しないため、予期しない形で Julia のセマンティクスに違反する可能性があります。ループに `ivdep` も付与されている場合、このパスはそのループにループ間依存がないものとしてマークします（ユーザーのアノテーションが誤っている場合、または誤ったループに適用された場合、結果の動作は未定義です）。

### LowerPTLS

  * ファイル名: `llvm-ptls.cpp`
  * クラス名: `LowerPTLSPass`
  * 最適化名: `module(LowerPTLSPass)`

このパスは、スレッドローカルな Julia intrinsic をアセンブリ命令に変換します。Julia は、ガベージコレクションとマルチスレッドのタスクスケジューリングにスレッドローカルストレージを利用します。システムイメージやパッケージイメージ用のコードをコンパイルする場合、このパスは intrinsic の呼び出しを、ロード時に初期化されるグローバル変数からのロードに置き換えます。

コード生成によって `swiftself` 引数と呼び出し規約を持つ関数が生成された場合、このパスは `swiftself` 引数が pgcstack であるとみなし、intrinsic をその引数に置き換えます。これにより、スレッドローカルストレージへのアクセスが遅いアーキテクチャで高速化できます。

### RemoveAddrspaces

  * ファイル名: `llvm-remove-addrspaces.cpp`
  * クラス名: `RemoveAddrspacesPass`
  * 最適化名: `module(RemoveAddrspaces)`

このパスは、あるアドレス空間にあるポインターを別のアドレス空間に移します。LLVM IR から Julia 固有のアドレス空間を取り除くために使われます。

### RemoveJuliaAddrspaces

  * ファイル名: `llvm-remove-addrspaces.cpp`
  * クラス名: `RemoveJuliaAddrspacesPass`
  * 最適化名: `module(RemoveJuliaAddrspaces)`

このパスは、LLVM IR から Julia 固有のアドレス空間を取り除きます。主に、LLVM IR をより見やすく表示するために使われます。内部的には RemoveAddrspaces パスを利用して実装されています。

### Multiversioning

  * ファイル名: `llvm-multiversioning.cpp`
  * クラス名: `MultiVersioningPass`
  * 最適化名: `module(JuliaMultiVersioning)`

このパスは、モジュールを変更して、異なるアーキテクチャでの実行に最適化された関数を作成します（詳しくは sysimg.md と pkgimg.md を参照してください）。実装上は、関数を複製し、それぞれに異なるターゲット固有の属性を適用します。これにより、オプティマイザーは、そのプラットフォーム向けのベクトル化や命令スケジューリングなどの高度な機能を利用できます。また、Julia のイメージローダーが、実行中のアーキテクチャに応じて呼び出す関数のバージョンを選択できるようにする仕組みも作成します。ターゲット固有の属性は `julia.mv.specs` モジュールフラグで制御されます。このフラグはコンパイル時に [`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) 環境変数から導出されます。また、このパスを有効にするには、値が 1 の `julia.mv.enable` モジュールフラグを指定する必要があります。

!!! warning
    マルチバージョニングと併せて `llvmcall` を使うのは危険です。`llvmcall` を使うと、通常は Julia API から公開されていない機能にアクセスできます。そのため、通常はすべてのアーキテクチャで利用できるわけではありません。マルチバージョニングが有効な状態で、`llvmcall` 式が必要とする機能をサポートしないターゲットアーキテクチャ向けにコード生成を要求すると、LLVM はおそらくエラーを出します。abort と `LLVM ERROR: Do not know how to split the result of this operator!` というメッセージが発生する可能性も高いでしょう。


### GCInvariantVerifier

  * ファイル名: `llvm-gc-invariant-verifier.cpp`
  * クラス名: `GCInvariantVerifierPass`
  * 最適化名: `module(GCInvariantVerifier)`

このパスは、LLVM IR に関する Julia の不変条件を検証します。たとえば、Julia の [non-integral address spaces](https://llvm.org/docs/LangRef.html#non-integral-pointer-type) に `ptrtoint` が存在しないこと[^nislides]や、許可された `addrspacecast` 命令（Tracked -> Derived、0 -> Tracked など）のみが存在することを検証します。IR の変換は行いません。

[^nislides]: https://llvm.org/devmtg/2015-02/slides/chisnall-pointers-not-int.pdf

## Optimization Passes

これらのパスは、LLVM 自身では行わない LLVM IR の変換（fast math フラグの伝播、エスケープ解析、Julia 固有の内部関数の最適化など）を実行します。Julia のセマンティクスに関する知識を利用して、これらの最適化を行います。

### AllocOpt

  * ファイル名: `llvm-alloc-opt.cpp`
  * クラス名: `AllocOptPass`
  * 最適化名: `function(AllocOpt)`

Julia には、変更可能なオブジェクトを割り当てる場所としてのプログラムスタックという概念がありません。しかし、オブジェクトをスタックに割り当てると GC の負荷が軽減され、GPU コンパイルに不可欠です。そのため、`AllocOpt` は、現在の関数から [escape](https://en.wikipedia.org/wiki/Escape_analysis) しないと証明できるオブジェクトについて、ヒープからスタックへの変換を行います。また、使われない割り当ての削除、新たに割り当てられたオブジェクトに対する typeof 呼び出しの最適化、直後に上書きされる割り当てへのストアの削除など、割り当てに関するほかの最適化も行います。エスケープ解析の実装は `llvm-alloc-helpers.cpp` にあります。現時点では、このパスは `EscapeAnalysis.jl` の情報を利用しませんが、将来的には変わる可能性があります。

### PropagateJuliaAddrspaces

  * ファイル名: `llvm-propagate-addrspaces.cpp`
  * クラス名: `PropagateJuliaAddrspacesPass`
  * 最適化名: `function(PropagateJuliaAddrspaces)`

このパスは、ポインターに対する操作を通じて Julia 固有のアドレス空間を伝播させます。LLVM の最適化では addrspacecast 命令を追加または削除できないため、このパスは操作を Julia のアドレス空間における同等の操作に置き換え、冗長なアドレス空間キャストを取り除きます。Julia のアドレス空間について詳しくは、(TODO link to llvm.md) を参照してください。

### JuliaLICM

  * ファイル名: `llvm-julia-licm.cpp`
  * クラス名: `JuliaLICMPass`
  * 最適化名: `loop(JuliaLICM)`

このパスは、Julia 固有の intrinsic をループの外に移動します。具体的には、次の変換を行います。

1. 保持されるオブジェクトがループ不変である場合、`gc_preserve_begin` をループの外に移動し、`gc_preserve_end` をループの外に移動します。

    1. ループ内で保持されるオブジェクトは、ループの実行中ずっと保持される可能性が高いため、この変換によって IR 内の `gc_preserve_begin`/`gc_preserve_end` のペア数を減らせます。これにより、`LateLowerGCPass` が特定のオブジェクトの保持箇所を特定しやすくなります。
2. 不変オブジェクトに対する書き込みバリアをループの外に移動する

    1. オブジェクトが属する世代は 2 つだけだと仮定します。この場合、同じオブジェクトの組み合わせに対して書き込みバリアを実行するのは一度だけで十分です。そのため、書き込み先のオブジェクトがループ不変であれば、書き込みバリアをループの外に移動できます。
3. ループからエスケープしない割り当てをループの外に移動する

    1. ここでは、`AllocOptPass` と同じ、非常に保守的なエスケープの定義を使います。この変換により、割り当てが関数全体からエスケープする場合でも、IR 内の割り当て数を減らせます。

!!! note
    このパスは、LLVM の [MemorySSA](https://llvm.org/docs/MemorySSA.html)（[Short Video](https://www.youtube.com/watch?v=bdxWmryoHak)、[Longer Video](https://www.youtube.com/watch?v=1e5y6WDbXCQ)）および [ScalarEvolution](https://baziotis.cs.illinois.edu/compilers/introduction-to-scalar-evolution.html)（[Newer Slides](https://llvm.org/devmtg/2018-04/slides/Absar-ScalarEvolution.pdf) [Older Slides](https://llvm.org/devmtg/2009-10/ScalarEvolutionAndLoopOptimization.pdf)）解析を保持するために必要です。

