# Parallel Computing

Juliaは、並行・並列プログラミングを次の4つのカテゴリでサポートしています。

1. **非同期「タスク」またはコルーチン**:

    Juliaのタスクを使うと、I/O、イベント処理、生産者・消費者プロセスなどのパターンにおいて、計算を一時停止したり再開したりできます。タスクは[`wait`](@ref)や[`fetch`](@ref)などの操作で同期でき、[`Channel`](@ref)sを介して通信できます。タスク自体は厳密には並列計算ではありませんが、Juliaでは[`Task`](@ref)を複数のスレッドでスケジュールできます。
2. **マルチスレッド**:

    Juliaの[multi-threading](@ref man-multithreading)を使うと、メモリを共有しながら、複数のスレッドまたはCPUコアでタスクを同時にスケジュールできます。これは、PCや単一の大規模マルチコアサーバーで並列処理を実現する最も簡単な方法です。Juliaのマルチスレッドは合成可能です。あるマルチスレッド関数から別のマルチスレッド関数を呼び出した場合も、Juliaは利用可能なリソース全体でスレッドをスケジュールするため、過剰なスレッド割り当ては発生しません。
3. **分散コンピューティング**:

    分散コンピューティングでは、メモリ空間が独立した複数のJuliaプロセスを実行します。これらのプロセスは、同じコンピューター上でも、複数のコンピューター上でも実行できます。標準ライブラリの[`Distributed`](@ref man-distributed)は、Julia関数をリモートで実行する機能を提供します。この基本機能を使えば、さまざまな種類の分散コンピューティング抽象化を構築できます。[`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl)などのパッケージは、その一例です。一方、[`MPI.jl`](https://github.com/JuliaParallel/MPI.jl)や[`Elemental.jl`](https://github.com/JuliaParallel/Elemental.jl)などのパッケージを使うと、既存のMPIライブラリ群を利用できます。
4. **GPUコンピューティング**:

    JuliaのGPUコンパイラーを使うと、GPU上でJuliaコードをネイティブに実行できます。GPUを対象とするJuliaパッケージのエコシステムも充実しています。[JuliaGPU.org](https://juliagpu.org)のウェブサイトには、利用可能な機能、サポート対象のGPU、関連パッケージ、ドキュメントが掲載されています。
