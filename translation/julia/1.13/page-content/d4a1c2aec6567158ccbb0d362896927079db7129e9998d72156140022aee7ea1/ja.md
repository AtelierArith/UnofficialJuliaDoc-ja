# [Multi-Threading](@id man-multithreading)

Juliaのマルチスレッド機能については、[blog post](https://julialang.org/blog/2019/07/multithreading/)をご覧ください。

## Starting Julia with multiple threads

デフォルトでは、Juliaは実行スレッドを2つ起動します。ワーカースレッドが1つ、対話型スレッドが1つです。次のコマンドで確認できます。[`Threads.nthreads()`](@ref):

```julia
julia> Threads.nthreads(:default)
1
julia> Threads.nthreads(:interactive)
1
```

実行スレッド数は、コマンドライン引数`-t`/`--threads`、または環境変数[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS)で指定します。両方を指定した場合は、`-t`/`--threads`が優先されます。

スレッド数は整数（`--threads=4`）または`auto`（`--threads=auto`）で指定できます。`auto`は、使用するスレッド数の適切なデフォルト値を推定します（詳しくは[Command-line Options](@ref command-line-interface)を参照）。

各スレッドプールに含める`:default`スレッドと`:interactive`スレッドの数を制御する方法については、[threadpools](@ref man-threadpools)を参照してください。

!!! compat "Julia 1.5"
    コマンドライン引数`-t`/`--threads`を使うには、Julia 1.5以降が必要です。それ以前のバージョンでは、代わりに環境変数を使用してください。


!!! compat "Julia 1.7"
    環境変数[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS)の値として`auto`を使うには、Julia 1.7以降が必要です。それ以前のバージョンでは、この値は無視されます。


!!! compat "Julia 1.12"
    ワーカースレッド1つに加えて対話型スレッド1つをデフォルトで起動するようになったのは、Julia 1.12からです。`-t1`または`JULIA_NUM_THREADS=1`でスレッド数を1に設定した場合、対話型スレッドは起動されません。


Juliaをスレッド数4で起動してみましょう。

```bash
$ julia --threads 4
```

利用可能なスレッドが4つあることを確認します。

```jldoctest; filter = r"[0-9]+"
julia> Threads.nthreads()
4
```

ただし、現在実行しているのはマスタースレッドです。これを確認するには、関数[`Threads.threadid`](@ref)を使います。

```jldoctest
julia> Threads.threadid()
1
```

!!! note
    環境変数を使う場合は、Bash（Linux/macOS）で次のように設定できます。

    ```bash
    export JULIA_NUM_THREADS=4
    ```

    Linux/macOSのC shell、またはWindowsのCMDでは次のように設定します。

    ```bash
    set JULIA_NUM_THREADS=4
    ```

    WindowsのPowerShellでは次のように設定します。

    ```powershell
    $env:JULIA_NUM_THREADS=4
    ```

    Juliaを起動する*前に*設定する必要があることに注意してください。


!!! note
    `-t`/`--threads`で指定したスレッド数は、コマンドラインオプション`-p`/`--procs`または`--machine-file`を使って起動したワーカープロセスにも引き継がれます。たとえば、`julia -p2 -t2`はメインプロセス1つとワーカープロセス2つを起動し、3つすべてのプロセスでスレッドが2つ有効になります。ワーカースレッドをより細かく制御するには、[`addprocs`](@ref)を使い、`-t`/`--threads`を`exeflags`として渡してください。


### Multiple GC Threads

ガベージコレクタ（GC）は複数のスレッドを使用できます。デフォルトのスレッド数は計算用ワーカースレッド数と同じですが、コマンドライン引数`--gcthreads`または環境変数[`JULIA_NUM_GC_THREADS`](@ref JULIA_NUM_GC_THREADS)で設定することもできます。

!!! compat "Julia 1.10"
    コマンドライン引数`--gcthreads`を使うには、Julia 1.10以降が必要です。


ガベージコレクションの設定やパフォーマンス調整について詳しくは、[Memory Management and Garbage Collection](@ref man-memory-management)を参照してください。

## [Threadpools](@id man-threadpools)

プログラムのスレッドが多数のタスクの実行で忙しいと、タスクに遅延が生じ、プログラムの応答性や対話性が損なわれることがあります。これを避けるには、タスクを起動するときに[`Threads.@spawn`](@ref)、対話型タスクとして指定できます。

```julia
using Base.Threads
@spawn :interactive f()
```

対話型タスクでは、レイテンシの大きい処理を避けてください。また、実行時間の長いタスクの場合は、頻繁にyieldする必要があります。

デフォルトでは、Juliaは対話型タスクの実行用に対話型スレッドを1つ確保して起動します。この数は次の方法で変更できます。

```bash
$ julia --threads 3,1
julia> Threads.nthreads(:interactive)
1

$ julia --threads 3,0
julia> Threads.nthreads(:interactive)
0
```

同様に、環境変数[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS)も使用できます。

```bash
export JULIA_NUM_THREADS=3,1
```

これにより、`:default`スレッドプールに3つ、`:interactive`スレッドプールに1つのスレッドを持つ状態でJuliaが起動します。

```julia-repl
julia> using Base.Threads

julia> nthreadpools()
2

julia> threadpool() # the main thread is in the interactive thread pool
:interactive

julia> nthreads(:default)
3

julia> nthreads(:interactive)
1

julia> nthreads()
3
```

!!! note
    `-t1`または`JULIA_NUM_THREADS=1`でスレッド数を明示的に1に指定しても、対話型スレッドは追加されません。


!!! note
    引数なしの`nthreads`は、デフォルトプール内のスレッド数を返します。


!!! note
    Juliaの起動時に対話型スレッドを指定したかどうかによって、メインスレッドはデフォルトプールまたは対話型スレッドプールのいずれかに属します。


どちらか一方、または両方の数を`auto`に置き換えると、Juliaが適切なデフォルト値を選択します。

## The `@threads` Macro

ネイティブスレッドを使った簡単な例を試してみましょう。まず、ゼロで初期化した配列を作ります。

```jldoctest
julia> a = zeros(10)
10-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
```

この配列を4つのスレッドで同時に操作します。各スレッドが、それぞれのスレッドIDを各要素に書き込みます。

Juliaでは、[`Threads.@threads`](@ref)マクロを使って並列ループを記述できます。このマクロを`for`ループの前に付けると、そのループがマルチスレッド領域であることをJuliaに伝えます。

```julia-repl
julia> Threads.@threads for i = 1:10
           a[i] = Threads.threadid()
       end
```

反復空間はスレッド間で分割され、各スレッドは割り当てられた位置に自身のスレッドIDを書き込みます。

```julia-repl
julia> a
10-element Vector{Float64}:
 1.0
 1.0
 1.0
 2.0
 2.0
 2.0
 3.0
 3.0
 4.0
 4.0
```

[`Threads.@threads`](@ref)には、[`@distributed`](@ref)のような省略可能なreductionパラメーターがないことに注意してください。

### Using `@threads` without data-races

データ競合の概念については、["Communication and data races between threads"](@ref man-communication-and-data-races)で詳しく説明しています。ここでは、データ競合によって誤った結果や危険なエラーが発生する可能性があることを覚えておいてください。

以下の関数`sum_single`をマルチスレッド化したいとします。

```julia-repl
julia> function sum_single(a)
           s = 0
           for i in a
               s += i
           end
           s
       end
sum_single (generic function with 1 method)

julia> sum_single(1:1_000_000)
500000500000
```

単に`@threads`を追加すると、複数のスレッドが同時に`s`を読み書きするデータ競合が発生します。

```julia-repl
julia> function sum_multi_bad(a)
           s = 0
           Threads.@threads for i in a
               s += i
           end
           s
       end
sum_multi_bad (generic function with 1 method)

julia> sum_multi_bad(1:1_000_000)
70140554652
```

結果が本来の`500000500000`になっておらず、評価するたびに変わる可能性が高いことに注意してください。

これを解決するには、タスク固有のバッファーを使って合計を競合のないチャンクに分割します。ここでは`sum_single`を再利用し、内部バッファー`s`を持たせます。入力ベクトル`a`を、並列処理用に最大`nthreads()`個のチャンクに分割します。次に`Threads.@spawn`を使って、各チャンクを個別に合計するタスクを作成します。最後に、各タスクの結果を再び`sum_single`で合計します。

```julia-repl
julia> function sum_multi_good(a)
           chunks = Iterators.partition(a, cld(length(a), Threads.nthreads()))
           tasks = map(chunks) do chunk
               Threads.@spawn sum_single(chunk)
           end
           chunk_sums = fetch.(tasks)
           return sum_single(chunk_sums)
       end
sum_multi_good (generic function with 1 method)

julia> sum_multi_good(1:1_000_000)
500000500000
```

!!! note
    バッファーを`threadid()`、つまり`buffers = zeros(Threads.nthreads())`に基づいて管理してはいけません。並行実行中のタスクはyieldすることがあり、同じスレッド上で複数のタスクが同じバッファーを使ってデータ競合を起こすおそれがあるためです。また、複数のスレッドが利用可能な場合、タスクはyield時に別のスレッドへ移動することがあります。これは[task migration](@ref man-task-migration)と呼ばれます。


別の方法として、タスクやスレッド間で共有される変数にアトミック操作を使うこともできます。操作の特性によっては、こちらのほうが高い性能を得られる場合があります。

## [Communication and data-races between threads](@id man-communication-and-data-races)

Juliaのスレッドは共有メモリを介して通信できますが、正しく、かつデータ競合のないマルチスレッドコードを書くのは非常に困難です。Juliaの[`Channel`](@ref)はスレッドセーフなので、安全な通信に利用できます。また、データ競合を避けるために[locks](@ref man-using-locks)や[atomics](@ref man-atomic-operations)を使う方法を説明する節もあります。

場合によっては、Juliaは安全性違反を検出できます。特に、デッドロックや、実行中のタスクへのyieldなど、既知の危険な操作が対象です。このような場合は[`ConcurrencyViolationError`](@ref)がスローされます。

### Data-race freedom

プログラムにデータ競合がないことを保証する責任は、全面的に利用者にあります。この要件を守らない場合、ここで述べた保証は一切適用されません。観測される結果は、非常に直感に反するものになる可能性があります。

データ競合が発生すると、Juliaはメモリー安全ではありません。**別のスレッドが書き込む可能性のあるデータは、どんなデータであっても読み取る際に十分注意してください。セグメンテーション違反など、さらに深刻な問題が起きるおそれがあります。**以下は、異なるスレッドからグローバル変数にアクセスする危険な方法の例です。

```julia
Thread 1:
global b = false
global a = rand()
global b = true

Thread 2:
while !b; end
bad_read1(a) # it is NOT safe to access `a` here!

Thread 3:
while !@isdefined(a); end
bad_read2(a) # it is NOT safe to access `a` here
```

### [Using locks to avoid data-races](@id man-using-locks)

データ競合を避け、一般にスレッドセーフなコードを書くうえで重要な手段の一つが「ロック」です。ロックは取得したり解放したりできます。あるスレッドがロックを取得し、まだ解放していない場合、そのスレッドはロックを「保持している」といいます。ロックが1つだけあり、あるデータにアクセスするにはそのロックを保持する必要があるようにコードを書けば、複数のスレッドが同じデータに同時にアクセスすることを防げます。

ロックと変数の対応付けは、プログラムではなくプログラマーが行うことに注意してください。ロックと値の対応付けを支援するヘルパー型[`Base.Lockable`](@ref)があります。自分で対応関係を管理するより安全なことが多く、詳しくは[Using Base.Lockable to associate a lock and a value](@ref man-lockable)で説明しています。

たとえば、ロック`my_lock`を作成し、変数`my_variable`を変更する間、そのロックを取得できます。最も簡単な方法は、マクロ`@lock`を使うことです。

```julia-repl
julia> my_lock = ReentrantLock();

julia> my_variable = [1, 2, 3];

julia> @lock my_lock my_variable[1] = 100
100
```

別のスレッドでも同じロックと変数を使って同様のパターンを適用すれば、操作でデータ競合が起きることはありません。

上記の操作は、`lock`の関数型バージョンを使って、次の2通りの方法でも実行できます。

```julia-repl
julia> lock(my_lock) do
           my_variable[1] = 100
       end
100

julia> begin
           lock(my_lock)
           try
               my_variable[1] = 100
           finally
               unlock(my_lock)
           end
       end
100
```

3つの方法はすべて同等です。最後の方法では、ロックが必ず解放されるように明示的な`try`ブロックが必要ですが、最初の2つでは内部で処理される点に注意してください。他のスレッドからアクセスされるデータ（グローバル変数やクロージャー変数への代入など）を変更するときは、必ず上記のロックパターンを使ってください。これを怠ると、予期しない深刻な結果を招くおそれがあります。

#### [Using Base.Lockable to associate a lock and a value](@id man-lockable)

前の節で述べたように、ヘルパー型[`Base.Lockable`](@ref)を使うと、ロックと値の対応付けをプログラム上で保証できます。慣例だけで対応関係を管理するよりもエラーが起きにくく、他の人にも読みやすいため、一般にこちらの方法が推奨されます。

任意のオブジェクトを`Base.Lockable`でラップできます。

```julia-repl
julia> my_array = [];

julia> my_locked_array = Base.Lockable(my_array);
```

ロックが保持されている間は、空のインデックス表記を使って内部のオブジェクトにアクセスできます。

```julia-repl
julia> begin
           lock(my_locked_array)
           try
               push!(my_locked_array[], 1)
           finally
               unlock(my_locked_array)
           end
       end
1-element Vector{Any}:
 1
```

通常は、`lock`の第1引数に関数を渡すほうが簡単で安全です。この関数はロック解除されたオブジェクトに適用され、ロックの取得と解放は自動的に処理されます。

```julia-repl
julia> lock(x -> push!(x, 2), my_locked_array);

julia> lock(display, my_locked_array)
2-element Vector{Any}:
 1
 2

julia> lock(my_locked_array) do x
           x[1] = π
           display(x)
       end
2-element Vector{Any}:
 π = 3.1415926535897...
 2
```

### [Atomic Operations](@id man-atomic-operations)

Juliaでは、値を*アトミック*に、つまりスレッドセーフな方法で読み書きし、[race conditions](https://en.wikipedia.org/wiki/Race_condition)を避けることができます。プリミティブ型でなければならない値を[`Threads.Atomic`](@ref)でラップすると、この方法でアクセスする必要があることを示せます。例を見てみましょう。

```julia-repl
julia> i = Threads.Atomic{Int}(0);

julia> ids = zeros(4);

julia> old_is = zeros(4);

julia> Threads.@threads for id in 1:4
           old_is[id] = Threads.atomic_add!(i, id)
           ids[id] = id
       end

julia> old_is
4-element Vector{Float64}:
 0.0
 1.0
 7.0
 3.0

julia> i[]
 10

julia> ids
4-element Vector{Float64}:
 1.0
 2.0
 3.0
 4.0
```

アトミックの指定なしで加算していた場合、競合状態によって誤った結果になった可能性があります。競合を避けなかった場合に起こりうる例を示します。

```julia-repl
julia> using Base.Threads

julia> Threads.nthreads()
4

julia> acc = Ref(0)
Base.RefValue{Int64}(0)

julia> @threads for i in 1:1000
          acc[] += 1
       end

julia> acc[]
926

julia> acc = Atomic{Int64}(0)
Atomic{Int64}(0)

julia> @threads for i in 1:1000
          atomic_add!(acc, 1)
       end

julia> acc[]
1000
```

#### [Per-field atomics](@id man-atomics)

[`@atomic`](@ref Base.@atomic)、[`@atomicswap`](@ref Base.@atomicswap)、[`@atomicreplace`](@ref Base.@atomicreplace)の各マクロや、[`@atomiconce`](@ref Base.@atomiconce)マクロを使えば、より細かい単位でアトミック操作を行うこともできます。

メモリーモデルの詳細や設計に関するその他の情報は、後日正式に公開される予定の[Julia Atomics Manifesto](https://gist.github.com/vtjnash/11b0031f2e2a66c9c24d33e810b34ec0)に記載されています。

構造体の宣言では、任意のフィールドに`@atomic`を付けられます。そのフィールドへの書き込みには`@atomic`も付け、定義済みのアトミック順序（`:monotonic`、`:acquire`、`:release`、`:acquire_release`、または`:sequentially_consistent`）のいずれかを使う必要があります。アトミックフィールドの読み取りにもアトミック順序の制約を指定できます。指定しない場合は、単調（relaxed）順序で読み取られます。

!!! compat "Julia 1.7"
    フィールド単位のアトミック操作を使うには、Julia 1.7以降が必要です。


## Side effects and mutable function arguments

マルチスレッドを使う場合、[pure](https://en.wikipedia.org/wiki/Pure_function)ではない関数に注意が必要です。誤った結果になる可能性があるためです。たとえば、慣例上[name ending with `!`](@ref bang-convention)を持つ関数は引数を変更するため、純粋関数ではありません。

## @threadcall

[`ccall`](@ref)経由で呼び出すものなどの外部ライブラリは、JuliaのタスクベースのI/O機構と相性がよくありません。Cライブラリがブロッキング操作を行うと、その呼び出しが戻るまでJuliaのスケジューラーは他のタスクを実行できません（JuliaをコールバックしてyieldするカスタムCコードや、`jl_yield()`、つまり[`yield`](@ref)に相当するC関数を呼び出すCコードは例外です）。

このような状況で実行の停滞を避けるには、マクロ[`@threadcall`](@ref)を使います。これにより、C関数は別スレッドで実行されます。デフォルトサイズが4のスレッドプールが使われ、そのサイズは環境変数`UV_THREADPOOL_SIZE`で制御します。空きスレッドを待っている間、およびスレッドが利用可能になってから関数の実行が終わるまで、要求元のタスク（Juliaのメインイベントループ上）は他のタスクに実行を譲ります。`@threadcall`は実行が完了するまで戻らないことに注意してください。そのため、ユーザーから見ると、他のJulia APIと同様にブロッキング呼び出しです。

呼び出す関数がJuliaをコールバックしないことが非常に重要です。コールバックするとセグメンテーション違反が発生します。

`@threadcall`は、今後のJuliaのバージョンで削除または変更される可能性があります。

## Caveats

現時点では、Juliaランタイムや標準ライブラリのほとんどの操作は、ユーザーコードにデータ競合がなければ、スレッドセーフに使用できます。ただし、一部の領域ではスレッド対応の安定化作業が続いています。マルチスレッドプログラミングには本質的に多くの難しさがあり、スレッドを使うプログラムで異常または望ましくない動作（クラッシュや不可解な結果など）が起きた場合は、まずスレッド間の相互作用を疑うべきです。

Juliaでスレッドを使う際には、次の制限や注意事項を把握しておいてください。

  * Baseのコレクション型を複数のスレッドから同時に使い、そのうち少なくとも1つのスレッドがコレクションを変更する場合は、手動でロックする必要があります（よくある例として、配列に対する`push!`や、`Dict`への項目の挿入があります）。
  * [`@spawn`](@ref Threads.@spawn)が使うスケジュールは非決定的であり、それに依存してはいけません。
  * 計算負荷が高くメモリーを割り当てないタスクは、メモリーを割り当てている他のスレッドでガベージコレクションが実行されるのを妨げることがあります。この場合、GCを実行できるように`GC.safepoint()`を手動で呼び出す必要があるかもしれません。この制限は将来解消される予定です。
  * `include`などのトップレベル操作や、型、メソッド、モジュール定義の`eval`を並列実行しないでください。
  * ライブラリが登録したファイナライザーは、スレッドを有効にすると正常に動作しなくなる場合があります。スレッドを安心して広く利用できるようになるには、エコシステム全体で移行作業が必要になるかもしれません。詳しくは[the safe use of finalizers](@ref man-finalizers)の節を参照してください。

## [Task Migration](@id man-task-migration)

タスクは、あるスレッドで実行を開始した後、yieldすると別のスレッドに移動することがあります。

このようなタスクは[`@spawn`](@ref Threads.@spawn)または[`@threads`](@ref Threads.@threads)で起動されている場合があります。ただし、`@threads`のスケジュールオプション`:static`を使うと、スレッドIDは固定されます。

そのため、ほとんどの場合、タスク内で[`threadid()`](@ref Threads.threadid)を定数として扱うべきではありません。また、バッファーや状態を持つオブジェクトのベクターのインデックスとして使うべきでもありません。

!!! compat "Julia 1.7"
    タスクの移行はJulia 1.7で導入されました。それ以前のタスクは、起動されたスレッドに常にとどまっていました。


## [Safe use of Finalizers](@id man-finalizers)

ファイナライザーは任意のコードを中断する可能性があるため、グローバル状態とのやり取りには細心の注意が必要です。しかし、ファイナライザーを使う主な理由はグローバル状態を更新することです（純粋関数をファイナライザーにしても、一般にほとんど意味がありません）。このため、少々厄介な問題が生じます。対処方法はいくつかあります。

1. シングルスレッドの場合、内部C関数`jl_gc_enable_finalizers`を呼び出して、クリティカル領域内でファイナライザーがスケジュールされないようにできます。内部では、一部の関数（Cロックなど）で、特定の操作（パッケージのインクリメンタルな読み込み、コード生成など）中の再帰を防ぐために使われています。ロックとこのフラグを組み合わせることで、ファイナライザーを安全に扱えます。
2. 2つ目の方法は、Baseのいくつかの箇所で使われているもので、ロックを再帰的に取得せずに済むようになるまで、ファイナライザーの実行を明示的に遅らせます。次の例は、この方法を`Distributed.finalize_ref`に適用する方法を示しています。

   ```julia
   function finalize_ref(r::AbstractRemoteRef)
       if r.where > 0 # Check if the finalizer is already run
           if islocked(client_refs) || !trylock(client_refs)
               # delay finalizer for later if we aren't free to acquire the lock
               finalizer(finalize_ref, r)
               return nothing
           end
           try # `lock` should always be followed by `try`
               if r.where > 0 # Must check again here
                   # Do actual cleanup here
                   r.where = 0
               end
           finally
               unlock(client_refs)
           end
       end
       nothing
   end
   ```
3. 関連する3つ目の方法は、yieldしないキューを使うことです。Baseには現在、ロックフリーキューが実装されていませんが、`Base.IntrusiveLinkedListSynchronized{T}`が適しています。イベントループを使うコードでは、この方法が有効なことがよくあります。たとえば、`Gtk.jl`はこの方法でライフタイムの参照カウントを管理しています。この方法では、`finalizer`内で明示的な処理を行わず、より安全なタイミングで実行するためにキューへ追加します。実際、Juliaのタスクスケジューラーもこの方法を使っているため、ファイナライザーを`x -> @spawn do_cleanup(x)`として定義するのは、この方法の一例です。ただし、`do_cleanup`がどのスレッドで実行されるかは制御できないため、`do_cleanup`では依然としてロックを取得する必要があります。独自のキューを実装すれば、キューを自分のスレッドからのみ処理するよう明示できるため、その必要はありません。
