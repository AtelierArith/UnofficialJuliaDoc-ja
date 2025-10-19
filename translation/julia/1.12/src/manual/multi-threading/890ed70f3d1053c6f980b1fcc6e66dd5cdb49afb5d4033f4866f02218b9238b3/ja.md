# [Multi-Threading](@id man-multithreading)

この [blog post](https://julialang.org/blog/2019/07/multithreading/) を訪れて、Juliaのマルチスレッド機能のプレゼンテーションをご覧ください。

## Starting Julia with multiple threads

デフォルトでは、Juliaは2つの実行スレッドで起動します。1つはワーカースレッド、もう1つはインタラクティブスレッドです。これは、コマンド [`Threads.nthreads()`](@ref) を使用することで確認できます。

```julia
julia> Threads.nthreads(:default)
1
julia> Threads.nthreads(:interactive)
1
```

実行スレッドの数は、`-t`/`--threads` コマンドライン引数を使用するか、[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS) 環境変数を使用することで制御されます。両方が指定されている場合、`-t`/`--threads` が優先されます。

スレッドの数は整数（`--threads=4`）として指定することも、`auto`（`--threads=auto`）として指定することもできます。ここで、`auto`は使用するのに便利なデフォルトのスレッド数を推測しようとします（詳細については[Command-line Options](@ref command-line-interface)を参照してください）。

[threadpools](@ref man-threadpools)を参照して、各スレッドプールにおける`:default`および`:interactive`スレッドの数を制御する方法を確認してください。

!!! compat "Julia 1.5"
    `-t`/`--threads` コマンドライン引数は、少なくとも Julia 1.5 が必要です。古いバージョンでは、代わりに環境変数を使用する必要があります。


!!! compat "Julia 1.7"
    `auto`を環境変数[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS)の値として使用するには、少なくともJulia 1.7が必要です。古いバージョンでは、この値は無視されます。


!!! compat "Julia 1.12"
    デフォルトで1つのインタラクティブスレッドと1つのワーカースレッドから始まるのは、Julia 1.12で行われました。スレッド数が1に設定されている場合、`-t1`または`JULIA_NUM_THREADS=1`を使用すると、インタラクティブスレッドは生成されません。


Juliaを4スレッドで開始します:

```bash
$ julia --threads 4
```

スレッドが4つ利用可能であることを確認しましょう。

```julia-repl
julia> Threads.nthreads()
4
```

しかし、現在私たちはマスタースレッドにいます。確認するために、関数 [`Threads.threadid`](@ref) を使用します。

```jldoctest
julia> Threads.threadid()
1
```

!!! note
    環境変数を使用したい場合は、Bash（Linux/macOS）で次のように設定できます：

    ```bash
    export JULIA_NUM_THREADS=4
    ```

    Linux/macOSのCシェル、WindowsのCMD:

    ```bash
    set JULIA_NUM_THREADS=4
    ```

    Windows上のPowershell:

    ```powershell
    $env:JULIA_NUM_THREADS=4
    ```

    この作業は*Juliaを始める前*に行う必要があります。


!!! note
    `-t`/`--threads`で指定されたスレッドの数は、`-p`/`--procs`または`--machine-file`コマンドラインオプションを使用して生成されるワーカープロセスに伝播されます。たとえば、`julia -p2 -t2`は、2つのワーカープロセスを持つ1つのメインプロセスを生成し、3つのプロセスすべてに2つのスレッドが有効になります。ワーカースレッドをより細かく制御するには、[`addprocs`](@ref)を使用し、`-t`/`--threads`を`exeflags`として渡します。


### Multiple GC Threads

ガーベジコレクタ（GC）は複数のスレッドを使用できます。デフォルトで使用されるスレッドの数は、コンピュートワーカースレッドと一致するか、`--gcthreads` コマンドライン引数を使用するか、[`JULIA_NUM_GC_THREADS`](@ref JULIA_NUM_GC_THREADS) 環境変数を使用して構成できます。

!!! compat "Julia 1.10"
    `--gcthreads` コマンドライン引数は、少なくとも Julia 1.10 が必要です。


ガーベジコレクションの設定とパフォーマンスチューニングの詳細については、[Memory Management and Garbage Collection](@ref man-memory-management)を参照してください。

## [Threadpools](@id man-threadpools)

プログラムのスレッドが多くのタスクを実行して忙しいとき、タスクは遅延を経験する可能性があり、これがプログラムの応答性やインタラクティブ性に悪影響を及ぼすことがあります。これに対処するために、タスクがインタラクティブであることを指定することができます。[`Threads.@spawn`](@ref) すると:

```julia
using Base.Threads
@spawn :interactive f()
```

インタラクティブなタスクは、高遅延操作を避けるべきであり、長時間のタスクである場合は、頻繁に制御を返すべきです。

デフォルトでは、Juliaはインタラクティブなタスクを実行するために1つのインタラクティブスレッドを予約して開始しますが、その数は次のように制御できます:

```bash
$ julia --threads 3,1
julia> Threads.nthreads(:interactive)
1

$ julia --threads 3,0
julia> Threads.nthreads(:interactive)
0
```

環境変数 [`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS) は、同様に使用することもできます：

```bash
export JULIA_NUM_THREADS=3,1
```

これは、`:default` スレッドプールに 3 スレッド、`:interactive` スレッドプールに 1 スレッドで Julia を起動します:

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
    明示的に `-t1` または `JULIA_NUM_THREADS=1` を指定しても、インタラクティブスレッドは追加されません。


!!! note
    `nthreads`のゼロ引数バージョンは、デフォルトプール内のスレッド数を返します。


!!! note
    Juliaがインタラクティブスレッドで起動されているかどうかに応じて、メインスレッドはデフォルトスレッドプールまたはインタラクティブスレッドプールのいずれかにあります。


いずれかまたは両方の数字を `auto` という単語に置き換えることができ、これによりJuliaは適切なデフォルトを選択します。

## The `@threads` Macro

ネイティブスレッドを使用して簡単な例を作成しましょう。ゼロの配列を作成します：

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

この配列に対して4つのスレッドを使って同時に操作しましょう。各スレッドが自分のスレッドIDを各位置に書き込むようにします。

Juliaは、[`Threads.@threads`](@ref)マクロを使用して並列ループをサポートしています。このマクロは、`for`ループの前に付けられ、ループがマルチスレッド領域であることをJuliaに示します：

```julia-repl
julia> Threads.@threads for i = 1:10
           a[i] = Threads.threadid()
       end
```

イテレーション空間はスレッド間で分割され、その後各スレッドは自分のスレッドIDを割り当てられた場所に書き込みます:

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

[`Threads.@threads`](@ref) には、[`@distributed`](@ref) のようなオプションの削減パラメータがありません。

### Using `@threads` without data-races

データレースの概念は ["Communication and data races between threads"](@ref man-communication-and-data-races) で詳述されています。今のところ、データレースは不正確な結果や危険なエラーを引き起こす可能性があることを知っておいてください。

`sum_single`関数をマルチスレッド化したいとしましょう。

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

単に `@threads` を追加するだけでは、複数のスレッドが同時に `s` を読み書きするデータ競合が発生します。

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

結果は `500000500000` ではなく、評価ごとに最も可能性が高く変わることに注意してください。

この問題を解決するために、タスクに特有のバッファを使用して合計をレースフリーなチャンクに分割することができます。ここで `sum_single` は再利用され、その内部バッファ `s` を持っています。入力ベクトル `a` は、並列作業のために最大 `nthreads()` チャンクに分割されます。次に、`Threads.@spawn` を使用して、各チャンクを個別に合計するタスクを作成します。最後に、再び `sum_single` を使用して各タスクからの結果を合計します：

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
    バッファは `threadid()` に基づいて管理すべきではありません。つまり、`buffers = zeros(Threads.nthreads())` のようにするべきではありません。なぜなら、同時実行タスクが中断される可能性があり、特定のスレッド上で複数の同時実行タスクが同じバッファを使用することになり、データ競合のリスクが生じるからです。さらに、複数のスレッドが利用可能な場合、タスクは中断ポイントでスレッドを変更することがあり、これは [task migration](@ref man-task-migration) として知られています。


別の選択肢は、タスクやスレッド間で共有される変数に対してアトミック操作を使用することであり、これは操作の特性に応じてよりパフォーマンスが向上する可能性があります。

## [Communication and data-races between threads](@id man-communication-and-data-races)

Juliaのスレッドは共有メモリを通じて通信できますが、正確でデータ競合のないマルチスレッドコードを書くことは非常に難しいことで知られています。Juliaの [`Channel`](@ref) はスレッドセーフであり、安全に通信するために使用できます。また、データ競合を避けるために [locks](@ref man-using-locks) と [atomics](@ref man-atomic-operations) の使用方法を説明するセクションもあります。

特定のケースでは、Juliaは安全違反を検出することができ、特にデッドロックや現在実行中のタスクに対する制御の譲渡などの他の既知の安全でない操作に関してです。これらのケースでは、[`ConcurrencyViolationError`](@ref)がスローされます。

### Data-race freedom

あなたはプログラムがデータレースフリーであることを保証する全責任を負っており、その要件を遵守しない場合、ここで約束されたことは何も仮定できません。観察された結果は非常に直感に反する場合があります。

データレースが発生すると、Juliaはメモリ安全ではありません。**別のスレッドが書き込む可能性がある場合は、*任意の*データを読む際に非常に注意してください。セグメンテーションフォルトやそれ以上の問題が発生する可能性があります**。以下は、異なるスレッドからグローバル変数にアクセスするいくつかの安全でない方法です：

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

データレースを回避し、スレッドセーフなコードを書くための重要なツールは「ロック」という概念です。ロックはロックされ、アンロックされることができます。スレッドがロックをロックし、アンロックしていない場合、そのスレッドはロックを「保持している」と言います。ロックが1つだけの場合、ロックを保持してデータにアクセスする必要があるコードを書くことで、複数のスレッドが同時に同じデータにアクセスすることは決してないと保証できます。ロックと変数の間のリンクはプログラマーによって作成され、プログラムによってではないことに注意してください。

例えば、`my_lock`というロックを作成し、変数`my_variable`を変更している間にロックします。これは、`@lock`マクロを使うことで最も簡単に行えます：

```julia-repl
julia> my_lock = ReentrantLock();

julia> my_variable = [1, 2, 3];

julia> @lock my_lock my_variable[1] = 100
100
```

同じロックと変数を使用し、別のスレッドで同様のパターンを使用することで、操作はデータ競合から解放されます。

上記の操作は、`lock`の関数型バージョンを使用して、次の2つの方法で実行できました：

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

すべての3つのオプションは同等です。最終バージョンでは、ロックが常に解除されることを保証するために明示的な `try` ブロックが必要であることに注意してください。一方、最初の2つのバージョンはこれを内部で行います。データを変更する際（グローバル変数やクロージャ変数に代入するなど）には、他のスレッドによってアクセスされるロックパターンを常に使用すべきです。これを怠ると、予期しない深刻な結果を招く可能性があります。

### [Atomic Operations](@id man-atomic-operations)

Julia supports accessing and modifying values *atomically*, that is, in a thread-safe way to avoid [race conditions](https://en.wikipedia.org/wiki/Race_condition). A value (which must be of a primitive type) can be wrapped as [`Threads.Atomic`](@ref) to indicate it must be accessed in this way. Here we can see an example:

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

原子タグなしで加算を試みた場合、レースコンディションのために間違った答えが得られる可能性がありました。レースを避けなかった場合に何が起こるかの例：

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

より詳細なレベルでアトミックを使用することもできます。[`@atomic`](@ref Base.@atomic)、[`@atomicswap`](@ref Base.@atomicswap)、[`@atomicreplace`](@ref Base.@atomicreplace) マクロ、および [`@atomiconce`](@ref Base.@atomiconce) マクロを使用します。

メモリモデルの具体的な詳細や設計のその他の詳細は、[Julia Atomics Manifesto](https://gist.github.com/vtjnash/11b0031f2e2a66c9c24d33e810b34ec0)に記載されており、後に正式に公開される予定です。

構造体宣言の任意のフィールドは `@atomic` で装飾でき、その後の書き込みも `@atomic` でマークされなければならず、定義された原子順序のいずれか（`:monotonic`、`:acquire`、`:release`、`:acquire_release`、または `:sequentially_consistent`）を使用しなければなりません。原子フィールドの読み取りも原子順序制約で注釈を付けることができ、指定されていない場合は単調（緩和された）順序で行われます。

!!! compat "Julia 1.7"
    Per-field atomicsは、少なくともJulia 1.7が必要です。


## Side effects and mutable function arguments

マルチスレッドを使用する際には、[pure](https://en.wikipedia.org/wiki/Pure_function) のような関数を使用する際に注意が必要です。そうしないと、間違った答えが得られる可能性があります。例えば、[name ending with `!`](@ref bang-convention) のように、慣例的に引数を変更する関数は純粋ではありません。

## @threadcall

外部ライブラリ、例えば [`ccall`](@ref) を介して呼び出されるものは、JuliaのタスクベースのI/Oメカニズムに問題を引き起こします。Cライブラリがブロッキング操作を実行すると、その呼び出しが戻るまでJuliaスケジューラは他のタスクを実行できなくなります。（例外として、JuliaにコールバックするカスタムCコードへの呼び出しがあり、これによりyieldすることができるか、`jl_yield()`を呼び出すCコードがあります。これは [`yield`](@ref) のCの同等物です。）

[`@threadcall`](@ref) マクロは、そのようなシナリオで実行の停止を回避する方法を提供します。これは、別のスレッドで実行するために C 関数をスケジュールします。デフォルトサイズが 4 のスレッドプールがこれに使用されます。スレッドプールのサイズは、環境変数 `UV_THREADPOOL_SIZE` を介して制御されます。空いているスレッドを待っている間、またスレッドが利用可能になったときの関数実行中に、要求されたタスク（メインの Julia イベントループ上）は他のタスクに譲ります。`@threadcall` は、実行が完了するまで戻らないことに注意してください。したがって、ユーザーの観点からは、他の Julia API のようにブロッキングコールとなります。

呼び出された関数がJuliaにコールバックしないことが非常に重要です。そうしないと、セグメンテーションフォルトが発生します。

`@threadcall`は将来のJuliaのバージョンで削除または変更される可能性があります。

## Caveats

この時点で、Juliaランタイムおよび標準ライブラリのほとんどの操作は、ユーザーコードがデータ競合がない場合にスレッドセーフな方法で使用できます。ただし、一部の領域ではスレッドサポートの安定化に向けた作業が進行中です。マルチスレッドプログラミングには多くの固有の困難があり、スレッドを使用するプログラムが異常または望ましくない動作（例：クラッシュや不明な結果）を示す場合、通常はスレッド間の相互作用が最初に疑われるべきです。

Juliaでスレッドを使用する際に注意すべき特定の制限と警告がいくつかあります：

  * 基本的なコレクションタイプは、複数のスレッドによって同時に使用される場合、少なくとも1つのスレッドがコレクションを変更する場合に手動でロックする必要があります（一般的な例には、配列への `push!` や `Dict` へのアイテムの挿入が含まれます）。
  * [`@spawn`](@ref Threads.@spawn)によって使用されるスケジュールは非決定的であり、信頼すべきではありません。
  * 計算に依存するメモリ割り当てを行わないタスクは、メモリを割り当てている他のスレッドでガーベジコレクションが実行されるのを妨げる可能性があります。このような場合、GCが実行されるように手動で`GC.safepoint()`を呼び出す必要があるかもしれません。この制限は将来的に解除される予定です。
  * トップレベルの操作、例えば、`include`や型、メソッド、モジュール定義の`eval`を並行して実行することは避けてください。
  * ライブラリによって登録されたファイナライザは、スレッドが有効になっている場合に壊れる可能性があることに注意してください。これにより、スレッドを自信を持って広く採用する前に、エコシステム全体でいくつかの移行作業が必要になる場合があります。詳細については、[the safe use of finalizers](@ref man-finalizers)のセクションを参照してください。

## [Task Migration](@id man-task-migration)

タスクが特定のスレッドで実行を開始した後、タスクが譲歩すると別のスレッドに移動する可能性があります。

そのようなタスクは、[`@spawn`](@ref Threads.@spawn) または [`@threads`](@ref Threads.@threads) で開始された可能性がありますが、`@threads` の `:static` スケジュールオプションは threadid を固定します。

これは、ほとんどの場合、[`threadid()`](@ref Threads.threadid)はタスク内で定数として扱われるべきではなく、したがってバッファや状態を持つオブジェクトのベクターにインデックスを付けるために使用されるべきではないことを意味します。

!!! compat "Julia 1.7"
    タスクの移行はJulia 1.7で導入されました。それ以前は、タスクは常に開始されたスレッドに留まっていました。


## [Safe use of Finalizers](@id man-finalizers)

ファイナライザは任意のコードを中断できるため、グローバルステートとの相互作用において非常に注意が必要です。残念ながら、ファイナライザが使用される主な理由はグローバルステートを更新することであり（純粋関数は一般的にファイナライザとしてはあまり意味がありません）、これが少しのジレンマを引き起こします。この問題に対処するためのいくつかのアプローチがあります：

1. シングルスレッドの場合、コードは内部の `jl_gc_enable_finalizers` C 関数を呼び出して、クリティカル領域内でファイナライザがスケジュールされるのを防ぐことができます。内部的には、これは特定の操作（インクリメンタルパッケージの読み込み、コード生成など）を行う際に再帰を防ぐために、いくつかの関数（私たちの C ロックなど）内で使用されます。ロックとこのフラグの組み合わせを使用することで、ファイナライザを安全にすることができます。
2. 第二の戦略は、Baseがいくつかの場所で採用しているもので、最終化処理を明示的に遅延させ、非再帰的にロックを取得できる可能性があるまで待つというものです。以下の例は、この戦略が`Distributed.finalize_ref`にどのように適用されるかを示しています：

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
3. 関連する第三の戦略は、イールドフリーキューを使用することです。現在、Baseにはロックフリーキューが実装されていませんが、`Base.IntrusiveLinkedListSynchronized{T}`が適しています。これは、イベントループを持つコードに対して頻繁に良い戦略となります。例えば、この戦略は`Gtk.jl`によってライフタイムの参照カウント管理に使用されています。このアプローチでは、`finalizer`内で明示的な作業を行わず、代わりに安全なタイミングで実行するためにキューに追加します。実際、Juliaのタスクスケジューラはすでにこれを使用しているため、`finalizer`を`x -> @spawn do_cleanup(x)`として定義することはこのアプローチの一例です。ただし、これは`do_cleanup`がどのスレッドで実行されるかを制御しないため、`do_cleanup`は依然としてロックを取得する必要があります。独自のキューを実装すれば、スレッドからそのキューを明示的にのみ排出することができるため、これは必ずしも真である必要はありません。
