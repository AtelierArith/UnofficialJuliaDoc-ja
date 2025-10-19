# JIT Design and Implementation

この文書は、コード生成が完了し、最適化されていないLLVM IRが生成された後のJuliaのJITの設計と実装について説明しています。JITは、このIRを機械コードに最適化およびコンパイルし、現在のプロセスにリンクしてコードを実行可能にする責任があります。

## Introduction

JITは、コンパイルリソースの管理、以前にコンパイルされたコードの検索、新しいコードのコンパイルを担当しています。主にLLVMの[On-Request-Compilation](https://llvm.org/docs/ORCv2.html)（ORCv2）技術に基づいて構築されており、同時コンパイル、遅延コンパイル、別プロセスでのコードコンパイルの能力など、いくつかの便利な機能をサポートしています。LLVMはLLJITの形で基本的なJITコンパイラを提供していますが、Juliaは多くのORCv2 APIを直接使用して独自のカスタムJITコンパイラを作成しています。

## Overview

![コンパイラフローの図](./img/compiler_diagram.png)

Codegenは、型推論によって生成された元のJulia SSA IRから1つ以上のJulia関数のIRを含むLLVMモジュールを生成します（上記のコンパイラ図でtranslateとしてラベル付けされています）。また、コードインスタンスとLLVM関数名のマッピングも生成します。しかし、JuliaベースのコンパイラがJulia IRに対していくつかの最適化を適用したにもかかわらず、Codegenによって生成されたLLVM IRにはまだ多くの最適化の機会が含まれています。したがって、JITが最初に行うステップは、LLVMモジュールに対してターゲット非依存の最適化パイプライン[^tdp]を実行することです。次に、JITはターゲット依存の最適化パイプラインを実行し、ターゲット固有の最適化とコード生成を含み、オブジェクトファイルを出力します。最後に、JITは生成されたオブジェクトファイルを現在のプロセスにリンクし、コードを実行可能にします。これらすべては、`src/jitlayers.cpp`のコードによって制御されています。

[^tdp]: This is not a totally-target independent pipeline, as transformations such as vectorization rely upon target information such as vector register width and cost modeling. Additionally, codegen itself makes a few target-dependent assumptions, and the optimization pipeline will take advantage of that knowledge.

現在、最適化-コンパイル-リンクパイプラインには、一度に1つのスレッドのみが入ることが許可されています。これは、私たちのリンカーの1つ（RuntimeDyld）によって課せられた制限によるものです。しかし、JITは同時最適化とコンパイルをサポートするように設計されており、RuntimeDyldがすべてのプラットフォームで完全に置き換えられると、リンカーの制限は将来的に解除されると期待されています。

## Optimization Pipeline

最適化パイプラインはLLVMの新しいパスマネージャに基づいていますが、パイプラインはJuliaのニーズに合わせてカスタマイズされています。パイプラインは`src/pipeline.cpp`で定義されており、以下に詳述するいくつかのステージを通じて進行します。

1. 初期の簡素化

    1. これらのパスは、主にIRを簡素化し、パターンを標準化するために使用され、後のパスがそれらのパターンをより簡単に特定できるようにします。さらに、分岐予測ヒントや注釈などのさまざまな内在的呼び出しは、他のメタデータや他のIR機能に変換されます。 [`SimplifyCFG`](https://llvm.org/docs/Passes.html#simplifycfg-simplify-the-cfg)（制御フローグラフの簡素化）、[`DCE`](https://llvm.org/docs/Passes.html#dce-dead-code-elimination)（デッドコードの排除）、および[`SROA`](https://llvm.org/docs/Passes.html#sroa-scalar-replacement-of-aggregates)（集約のスカラー置換）は、ここでの重要なプレーヤーのいくつかです。
2. 初期最適化

    1. これらのパスは通常安価であり、主にIR内の命令数を減らし、他の命令に知識を伝播させることに焦点を当てています。例えば、[`EarlyCSE`](https://en.wikipedia.org/wiki/Common_subexpression_elimination) は共通部分式の消去を行うために使用され、[`InstCombine`](https://llvm.org/docs/Passes.html#instcombine-combine-redundant-instructions) および [`InstSimplify`](https://llvm.org/doxygen/classllvm_1_1InstSimplifyPass.html#details) は、操作をより安価にするためにいくつかの小さなピーphole最適化を実行します。
3. ループ最適化

    1. これらのパスはループを正規化し、簡素化します。ループはしばしばホットコードであり、ループ最適化はパフォーマンスにとって非常に重要です。ここでの主要なプレーヤーには [`LoopRotate`](https://llvm.org/docs/Passes.html#loop-rotate-rotate-loops)、[`LICM`](https://llvm.org/docs/Passes.html#licm-loop-invariant-code-motion)、および [`LoopFullUnroll`](https://llvm.org/docs/Passes.html#loop-unroll-unroll-loops) が含まれます。また、[`IRCE`](https://llvm.org/doxygen/InductiveRangeCheckElimination_8cpp_source.html) パスの結果として、特定の境界が決して超えられないことを証明できるため、いくつかの境界チェックの排除もここで発生します。
4. スカラー最適化

    1. スカラー最適化パイプラインには、[`GVN`](https://llvm.org/docs/Passes.html#gvn-global-value-numbering)（グローバル値番号付け）、[`SCCP`](https://llvm.org/docs/Passes.html#sccp-sparse-conditional-constant-propagation)（スパース条件定数伝播）、およびもう1回の境界チェック除去など、より高価だがより強力なパスが含まれています。これらのパスは高価ですが、大量のコードを削除し、ベクトル化をはるかに成功させ、効果的にすることができます。いくつかの他の簡素化および最適化パスが、より高価なものの合間に挿入され、彼らが行う必要のある作業量を減らします。
5. ベクトル化

    1. [Automatic vectorization](https://en.wikipedia.org/wiki/Automatic_vectorization) は、CPU集中的なコードに対して非常に強力な変換です。簡単に言うと、ベクトル化は [single instruction on multiple data](https://en.wikipedia.org/wiki/Single_instruction,_multiple_data) (SIMD) の実行を可能にし、例えば8つの加算操作を同時に行うことができます。しかし、コードがベクトル化可能であり、かつベクトル化する価値があることを証明するのは難しく、これは主に以前の最適化パスに依存してIRをベクトル化する価値のある状態に整えることに依存しています。
6. 内因的低下

    1. Juliaは、オブジェクトの割り当て、ガーベジコレクション、例外処理などの理由から、いくつかのカスタムインストリンシックを挿入します。これらのインストリンシックは、最適化の機会をより明確にするために元々配置されましたが、現在はLLVM IRに低下され、IRが機械コードとして出力されることを可能にしています。
7. クリーンアップ

    1. これらのパスは最後のチャンスの最適化であり、融合乗算加算伝播や除算余り簡略化などの小さな最適化を実行します。さらに、半精度浮動小数点数をサポートしていないターゲットでは、半精度命令がここで単精度命令に変換され、サニタイザサポートを提供するためのパスが追加されます。

## Target-Dependent Optimization and Code Generation

LLVMは、特定のプラットフォームのTargetMachine内で、ターゲット依存の最適化と機械コード生成を同じパイプラインで提供します。これらのパスには、命令選択、命令スケジューリング、レジスタ割り当て、および機械コードの発行が含まれます。LLVMのドキュメントはプロセスの良い概要を提供しており、LLVMのソースコードはパイプラインとパスの詳細を確認するための最良の場所です。

## Linking

現在、Juliaは古いRuntimeDyldリンカーと新しい[JITLink](https://llvm.org/docs/JITLink.html)リンカーの間で移行しています。JITLinkには、RuntimeDyldにはないいくつかの機能が含まれており、同時リンクや再入可能リンクなどがありますが、現在はプロファイリング統合の良好なサポートが欠けており、RuntimeDyldがサポートするすべてのプラットフォームをまだサポートしていません。時間が経つにつれて、JITLinkはRuntimeDyldを完全に置き換えることが期待されています。JITLinkに関する詳細はLLVMのドキュメントに記載されています。

## Execution

コードが現在のプロセスにリンクされると、それは実行可能になります。この事実は、`invoke`、`specsigflags`、および `specptr` フィールドを適切に更新することによって生成された codeinst に知らされます。Codeinst は、任意の時点で存在するこれらのフィールドのすべての組み合わせが呼び出すのに有効である限り、`invoke`、`specsigflags`、および `specptr` フィールドのアップグレードをサポートします。これにより、JIT は既存の codeinst を無効にすることなくこれらのフィールドを更新でき、将来の同時 JIT をサポートします。具体的には、以下の状態が有効である可能性があります：

1. `invoke` は NULL であり、`specsigflags` は 0b00 であり、`specptr` は NULL です。

    1. これはコードインスタンスの初期状態であり、コードインスタンスがまだコンパイルされていないことを示しています。
2. `invoke`は非NULLで、`specsigflags`は0b00、`specptr`はNULLです。

    1. これは、codeinstが特別化なしでコンパイルされておらず、codeinstを直接呼び出すべきであることを示しています。この場合、`invoke`は`specsigflags`または`specptr`フィールドを読み取らないため、これらは`invoke`ポインタを無効にすることなく変更できます。
3. `invoke`は非nullで、`specsigflags`は0b10で、`specptr`は非nullです。

    1. これは、codeinstがコンパイルされたことを示していますが、codegenによって特別な関数シグネチャは不要と見なされました。
4. `invoke`は非nullで、`specsigflags`は0b11で、`specptr`は非nullです。

    1. これは、codeinstがコンパイルされ、codegenによって特化した関数シグネチャが必要であると見なされたことを示しています。`specptr`フィールドには、特化した関数シグネチャへのポインタが含まれています。`invoke`ポインタは、`specsigflags`および`specptr`フィールドの両方を読み取ることが許可されています。

さらに、更新プロセス中に発生するさまざまな遷移状態があります。これらの潜在的な状況に対処するために、これらの codeinst フィールドを扱う際には、以下の書き込みおよび読み取りパターンを使用する必要があります。

1. `invoke`、`specsigflags`、および `specptr` を記述する際：

    1. NULLの古い値を仮定して、specptrの原子比較交換操作を実行します。この比較交換操作は、書き込みの残りのメモリ操作の順序保証を提供するために、少なくとも取得-解放順序を持つ必要があります。
    2. `specptr`が非nullの場合、書き込み操作を中止し、`specsigflags`のビット0b10が書き込まれるのを待ってから、必要に応じてステップ1から再開します。
    3. `specsigflags`の新しい低ビットを最終値に書き込みます。これは緩やかな書き込みである可能性があります。
    4. `invoke` ポインタを最終値に書き込みます。これは、`invoke` の読み取りと同期するために、少なくともリリースメモリ順序を持っている必要があります。
    5. `specsigflags`の2番目のビットを1に設定します。これは、`specsigflags`の読み取りと同期するために、少なくともリリースメモリ順序である必要があります。このステップは書き込み操作を完了し、すべての他のスレッドにすべてのフィールドが設定されたことを通知します。
2. `invoke`、`specsigflags`、および `specptr` をすべて読むとき:

    1. `specptr`フィールドを任意のメモリ順序で読み取ります。
    2. `invoke`フィールドを、少なくとも取得メモリ順序で読み取ります。このロードは`initial_invoke`と呼ばれます。
    3. `initial_invoke`がNULLの場合、codeinstはまだ実行可能ではありません。`invoke`はNULLであり、`specsigflags`は0b00として扱われる可能性があり、`specptr`はNULLとして扱われる可能性があります。
    4. `specptr`がNULLの場合、`initial_invoke`ポインタは正しい実行を保証するために`specptr`に依存してはならない。したがって、`invoke`は非NULLであり、`specsigflags`は0b00として扱うことができ、`specptr`はNULLとして扱うことができる。
    5. `specptr`が非nullである場合、`initial_invoke`は`specptr`を使用する最終的な`invoke`フィールドではない可能性があります。これは、`specptr`が書き込まれたが、`invoke`がまだ書き込まれていない場合に発生する可能性があります。したがって、少なくとも取得メモリ順序で1に設定されるまで、`specsigflags`の2番目のビットでスピンします。
    6. `invoke`フィールドを任意のメモリ順序で再読み込みします。このロードは`final_invoke`と呼ばれます。
    7. `specsigflags`フィールドを任意のメモリ順序で読み取ります。
    8. `invoke` は `final_invoke` であり、 `specsigflags` はステップ 7 で読み取った値で、 `specptr` はステップ 3 で読み取った値です。
3. `specptr`を異なるが同等の関数ポインタに更新する場合：

    1. 新しい関数ポインタを `specptr` にリリースストアします。ここでの競合は無害でなければならず、古い関数ポインタは依然として有効である必要があり、新しいポインタも有効である必要があります。`specptr` にポインタが書き込まれた後は、それが後で上書きされるかどうかにかかわらず、常に呼び出し可能でなければなりません。

これらのフィールドを正しく読み取ることは `jl_read_codeinst_invoke` に実装されています。

これらの書き込み、読み取り、および更新のステップは複雑ですが、JITが既存のcodeinstを無効にすることなくcodeinstを更新できること、またJITが既存の`invoke`ポインタを無効にすることなくcodeinstを更新できることを保証します。これにより、JITは将来的により高い最適化レベルで関数を再最適化する可能性があり、また将来的に関数の同時コンパイルをサポートすることができます。
