# Custom LLVM Passes

JuliaにはいくつかのカスタムLLVMパスがあります。大まかに言えば、これらはJuliaのセマンティクスを維持するために実行する必要があるパスと、Juliaのセマンティクスを利用してLLVM IRを最適化するパスに分類できます。

## Semantic Passes

これらのパスは、LLVM IRをCPU上で実行可能なコードに変換するために使用されます。彼らの主な目的は、コード生成によってより単純なIRを出力できるようにし、それによって他のLLVMパスが一般的なパターンを最適化できるようにすることです。

### CPUFeatures

  * ファイル名: `llvm-cpufeatures.cpp`
  * クラス名: `CPUFeaturesPass`
  * Opt Name: `module(CPUFeatures)`

このパスは、`julia.cpu.have_fma.(f32|f64)` の内部関数を、ターゲットアーキテクチャと関数に存在するターゲット機能に応じて、true または false に低下させます。この内部関数は、迅速な [fused multiply-add](https://en.wikipedia.org/wiki/Multiply%E2%80%93accumulate_operation#Fused_multiply%E2%80%93add) 操作に依存するアルゴリズムを使用する方が、そうした命令に依存しない標準アルゴリズムを使用するよりも良いかどうかを判断するためにしばしば使用されます。

### DemoteFloat16

  * ファイル名: `llvm-demote-float16.cpp`
  * クラス名: `DemoteFloat16Pass`
  * オプション名 `function(DemoteFloat16)`

このパスは、[float16](https://en.wikipedia.org/wiki/Half-precision_floating-point_format) 操作を、float16 操作をネイティブにサポートしないアーキテクチャ上で float32 操作に置き換えます。これは、任意の float16 操作の周りに `fpext` および `fptrunc` 命令を挿入することによって行われます。ネイティブ float16 操作をサポートするアーキテクチャでは、このパスはノーオプです。

### LateGCLowering

  * ファイル名: `llvm-late-gc-lowering.cpp`
  * クラス名: `LateLowerGCPass`
  * Opt Name: `function(LateLowerGCFrame)`

このパスは、GCセーフポイント間のポインタを追跡するために必要なほとんどのGCルーティング作業を実行します。また、いくつかのインストリンシックを対応する命令変換に低下させ、以前に確立された非整数不変を破ることが許可されています（`pointer_from_objref`はここで`ptrtoint`命令に低下されます）。このパスは、任意のセーフポイントで生存しているオブジェクトの数を最小限に抑えるためのデータフローアルゴリズムのため、すべてのカスタムJuliaパスの中で最も多くの時間を占めることが一般的です。

### FinalGCLowering

  * ファイル名: `llvm-final-gc-lowering.cpp`
  * クラス名: `FinalLowerGCPass`
  * オプション名: `module(FinalLowerGC)`

このパスは、`libjulia`ライブラリ内の関数をターゲットにしたいくつかの最後のインストリンシックを最終形に変換します。これを`LateGCLowering`から分離することで、他のバックエンド（GPUコンパイル）がこれらのインストリンシックに対して独自のカスタムローワリングを提供できるようになり、Juliaパイプラインをそれらのバックエンドでも使用できるようにします。

### LowerHandlers

  * ファイル名: `llvm-lower-handlers.cpp`
  * クラス名: `LowerExcHandlersPass`
  * Opt Name: `function(LowerExcHandlers)`

このパスは、例外処理のインストリンシックを、実際に例外を処理する際に呼び出されるランタイム関数への呼び出しに変換します。

### RemoveNI

  * ファイル名: `llvm-remove-ni.cpp`
  * クラス名: `RemoveNIPass`
  * Opt Name: `module(RemoveNI)`

このパスは、モジュールのデータレイアウト文字列から非整数アドレス空間を削除します。これにより、バックエンドはJuliaのカスタムアドレス空間を直接機械コードに変換でき、アドレス空間0へのポインタ操作のすべてを書き直すというコストのかかる作業を回避できます。

### SIMDLoop

  * ファイル名: `llvm-simdloop.cpp`
  * クラス名: `LowerSIMDLoopPass`
  * Opt Name: `loop(LowerSIMDLoop)`

このパスは `@simd` アノテーションの主要なドライバーとして機能します。コード生成はループのバックブランチに `!llvm.loopid` マーカーを挿入し、このパスはそれを使用して元々 `@simd` でマークされていたループを特定します。次に、このパスはリデュースを形成する浮動小数点演算のチェーンを探し、再関連付け（およびベクトル化）を許可するために `contract` および `reassoc` のファストマスフラグを追加します。このパスはループ情報や推論の正確性を保持しないため、驚くべき方法でJuliaのセマンティクスに違反する可能性があります。ループが `ivdep` でもアノテーションされている場合、このパスはループにループキャリード依存性がないとマークします（ユーザーのアノテーションが不正確であったり、誤ったループに適用された場合、結果の動作は未定義になります）。

### LowerPTLS

  * ファイル名: `llvm-ptls.cpp`
  * クラス名: `LowerPTLSPass`
  * オプション名: `module(LowerPTLSPass)`

このパスは、スレッドローカルのJuliaの内部関数をアセンブリ命令に変換します。Juliaは、ガーベジコレクションやマルチスレッドタスクスケジューリングのためにスレッドローカルストレージに依存しています。システムイメージやパッケージイメージのためにコードをコンパイルする際、このパスは内部関数への呼び出しを、ロード時に初期化されるグローバル変数からのロードに置き換えます。

もしcodegenが`swiftself`引数と呼び出し規約を持つ関数を生成する場合、このパスは`swiftself`引数がpgcstackであると仮定し、その引数でintrinsicsを置き換えます。これにより、スレッドローカルストレージアクセスが遅いアーキテクチャでの速度向上が提供されます。

### RemoveAddrspaces

  * ファイル名: `llvm-remove-addrspaces.cpp`
  * クラス名: `RemoveAddrspacesPass`
  * Opt Name: `module(アドレス空間を削除)`

このパスは、あるアドレス空間のポインタを別のアドレス空間に名前変更します。これは、LLVM IRからJulia特有のアドレス空間を削除するために使用されます。

### RemoveJuliaAddrspaces

  * ファイル名: `llvm-remove-addrspaces.cpp`
  * クラス名: `RemoveJuliaAddrspacesPass`
  * Opt Name: `module(RemoveJuliaAddrspaces)`

このパスは、LLVM IRからJulia特有のアドレス空間を削除します。主に、LLVM IRをより整理された形式で表示するために使用されます。内部的には、RemoveAddrspacesパスを基に実装されています。

### Multiversioning

  * ファイル名: `llvm-multiversioning.cpp`
  * クラス名: `MultiVersioningPass`
  * Opt Name: `module(JuliaMultiVersioning)`

このパスは、異なるアーキテクチャでの実行に最適化された関数を作成するためにモジュールに変更を加えます（詳細については sysimg.md と pkgimg.md を参照してください）。実装の観点からは、関数をクローンし、それらに異なるターゲット固有の属性を適用して、オプティマイザがそのプラットフォームのベクトル化や命令スケジューリングなどの高度な機能を使用できるようにします。また、Julia イメージローダーが、ローダーが実行されているアーキテクチャに基づいて呼び出すべき関数の適切なバージョンを選択できるようにするためのインフラストラクチャも作成します。ターゲット固有の属性は、コンパイル中に [`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) 環境変数から派生する `julia.mv.specs` モジュールフラグによって制御されます。このパスは、値が 1 の `julia.mv.enable` モジュールフラグを提供することによっても有効にする必要があります。

!!! warning
    `llvmcall`の使用はマルチバージョニングと共に危険です。`llvmcall`は、通常はJulia APIによって公開されていない機能へのアクセスを可能にし、そのため通常はすべてのアーキテクチャで利用できません。マルチバージョニングが有効で、`llvmcall`式によって要求される機能をサポートしていないターゲットアーキテクチャのためにコード生成が要求されると、LLVMはおそらくエラーを出し、恐らくは中断し、メッセージ`LLVM ERROR: Do not know how to split the result of this operator!`が表示されるでしょう。


### GCInvariantVerifier

  * ファイル名: `llvm-gc-invariant-verifier.cpp`
  * クラス名: `GCInvariantVerifierPass`
  * オプション名: `module(GCInvariantVerifier)`

このパスは、LLVM IRに関するJuliaの不変条件を検証するために使用されます。これには、Juliaの[non-integral address spaces](https://llvm.org/docs/LangRef.html#non-integral-pointer-type) [^nislides]における`ptrtoint`の不存在や、祝福された`addrspacecast`命令のみの存在（Tracked -> Derived、0 -> Trackedなど）が含まれます。IRに対して変換は行いません。

[^nislides]: https://llvm.org/devmtg/2015-02/slides/chisnall-pointers-not-int.pdf

## Optimization Passes

これらのパスは、LLVMが自ら行わないLLVM IRの変換を実行するために使用されます。例えば、高速数学フラグの伝播、エスケープ分析、Julia特有の内部関数に対する最適化などです。これらは、これらの最適化を実行するためにJuliaの意味論に関する知識を利用します。

### CombineMulAdd

  * ファイル名: `llvm-muladd.cpp`
  * クラス名: `CombineMulAddPass`
  * Opt Name: `function(CombineMulAdd)`

このパスは、通常の `fmul` と高速な `fadd` の特定の組み合わせを、契約 `fmul` と高速な `fadd` に最適化するためのものです。これは後にバックエンドによって [fused multiply-add](https://en.wikipedia.org/wiki/Multiply%E2%80%93accumulate_operation#Fused_multiply%E2%80%93add) 命令に最適化され、より多くの [unpredictable semantics](https://simonbyrne.github.io/notes/fastmath/) のコストで、かなり高速な操作を提供することができます。

!!! note
    この最適化は、`fmul` が単一の使用を持つ場合、つまり高速な `fadd` の場合にのみ発生します。


### AllocOpt

  * ファイル名: `llvm-alloc-opt.cpp`
  * クラス名: `AllocOptPass`
  * オプション名: `function(AllocOpt)`

Julia does not have the concept of a program stack as a place to allocate mutable objects. However, allocating objects on the stack reduces GC pressure and is critical for GPU compilation. Thus, `AllocOpt` performs heap to stack conversion of objects that it can prove do not [escape](https://en.wikipedia.org/wiki/Escape_analysis) the current function. It also performs a number of other optimizations on allocations, such as removing allocations that are never used, optimizing typeof calls to freshly allocated objects, and removing stores to allocations that are immediately overwritten. The escape analysis implementation is located in `llvm-alloc-helpers.cpp`. Currently, this pass does not use information from `EscapeAnalysis.jl`, though that may change in the future.

### PropagateJuliaAddrspaces

  * ファイル名: `llvm-propagate-addrspaces.cpp`
  * クラス名: `PropagateJuliaAddrspacesPass`
  * オプション名: `function(PropagateJuliaAddrspaces)`

このパスは、ポインタ上の操作を通じてJulia特有のアドレス空間を伝播させるために使用されます。LLVMは最適化によってaddrspacecast命令を導入したり削除したりすることは許可されていないため、このパスは冗長なaddrspaceキャストを排除し、操作をJuliaアドレス空間の同等のものに置き換える役割を果たします。Juliaのアドレス空間に関する詳細については、（TODO llvm.mdへのリンク）を参照してください。

### JuliaLICM

  * ファイル名: `llvm-julia-licm.cpp`
  * クラス名: `JuliaLICMPass`
  * Opt Name: `loop(JuliaLICM)`

このパスは、ループからJulia特有の内部関数を引き上げるために使用されます。具体的には、次の変換を行います：

1. ループ内で保存されたオブジェクトがループ不変である場合、`gc_preserve_begin`を持ち上げ、`gc_preserve_end`をループの外に移動させます。

    1. ループ内で保持されるオブジェクトはループの期間中保持される可能性が高いため、この変換はIR内の`gc_preserve_begin`/`gc_preserve_end`ペアの数を減らすことができます。これにより、`LateLowerGCPass`が特定のオブジェクトがどこで保持されているかを特定しやすくなります。
2. 不変オブジェクトによるホイスト書き込みバリア

    1. ここでは、オブジェクトが属することができる世代が2つだけであると仮定します。それを考慮すると、同じオブジェクトのペアに対して書き込みバリアは1回だけ実行される必要があります。したがって、書き込み対象のオブジェクトがループ不変である場合、書き込みバリアをループの外に持ち上げることができます。
3. ループからエスケープしない場合は、割り当てをループの外に持ち上げる

    1. ここでは、`AllocOptPass`で使用されるのと同じ、非常に保守的なエスケープの定義を使用します。この変換は、割り当てが関数全体からエスケープする場合でも、IR内の割り当ての数を減らすことができます。

!!! note
    このパスは、LLVMの [MemorySSA](https://llvm.org/docs/MemorySSA.html) ([Short Video](https://www.youtube.com/watch?v=bdxWmryoHak), [Longer Video](https://www.youtube.com/watch?v=1e5y6WDbXCQ)) および [ScalarEvolution](https://baziotis.cs.illinois.edu/compilers/introduction-to-scalar-evolution.html) ([Newer Slides](https://llvm.org/devmtg/2018-04/slides/Absar-ScalarEvolution.pdf) [Older Slides](https://llvm.org/devmtg/2009-10/ScalarEvolutionAndLoopOptimization.pdf)) 分析を保存するために必要です。

