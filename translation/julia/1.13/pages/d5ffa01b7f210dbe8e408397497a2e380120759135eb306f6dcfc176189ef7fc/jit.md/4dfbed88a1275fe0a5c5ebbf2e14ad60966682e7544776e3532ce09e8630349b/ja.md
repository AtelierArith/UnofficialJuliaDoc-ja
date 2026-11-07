# JIT Design and Implementation

このドキュメントでは、codegen が完了して最適化前の LLVM IR が生成された後の、Julia の JIT の設計と実装について説明します。JIT は、この IR を最適化してマシンコードにコンパイルし、現在のプロセスにリンクして実行可能にする役割を担います。

## Introduction

JIT は、コンパイルリソースの管理、コンパイル済みコードの検索、新しいコードのコンパイルを担います。主に LLVM の [On-Request-Compilation](https://llvm.org/docs/ORCv2.html)（ORCv2）技術を基盤としており、並行コンパイル、遅延コンパイル、別プロセスでのコードコンパイルなど、さまざまな便利な機能を利用できます。LLVM は LLJIT という基本的な JIT コンパイラを提供していますが、Julia は ORCv2 の API を多数直接利用して、独自の JIT コンパイラを構築しています。

## Overview

![コンパイラの処理フロー図](./img/compiler_diagram.png)

codegen は、型推論によって生成された元の Julia SSA IR から、1 つ以上の Julia 関数の IR を含む LLVM モジュールを生成します（上のコンパイラ図では「translate」と表示されています）。また、code instance と LLVM 関数名の対応関係も生成します。ただし、Julia ベースのコンパイラによって Julia IR にいくつかの最適化が適用されているものの、codegen が生成する LLVM IR には、まだ多くの最適化の余地があります。そのため、JIT はまず、LLVM モジュールに対してターゲット非依存の最適化パイプライン[^tdp]を実行します。次に、ターゲット固有の最適化とコード生成を含む、ターゲット依存の最適化パイプラインを実行し、オブジェクトファイルを出力します。最後に、生成されたオブジェクトファイルを現在のプロセスにリンクし、コードを実行可能にします。これらの処理はすべて、`src/jitlayers.cpp` 内のコードによって制御されます。

[^tdp]: これは完全にターゲット非依存のパイプラインではありません。たとえばベクトル化などの変換は、ベクトルレジスタ幅やコストモデルといったターゲット情報に依存します。また、codegen 自体もターゲット依存の前提をいくつか置いており、最適化パイプラインはその情報を活用します。

現在は、リンカーの 1 つである RuntimeDyld の制約により、最適化・コンパイル・リンクのパイプラインに同時に入れるスレッドは 1 つだけです。ただし、JIT は最適化とコンパイルの並行実行をサポートするよう設計されており、すべてのプラットフォームで RuntimeDyld が完全に置き換えられれば、将来的にこのリンカーの制約は解消される見込みです。

## Optimization Pipeline

最適化パイプラインは LLVM の新しいパスマネージャーを基盤としていますが、Julia の要件に合わせてカスタマイズされています。パイプラインは `src/pipeline.cpp` で定義されており、概ね以下の段階を順に進みます。

1. 初期の簡略化

    1. これらのパスは主に、IR を簡略化し、パターンを正規化して、後続のパスがパターンを識別しやすくするために使われます。また、分岐予測ヒントや注釈など、さまざまな intrinsic 呼び出しを、他のメタデータや IR の機能に変換します。主なパスには、[`SimplifyCFG`](https://llvm.org/docs/Passes.html#simplifycfg-simplify-the-cfg)（制御フローグラフの簡略化）、[`DCE`](https://llvm.org/docs/Passes.html#dce-dead-code-elimination)（デッドコード除去）、[`SROA`](https://llvm.org/docs/Passes.html#sroa-scalar-replacement-of-aggregates)（集成体のスカラー置換）があります。
2. 初期の最適化

    1. これらのパスは通常、実行コストが低く、主に IR 内の命令数を減らし、得られた情報を他の命令に伝播させることを目的とします。たとえば、[`EarlyCSE`](https://en.wikipedia.org/wiki/Common_subexpression_elimination) は共通部分式除去に使われ、[`InstCombine`](https://llvm.org/docs/Passes.html#instcombine-combine-redundant-instructions) と [`InstSimplify`](https://llvm.org/doxygen/classllvm_1_1InstSimplifyPass.html#details) は、演算のコストを下げるための小規模なピープホール最適化をいくつか実行します。
3. ループ最適化

    1. これらのパスはループを正規化し、簡略化します。ループは実行頻度の高いコードであることが多いため、ループ最適化は性能にとって非常に重要です。主なパスには [`LoopRotate`](https://llvm.org/docs/Passes.html#loop-rotate-rotate-loops)、[`LICM`](https://llvm.org/docs/Passes.html#licm-loop-invariant-code-motion)、[`LoopFullUnroll`](https://llvm.org/docs/Passes.html#loop-unroll-unroll-loops) があります。また、特定の境界を超えないことを証明できる [`IRCE`](https://llvm.org/doxygen/InductiveRangeCheckElimination_8cpp_source.html) パスによって、ここで一部の境界チェックも除去されます。
4. スカラー最適化

    1. スカラー最適化パイプラインには、[`GVN`](https://llvm.org/docs/Passes.html#gvn-global-value-numbering)（グローバル値番号付け）、[`SCCP`](https://llvm.org/docs/Passes.html#sccp-sparse-conditional-constant-propagation)（疎条件付き定数伝播）、および境界チェック除去の再実行など、より高コストながら強力なパスが含まれます。これらのパスは実行コストが高い一方で、大量のコードを削除できることが多く、ベクトル化の成功率と効果を高めます。高コストのパスの間には、作業量を減らすための簡略化・最適化パスもいくつか挿入されています。
5. ベクトル化

    1. [Automatic vectorization](https://en.wikipedia.org/wiki/Automatic_vectorization) は、CPU 負荷の高いコードに対して非常に強力な変換です。簡単に言えば、ベクトル化によって [single instruction on multiple data](https://en.wikipedia.org/wiki/Single_instruction,_multiple_data)（SIMD）を実行できるようになります。たとえば、8 回の加算を同時に実行できます。ただし、コードがベクトル化可能であり、かつベクトル化する価値があると証明するのは困難です。そのため、ベクトル化が有効になる状態まで IR を整えるうえで、それ以前の最適化パスが大きな役割を果たします。
6. intrinsic の低レベル化

    1. Julia は、オブジェクトの割り当て、ガベージコレクション、例外処理などのために、独自の intrinsic をいくつか挿入します。これらの intrinsic はもともと、最適化の機会を明確にするために導入されましたが、IR をマシンコードとして出力できるよう、現在は LLVM IR に低レベル化されます。
7. クリーンアップ

    1. これらのパスは最後の最適化の機会として、積和演算の伝播や除算・剰余の簡略化など、小規模な最適化を行います。また、半精度浮動小数点数をサポートしないターゲットでは、ここで半精度命令を単精度命令に低レベル化します。さらに、サニタイザーをサポートするパスも追加されます。

## Target-Dependent Optimization and Code Generation

LLVM は、特定のプラットフォームの TargetMachine 内にある同一のパイプラインで、ターゲット依存の最適化とマシンコード生成を行います。これらのパスには、命令選択、命令スケジューリング、レジスタ割り当て、マシンコード出力が含まれます。この処理の概要については LLVM のドキュメントが参考になります。パイプラインや各パスの詳細を調べるには、LLVM のソースコードが最適です。

## Linking

現在、Julia は旧来の RuntimeDyld リンカーから、新しい [JITLink](https://llvm.org/docs/JITLink.html) リンカーへの移行を進めています。JITLink には、並行リンクや再入可能なリンクなど、RuntimeDyld にはない機能がいくつかあります。一方で、現時点ではプロファイリングとの連携に十分対応できておらず、RuntimeDyld がサポートするすべてのプラットフォームにも対応していません。将来的には、JITLink が RuntimeDyld を完全に置き換える見込みです。JITLink の詳細については LLVM のドキュメントを参照してください。

## Execution

コードが現在のプロセスにリンクされると、実行可能になります。このことは、`invoke`、`specsigflags`、`specptr` の各フィールドを適切に更新することで、生成元の codeinst に通知されます。codeinst では、`invoke`、`specsigflags`、`specptr` の各フィールドを更新できます。ただし、どの時点でも、これらのフィールドの値の組み合わせがすべて呼び出し可能である必要があります。これにより、既存の codeinst を無効化せずに JIT がこれらのフィールドを更新できるため、将来的な並行 JIT の実現が可能になります。具体的には、以下の状態が有効です。

1. `invoke` が NULL、`specsigflags` が 0b00、`specptr` が NULL

    1. これは codeinst の初期状態であり、まだコンパイルされていないことを示します。
2. `invoke` が NULL 以外、`specsigflags` が 0b00、`specptr` が NULL

    1. これは、codeinst が特殊化なしでコンパイルされており、codeinst を直接呼び出す必要があることを示します。この場合、`invoke` は `specsigflags` フィールドも `specptr` フィールドも読み取りません。そのため、`invoke` ポインターを無効化せずに、これらのフィールドを変更できます。
3. `invoke` が NULL 以外、`specsigflags` が 0b10、`specptr` が NULL 以外

    1. これは codeinst がコンパイル済みであるものの、codegen によって特殊化された関数シグネチャは不要と判断されたことを示します。
4. `invoke` が NULL 以外、`specsigflags` が 0b11、`specptr` が NULL 以外

    1. これは codeinst がコンパイル済みであり、codegen によって特殊化された関数シグネチャが必要と判断されたことを示します。`specptr` フィールドには、特殊化された関数シグネチャへのポインターが格納されます。`invoke` ポインターは、`specsigflags` フィールドと `specptr` フィールドの両方を読み取ることができます。

また、更新処理中には、さまざまな中間状態が発生します。こうした状況に対応するため、codeinst の各フィールドを扱う際は、以下の書き込み・読み取りパターンを使用してください。

1. `invoke`、`specsigflags`、`specptr` に書き込む場合：

    1. specptr の古い値が NULL であることを前提に、アトミックな compare-exchange 操作を行います。この操作には、書き込みに含まれる残りのメモリ操作の順序を保証するため、少なくとも acquire-release のメモリ順序を指定してください。
    2. `specptr` が NULL 以外の場合は、書き込みを中止し、`specsigflags` のビット 0b10 が書き込まれるまで待機します。その後、必要であれば手順 1 からやり直します。
    3. `specsigflags` の新しい下位ビットを最終値に設定します。これは relaxed 書き込みでもかまいません。
    4. `invoke` ポインターを新しい最終値に設定します。`invoke` の読み取りと同期するため、少なくとも release のメモリ順序を指定する必要があります。
    5. `specsigflags` の 2 番目のビットを 1 に設定します。`specsigflags` の読み取りと同期するため、少なくとも release のメモリ順序を指定する必要があります。この手順で書き込みが完了し、すべてのフィールドが設定されたことが他のすべてのスレッドに通知されます。
2. `invoke`、`specsigflags`、`specptr` のすべてを読み取る場合：

    1. `specptr` フィールドを、任意のメモリ順序で読み取ります。
    2. `invoke` フィールドを、少なくとも acquire のメモリ順序で読み取ります。このロードを `initial_invoke` と呼びます。
    3. `initial_invoke` が NULL の場合、codeinst はまだ実行可能ではありません。`invoke` は NULL、`specsigflags` は 0b00、`specptr` は NULL として扱えます。
    4. `specptr` が NULL の場合、`initial_invoke` ポインターは、正しい実行を保証するために `specptr` に依存していてはなりません。したがって、`invoke` は NULL 以外であり、`specsigflags` は 0b00、`specptr` は NULL として扱えます。
    5. `specptr` が NULL 以外の場合、`initial_invoke` は、`specptr` を使用する最終的な `invoke` フィールドではない可能性があります。これは、`specptr` は書き込まれているものの、`invoke` はまだ書き込まれていない場合に起こり得ます。そのため、`specsigflags` の 2 番目のビットが 1 に設定されるまで、少なくとも acquire のメモリ順序でスピン待機します。
    6. `invoke` フィールドを任意のメモリ順序で再読み込みします。このロードを `final_invoke` と呼びます。
    7. `specsigflags` フィールドを任意のメモリ順序で読み取ります。
    8. `invoke` は `final_invoke`、`specsigflags` は手順 7 で読み取った値、`specptr` は手順 3 で読み取った値です。
3. `specptr` を、異なるものの同等な関数ポインターに更新する場合：

    1. 新しい関数ポインターを `specptr` に release ストアします。古い関数ポインターも引き続き有効であり、新しい関数ポインターも有効である必要があるため、ここで競合が起きても問題がないようにしてください。ポインターが `specptr` に書き込まれた後は、後で上書きされるかどうかにかかわらず、常に呼び出し可能でなければなりません。

これらのフィールドを正しく読み取る処理は、`jl_read_codeinst_invoke` に実装されています。

書き込み、読み取り、更新の手順は複雑ですが、既存の codeinst や既存の `invoke` ポインターを無効化せずに、JIT が codeinst を更新できるようにします。これにより、将来的には JIT が関数をより高い最適化レベルで再最適化できる可能性があり、関数の並行コンパイルもサポートできるようになります。
