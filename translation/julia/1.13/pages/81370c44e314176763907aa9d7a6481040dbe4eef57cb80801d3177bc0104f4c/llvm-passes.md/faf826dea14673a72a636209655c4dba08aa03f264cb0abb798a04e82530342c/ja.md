# Custom LLVM Passes

Juliaには、独自のLLVMパスがいくつかあります。大きく分けると、Juliaのセマンティクスを維持するために実行が必須のパスと、Juliaのセマンティクスを利用してLLVM IRを最適化するパスに分類できます。

## Semantic Passes

これらのパスは、LLVM IRをCPU上で実行可能なコードに変換するために使われます。主な目的は、コード生成でより単純なIRを出力できるようにすることです。これにより、ほかのLLVMパスが一般的なパターンを最適化しやすくなります。

### CPUFeatures

  * ファイル名: `llvm-cpufeatures.cpp`
  * クラス名: `CPUFeaturesPass`
  * 最適化名: `module(CPUFeatures)`

このパスは、`julia.cpu.have_fma.(f32|f64)` intrinsicを、ターゲットアーキテクチャと関数に設定されたターゲット機能に応じて、trueまたはfalseに変換します。このintrinsicは、高速な[fused multiply-add](https://en.wikipedia.org/wiki/Multiply%E2%80%93accumulate_operation#Fused_multiply%E2%80%93add)命令に依存するアルゴリズムを使うほうが、そのような命令に依存しない標準的なアルゴリズムを使うよりも適切かどうかを判定するためによく使われます。

### DemoteFloat16

  * ファイル名: `llvm-demote-float16.cpp`
  * クラス名: `DemoteFloat16Pass`
  * 最適化名: `function(DemoteFloat16)`

このパスは、float16演算をネイティブにサポートしないアーキテクチャ上で、[float16](https://en.wikipedia.org/wiki/Half-precision_floating-point_format)演算をfloat32演算に置き換えます。そのために、float16演算の前後に`fpext`命令と`fptrunc`命令を挿入します。float16演算をネイティブにサポートするアーキテクチャでは、このパスは何も行いません。

### LateGCLowering

  * ファイル名: `llvm-late-gc-lowering.cpp`
  * クラス名: `LateLowerGCPass`
  * 最適化名: `function(LateLowerGCFrame)`

このパスは、GCセーフポイント間でポインターを追跡するために必要なGCルート設定の大部分を行います。また、いくつかのintrinsicを対応する命令変換にlowerし、先に確立された非整数型の不変条件に違反することが許されています（ここでは`pointer_from_objref`が`ptrtoint`命令にlowerされます）。セーフポイントで生存するオブジェクトの数を最小限に抑えるデータフローアルゴリズムを使うため、通常、このパスはJulia独自の全パスの中で最も実行時間が長くなります。

### FinalGCLowering

  * ファイル名: `llvm-final-gc-lowering.cpp`
  * クラス名: `FinalLowerGCPass`
  * 最適化名: `module(FinalLowerGC)`

このパスは、`libjulia`ライブラリ内の関数を対象に、残りのいくつかのintrinsicを最終形にlowerします。この処理を`LateGCLowering`から分離することで、ほかのバックエンド（GPUコンパイルなど）がこれらのintrinsic用に独自のloweringを提供できるようになり、Juliaのパイプラインをそれらのバックエンドでも利用できます。

### RemoveNI

  * ファイル名: `llvm-remove-ni.cpp`
  * クラス名: `RemoveNIPass`
  * 最適化名: `module(RemoveNI)`

このパスは、モジュールのデータレイアウト文字列から非整数型アドレス空間を取り除きます。これにより、すべてのポインター演算をアドレス空間0に変換する高コストな書き換えを行わずに、バックエンドがJulia独自のアドレス空間を直接機械語にlowerできるようになります。

### SIMDLoop

  * ファイル名: `llvm-simdloop.cpp`
  * クラス名: `LowerSIMDLoopPass`
  * 最適化名: `loop(LowerSIMDLoop)`

このパスは、`@simd`アノテーションを処理する主なドライバーです。コード生成では、ループの後方分岐に`!llvm.loopid`マーカーを挿入します。このパスはそのマーカーを使って、もともと`@simd`でマークされていたループを特定します。次に、reductionを構成する浮動小数点演算の連鎖を探し、再結合（ひいてはベクトル化）を可能にするため、`contract`および`reassoc`のfast mathフラグを追加します。このパスはループ情報も推論の正しさも保持しないため、予期しない形でJuliaのセマンティクスに違反する可能性があります。ループに`ivdep`も付与されている場合、このパスはそのループにループ間依存がないものとしてマークします（ユーザーのアノテーションが誤っている場合、または誤ったループに適用された場合、結果の動作は未定義です）。

### LowerPTLS

  * ファイル名: `llvm-ptls.cpp`
  * クラス名: `LowerPTLSPass`
  * 最適化名: `module(LowerPTLSPass)`

このパスは、スレッドローカルなJuliaのintrinsicをアセンブリ命令にlowerします。Juliaは、ガベージコレクションとマルチスレッドのタスクスケジューリングにスレッドローカルストレージを利用します。システムイメージやパッケージイメージ用のコードをコンパイルする場合、このパスはintrinsicの呼び出しを、ロード時に初期化されるグローバル変数からのロードに置き換えます。

コード生成によって`swiftself`引数と呼び出し規約を持つ関数が生成された場合、このパスは`swiftself`引数がpgcstackであるとみなし、intrinsicをその引数に置き換えます。これにより、スレッドローカルストレージへのアクセスが遅いアーキテクチャで高速化できます。

### RemoveAddrspaces

  * ファイル名: `llvm-remove-addrspaces.cpp`
  * クラス名: `RemoveAddrspacesPass`
  * 最適化名: `module(RemoveAddrspaces)`

このパスは、あるアドレス空間にあるポインターを別のアドレス空間に移します。LLVM IRからJulia固有のアドレス空間を取り除くために使われます。

### RemoveJuliaAddrspaces

  * ファイル名: `llvm-remove-addrspaces.cpp`
  * クラス名: `RemoveJuliaAddrspacesPass`
  * 最適化名: `module(RemoveJuliaAddrspaces)`

このパスは、LLVM IRからJulia固有のアドレス空間を取り除きます。主に、LLVM IRをより見やすく表示するために使われます。内部的には、RemoveAddrspacesパスを基に実装されています。

### Multiversioning

  * ファイル名: `llvm-multiversioning.cpp`
  * クラス名: `MultiVersioningPass`
  * 最適化名: `module(JuliaMultiVersioning)`

このパスは、モジュールを変更して、異なるアーキテクチャ上での実行に最適化された関数を作成します（詳しくはsysimg.mdとpkgimg.mdを参照してください）。実装上は、関数を複製し、それぞれに異なるターゲット固有属性を適用することで、オプティマイザーがそのプラットフォーム向けのベクトル化や命令スケジューリングなどの高度な機能を利用できるようにします。また、Juliaのイメージローダーが、実行中のアーキテクチャに応じて適切な関数バージョンを選択して呼び出せるようにする仕組みも作成します。ターゲット固有属性は`julia.mv.specs`モジュールフラグで制御されます。このフラグはコンパイル時に[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET)環境変数から設定されます。また、このパスを有効にするには、値が1の`julia.mv.enable`モジュールフラグも指定する必要があります。

!!! warning
    マルチバージョニングと併用する場合、`llvmcall`の使用には注意が必要です。`llvmcall`を使うと、通常はJulia APIから公開されていない機能にアクセスできます。そのため、すべてのアーキテクチャで利用できるとは限りません。マルチバージョニングが有効な状態で、`llvmcall`式が必要とする機能をサポートしないターゲットアーキテクチャ向けにコード生成を要求すると、LLVMはおそらくエラーを出します。多くの場合、abortとメッセージ`LLVM ERROR: Do not know how to split the result of this operator!`を伴います。


### GCInvariantVerifier

  * ファイル名: `llvm-gc-invariant-verifier.cpp`
  * クラス名: `GCInvariantVerifierPass`
  * 最適化名: `module(GCInvariantVerifier)`

このパスは、LLVM IRに関するJuliaの不変条件を検証します。たとえば、Juliaの[non-integral address spaces](https://llvm.org/docs/LangRef.html#non-integral-pointer-type) [^nislides]に`ptrtoint`が存在しないことや、許可された`addrspacecast`命令（Tracked -> Derived、0 -> Trackedなど）のみが存在することを検証します。IRの変換は行いません。

[^nislides]: https://llvm.org/devmtg/2015-02/slides/chisnall-pointers-not-int.pdf

## Optimization Passes

これらのパスは、fast mathフラグの伝播、エスケープ解析、Julia固有の内部関数の最適化など、LLVM自身では行わないLLVM IRの変換に使われます。Juliaのセマンティクスに関する知識を利用して、これらの最適化を行います。

### AllocOpt

  * ファイル名: `llvm-alloc-opt.cpp`
  * クラス名: `AllocOptPass`
  * 最適化名: `function(AllocOpt)`

Juliaには、変更可能なオブジェクトを割り当てる場所としてのプログラムスタックという概念がありません。しかし、オブジェクトをスタックに割り当てるとGCの負荷が軽減され、GPUコンパイルに不可欠です。そのため、`AllocOpt`は、現在の関数から[escape](https://en.wikipedia.org/wiki/Escape_analysis)しないと証明できるオブジェクトを、ヒープからスタックへ移します。また、使われない割り当ての削除、新たに割り当てたオブジェクトに対するtypeof呼び出しの最適化、直後に上書きされる割り当てへのストアの削除など、割り当てに関するほかの最適化も行います。エスケープ解析の実装は`llvm-alloc-helpers.cpp`にあります。現時点では、このパスは`EscapeAnalysis.jl`の情報を利用しませんが、将来的には変わる可能性があります。

### PropagateJuliaAddrspaces

  * ファイル名: `llvm-propagate-addrspaces.cpp`
  * クラス名: `PropagateJuliaAddrspacesPass`
  * 最適化名: `function(PropagateJuliaAddrspaces)`

このパスは、ポインターに対する演算を通じてJulia固有のアドレス空間を伝播させます。LLVMの最適化ではaddrspacecast命令を追加または削除できないため、このパスは演算をJuliaのアドレス空間における同等の演算に置き換え、冗長なaddrspace castを取り除きます。Juliaのアドレス空間について詳しくは、(TODO link to llvm.md)を参照してください。

### JuliaLICM

  * ファイル名: `llvm-julia-licm.cpp`
  * クラス名: `JuliaLICMPass`
  * 最適化名: `loop(JuliaLICM)`

このパスは、Julia固有のintrinsicをループの外へ移動します。具体的には、次の変換を行います。

1. 保持されるオブジェクトがループ不変である場合、`gc_preserve_begin`をループの外へ移動し、`gc_preserve_end`をループの外へsinkします。

    1. ループ内で保持されるオブジェクトは、ループの実行中ずっと保持される可能性が高いため、この変換によってIR内の`gc_preserve_begin`/`gc_preserve_end`のペア数を減らせます。これにより、`LateLowerGCPass`が特定のオブジェクトの保持箇所を特定しやすくなります。
2. 不変オブジェクトに対するライトバリアをループの外へ移動する

    1. オブジェクトが属する世代は2つだけだと仮定します。この場合、同じオブジェクトの組み合わせに対してライトバリアを実行するのは一度だけで十分です。そのため、書き込み先のオブジェクトがループ不変であれば、ライトバリアをループの外へ移動できます。
3. ループからエスケープしない割り当てをループの外へ移動する

    1. ここでは、`AllocOptPass`と同じ、非常に保守的なエスケープの定義を使います。この変換により、割り当てが関数全体からエスケープする場合でも、IR内の割り当て数を減らせます。

!!! note
    このパスは、LLVMの[MemorySSA](https://llvm.org/docs/MemorySSA.html)（[Short Video](https://www.youtube.com/watch?v=bdxWmryoHak)、[Longer Video](https://www.youtube.com/watch?v=1e5y6WDbXCQ)）および[ScalarEvolution](https://baziotis.cs.illinois.edu/compilers/introduction-to-scalar-evolution.html)（[Newer Slides](https://llvm.org/devmtg/2018-04/slides/Absar-ScalarEvolution.pdf) [Older Slides](https://llvm.org/devmtg/2009-10/ScalarEvolutionAndLoopOptimization.pdf)）解析を保持するために必要です。

