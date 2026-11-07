# Parallel Computing

Julia は、並行・並列プログラミングを次の 4 つのカテゴリでサポートしています。

1. **非同期「タスク」またはコルーチン**:

    Julia のタスクを使うと、I/O、イベント処理、生産者・消費者プロセスなどのパターンにおいて、計算を中断したり再開したりできます。タスクは [`wait`](@ref) や [`fetch`](@ref) などの操作で同期でき、[`Channel`](@ref)s を介して通信できます。タスク自体は厳密には並列計算ではありませんが、Julia では [`Task`](@ref)s を複数のスレッドにスケジュールできます。
2. **マルチスレッド**:

    Julia の [multi-threading](@ref man-multithreading) を使うと、メモリを共有しながら、複数のスレッドまたは CPU コアでタスクを同時にスケジュールできます。これは、PC や単一の大規模マルチコアサーバーで並列処理を実現する最も簡単な方法です。Julia のマルチスレッド処理は合成可能です。マルチスレッド関数から別のマルチスレッド関数を呼び出した場合、Julia は利用可能なリソース全体でスレッドをスケジュールするため、過剰なスレッド割り当ては発生しません。
3. **分散コンピューティング**:

    分散コンピューティングでは、メモリ空間が独立した複数の Julia プロセスを実行します。これらのプロセスは、同じコンピューター上でも、複数のコンピューター上でも実行できます。標準ライブラリの [`Distributed`](@ref man-distributed) は、Julia 関数をリモートで実行する機能を提供します。この基本的な構成要素を使って、さまざまな種類の分散コンピューティング抽象化を構築できます。[`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl) などのパッケージは、その一例です。一方、[`MPI.jl`](https://github.com/JuliaParallel/MPI.jl) や [`Elemental.jl`](https://github.com/JuliaParallel/Elemental.jl) などのパッケージを使うと、既存の MPI ライブラリエコシステムを利用できます。
4. **GPU コンピューティング**:

    Julia の GPU コンパイラーを使うと、GPU 上で Julia コードをネイティブに実行できます。GPU を対象とする Julia パッケージのエコシステムも充実しています。[JuliaGPU.org](https://juliagpu.org) のウェブサイトでは、機能、対応 GPU、関連パッケージ、ドキュメントの一覧を確認できます。
