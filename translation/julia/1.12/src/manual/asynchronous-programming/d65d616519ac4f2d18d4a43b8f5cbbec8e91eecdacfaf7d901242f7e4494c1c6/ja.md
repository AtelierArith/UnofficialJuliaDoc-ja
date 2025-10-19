# [Asynchronous Programming](@id man-asynchronous)

プログラムが外部と対話する必要があるとき、たとえばインターネット経由で別のマシンと通信する場合、プログラム内の操作は予測できない順序で行われる必要があるかもしれません。たとえば、プログラムがファイルをダウンロードする必要があるとします。ダウンロード操作を開始し、完了するのを待っている間に他の操作を行い、ダウンロードされたファイルが利用可能になったときにそのファイルを必要とするコードを再開したいと考えています。このようなシナリオは、非同期プログラミングの領域に該当し、概念的には複数のことが同時に起こっているため、時には並行プログラミングとも呼ばれます。

これらのシナリオに対処するために、Juliaは[`Task`](@ref)（対称コルーチン、軽量スレッド、協調的マルチタスク、またはワンショット継続など、いくつかの他の名前でも知られています）を提供します。コンピューティング作業の一部（実際には特定の関数を実行すること）が`4d61726b646f776e2e436f64652822222c20225461736b2229_40726566`として指定されると、別の`4d61726b646f776e2e436f64652822222c20225461736b2229_40726566`に切り替えることで中断することが可能になります。元の`4d61726b646f776e2e436f64652822222c20225461736b2229_40726566`は後で再開でき、その時点で中断したところから再開します。最初は、これは関数呼び出しに似ているように思えるかもしれません。しかし、2つの重要な違いがあります。第一に、タスクを切り替える際にはスペースを使用しないため、コールスタックを消費することなく任意の数のタスクスイッチが発生する可能性があります。第二に、タスク間の切り替えは任意の順序で発生する可能性があり、関数呼び出しとは異なり、呼び出された関数が実行を終了するまで制御が呼び出し元の関数に戻ることはありません。

## Basic `Task` operations

`Task`は、実行される計算作業の単位へのハンドルとして考えることができます。これは、作成-開始-実行-完了のライフサイクルを持っています。タスクは、実行する0引数関数に対して`Task`コンストラクタを呼び出すか、[`@task`](@ref)マクロを使用して作成されます。

```julia-repl
julia> t = @task begin; sleep(5); println("done"); end
Task (runnable) @0x00007f13a40c0eb0
```

`@task x` は `Task(()->x)` と同等です。

このタスクは5秒待機し、その後`done`と表示します。ただし、まだ実行を開始していません。準備ができたら、[`schedule`](@ref)を呼び出すことで実行できます。

```julia-repl
julia> schedule(t);
```

もしこれをREPLで試すと、`schedule`がすぐに戻ることがわかります。これは、単に`t`を実行するための内部キューに追加するだけだからです。その後、REPLは次のプロンプトを表示し、さらなる入力を待ちます。キーボード入力を待つことで、他のタスクが実行される機会が提供されるため、その時点で`t`が開始されます。`t`は[`sleep`](@ref)を呼び出し、タイマーを設定して実行を停止します。他のタスクがスケジュールされていれば、その時に実行される可能性があります。5秒後、タイマーが発火し`t`を再起動し、`done`が表示されます。`t`はその後終了します。

[`wait`](@ref) 関数は、他のタスクが終了するまで呼び出しタスクをブロックします。たとえば、次のように入力すると、

```julia-repl
julia> schedule(t); wait(t)
```

`schedule`を呼び出すだけでなく、次の入力プロンプトが表示される前に5秒の待機時間があります。これは、REPLが`t`の処理が完了するのを待っているためです。

タスクを作成し、すぐにスケジュールしたいというのは一般的な要望です。そのために、マクロ [`Threads.@spawn`](@ref) が提供されています。`Threads.@spawn x` は `task = @task x; task.sticky = false; schedule(task)` と同等です。

## Communicating with Channels

いくつかの問題では、必要な作業のさまざまな部分が関数呼び出しによって自然に関連付けられていないことがあります。実行する必要があるジョブの中に明らかな「呼び出し元」や「呼び出し先」は存在しません。例として、プロデューサー-コンシューマー問題があります。ここでは、一つの複雑な手続きが値を生成し、別の複雑な手続きがそれを消費しています。コンシューマーは、プロデューサー関数を単純に呼び出して値を取得することはできません。なぜなら、プロデューサーは生成する値がまだ残っているかもしれず、したがってまだ返す準備ができていない可能性があるからです。タスクを使用することで、プロデューサーとコンシューマーは必要に応じて値を行き来させながら、必要なだけ実行を続けることができます。

Juliaはこの問題を解決するための[`Channel`](@ref)メカニズムを提供します。`4d61726b646f776e2e436f64652822222c20224368616e6e656c2229_40726566`は、複数のタスクが読み書きできる待機可能な先入れ先出しキューです。

プロデューサータスクを定義しましょう。これは、[`put!`](@ref) コールを介して値を生成します。値を消費するためには、プロデューサーを新しいタスクで実行するようにスケジュールする必要があります。1引数の関数を引数として受け取る特別な [`Channel`](@ref) コンストラクターを使用して、チャネルにバインドされたタスクを実行できます。その後、チャネルオブジェクトから値を繰り返し [`take!`](@ref) することができます。

```jldoctest producer
julia> function producer(c::Channel)
           put!(c, "start")
           for n=1:4
               put!(c, 2n)
           end
           put!(c, "stop")
       end;

julia> chnl = Channel(producer);

julia> take!(chnl)
"start"

julia> take!(chnl)
2

julia> take!(chnl)
4

julia> take!(chnl)
6

julia> take!(chnl)
8

julia> take!(chnl)
"stop"
```

この動作を考える一つの方法は、`producer` が複数回返すことができたということです。[`put!`](@ref) への呼び出しの間、プロデューサーの実行は一時停止され、コンシューマーが制御を持ちます。

返された [`Channel`](@ref) は、`for` ループ内でイテラブルオブジェクトとして使用できます。この場合、ループ変数は生成されたすべての値を取得します。ループはチャネルが閉じられると終了します。

```jldoctest producer
julia> for x in Channel(producer)
           println(x)
       end
start
2
4
6
8
stop
```

プロデューサーでチャンネルを明示的に閉じる必要がなかったことに注意してください。これは、[`Channel`](@ref) を [`Task`](@ref) にバインドする行為が、チャンネルのオープンライフタイムをバインドされたタスクのライフタイムに関連付けるためです。タスクが終了すると、チャンネルオブジェクトは自動的に閉じられます。複数のチャンネルをタスクにバインドすることも、その逆も可能です。

[`Task`](@ref) コンストラクタは 0 引数の関数を期待しますが、[`Channel`](@ref) メソッドは、`4d61726b646f776e2e436f64652822222c20224368616e6e656c2229_40726566` 型の単一引数を受け取る関数を期待します。一般的なパターンは、プロデューサーがパラメータ化されている場合であり、その場合は 0 または 1 引数の [anonymous function](@ref man-anonymous-functions) を作成するために部分関数適用が必要です。

[`Task`](@ref) オブジェクトについては、これを直接行うか、便利なマクロを使用して行うことができます：

```julia
function mytask(myarg)
    ...
end

taskHdl = Task(() -> mytask(7))
# or, equivalently
taskHdl = @task mytask(7)
```

より高度な作業分配パターンを調整するために、[`bind`](@ref) と [`schedule`](@ref) を [`Task`](@ref) および [`Channel`](@ref) コンストラクタと組み合わせて使用することで、一連のチャネルを一連のプロデューサ/コンシューマタスクに明示的にリンクすることができます。

### More on Channels

チャネルはパイプとして視覚化できます。つまり、書き込み端と読み取り端があります：

  * 複数のライターが異なるタスクで同じチャネルに同時に書き込むことができます [`put!`](@ref) コールを介して。
  * 異なるタスクの複数のリーダーは、[`take!`](@ref) 呼び出しを介してデータを同時に読み取ることができます。
  * 例として：

    ```julia
    # Given Channels c1 and c2,
    c1 = Channel(32)
    c2 = Channel(32)

    # and a function `foo` which reads items from c1, processes the item read
    # and writes a result to c2,
    function foo()
        while true
            data = take!(c1)
            [...]               # process data
            put!(c2, result)    # write out result
        end
    end

    # we can schedule `n` instances of `foo` to be active concurrently.
    for _ in 1:n
        errormonitor(Threads.@spawn foo())
    end
    ```
  * チャネルは `Channel{T}(sz)` コンストラクタを介して作成されます。チャネルは型 `T` のオブジェクトのみを保持します。型が指定されていない場合、チャネルは任意の型のオブジェクトを保持できます。`sz` は、チャネルが任意の時点で保持できる最大要素数を指します。例えば、`Channel(32)` は、任意の型のオブジェクトを最大32個保持できるチャネルを作成します。`Channel{MyType}(64)` は、任意の時点で最大64個の `MyType` オブジェクトを保持できます。
  * もし [`Channel`](@ref) が空であれば、リーダー（[`take!`](@ref) コールで）はデータが利用可能になるまでブロックされます（[`isempty`](@ref) を参照）。
  * もし [`Channel`](@ref) が満杯の場合、ライターは（[`put!`](@ref) コールで）スペースが利用可能になるまでブロックされます（[`isfull`](@ref) を参照）。
  * [`isready`](@ref) はチャネル内の任意のオブジェクトの存在をテストし、[`wait`](@ref) はオブジェクトが利用可能になるのを待ちます。
  * チャネルにオブジェクトを `put!` しようとしている別のタスクが現在待機している場合、チャネルはその容量よりも多くのアイテムを持つことができます。
  * [`Channel`](@ref) は最初にオープン状態です。これは、[`take!`](@ref) および [`put!`](@ref) コールを介して自由に読み書きできることを意味します。[`close`](@ref) は `4d61726b646f776e2e436f64652822222c20224368616e6e656c2229_40726566` を閉じます。閉じた `4d61726b646f776e2e436f64652822222c20224368616e6e656c2229_40726566` では、`4d61726b646f776e2e436f64652822222c2022707574212229_40726566` は失敗します。例えば：

    ```julia-repl
    julia> c = Channel(2);

    julia> put!(c, 1) # `put!` on an open channel succeeds
    1

    julia> close(c);

    julia> put!(c, 2) # `put!` on a closed channel throws an exception.
    ERROR: InvalidStateException: Channel is closed.
    Stacktrace:
    [...]
    ```
  * [`take!`](@ref) と [`fetch`](@ref) （値を削除せずに取得する） は、閉じたチャネルで既存の値を空になるまで正常に返します。上記の例を続けると：

    ```julia-repl
    julia> fetch(c) # Any number of `fetch` calls succeed.
    1

    julia> fetch(c)
    1

    julia> take!(c) # The first `take!` removes the value.
    1

    julia> take!(c) # No more data available on a closed channel.
    ERROR: InvalidStateException: Channel is closed.
    Stacktrace:
    [...]
    ```

単純な例を考えてみましょう。タスク間通信のためにチャネルを使用します。1つの `jobs` チャネルからデータを処理するために4つのタスクを開始します。ジョブは、`job_id` で識別され、チャネルに書き込まれます。このシミュレーションの各タスクは `job_id` を読み取り、ランダムな時間待機し、`job_id` とシミュレートされた時間のタプルを結果チャネルに書き戻します。最後に、すべての `results` が出力されます。

```julia-repl
julia> const jobs = Channel{Int}(32);

julia> const results = Channel{Tuple}(32);

julia> function do_work()
           for job_id in jobs
               exec_time = rand()
               sleep(exec_time)                # simulates elapsed time doing actual work
                                               # typically performed externally.
               put!(results, (job_id, exec_time))
           end
       end;

julia> function make_jobs(n)
           for i in 1:n
               put!(jobs, i)
           end
       end;

julia> n = 12;

julia> errormonitor(Threads.@spawn make_jobs(n)); # feed the jobs channel with "n" jobs

julia> for i in 1:4 # start 4 tasks to process requests in parallel
           errormonitor(Threads.@spawn do_work())
       end

julia> @elapsed while n > 0 # print out results
           job_id, exec_time = take!(results)
           println("$job_id finished in $(round(exec_time; digits=2)) seconds")
           global n = n - 1
       end
4 finished in 0.22 seconds
3 finished in 0.45 seconds
1 finished in 0.5 seconds
7 finished in 0.14 seconds
2 finished in 0.78 seconds
5 finished in 0.9 seconds
9 finished in 0.36 seconds
6 finished in 0.87 seconds
8 finished in 0.79 seconds
10 finished in 0.64 seconds
12 finished in 0.5 seconds
11 finished in 0.97 seconds
0.029772311
```

`errormonitor(t)`の代わりに、より堅牢な解決策として`bind(results, t)`を使用することが考えられます。これは、予期しない失敗をログに記録するだけでなく、関連するリソースを閉じることを強制し、例外をすべての場所に伝播させるからです。

## More task operations

タスク操作は、[`yieldto`](@ref)と呼ばれる低レベルのプリミティブに基づいています。`yieldto(task, value)`は現在のタスクを一時停止し、指定された`task`に切り替え、そのタスクの最後の`4d61726b646f776e2e436f64652822222c20227969656c64746f2229_40726566`呼び出しが指定された`value`を返すようにします。`4d61726b646f776e2e436f64652822222c20227969656c64746f2229_40726566`はタスクスタイルの制御フローを使用するために必要な唯一の操作です。呼び出しと返却を行う代わりに、常に別のタスクに切り替えているのです。このため、この機能は「対称コルーチン」とも呼ばれます。各タスクは同じメカニズムを使用して切り替えられます。

[`yieldto`](@ref) は強力ですが、タスクのほとんどの使用はそれを直接呼び出しません。なぜそうなるのか考えてみてください。現在のタスクから切り替える場合、いつかは再びそのタスクに戻りたいと思うでしょうが、いつ戻るべきか、どのタスクが戻る責任を持つのかを知るにはかなりの調整が必要です。例えば、[`put!`](@ref) と [`take!`](@ref) はブロッキング操作であり、チャネルの文脈で使用されると、消費者が誰であるかを記憶するための状態を維持します。消費タスクを手動で追跡する必要がないことが、`4d61726b646f776e2e436f64652822222c2022707574212229_40726566` を低レベルの `4d61726b646f776e2e436f64652822222c20227969656c64746f2229_40726566` よりも使いやすくしています。

[`yieldto`](@ref)に加えて、タスクを効果的に使用するためにいくつかの基本的な関数が必要です。

  * [`current_task`](@ref) は、現在実行中のタスクへの参照を取得します。
  * [`istaskdone`](@ref) は、タスクが終了したかどうかを照会します。
  * [`istaskstarted`](@ref) は、タスクがまだ実行されているかどうかを照会します。
  * [`task_local_storage`](@ref) は、現在のタスクに特有のキー-バリューストアを操作します。

## Tasks and events

ほとんどのタスクスイッチは、I/Oリクエストなどのイベントを待っている結果として発生し、Julia Baseに含まれるスケジューラによって実行されます。スケジューラは実行可能なタスクのキューを維持し、メッセージの到着などの外部イベントに基づいてタスクを再起動するイベントループを実行します。

The basic function for waiting for an event is [`wait`](@ref). Several objects implement [`wait`](@ref); for example, given a `Process` object, [`wait`](@ref) will wait for it to exit. [`wait`](@ref) is often implicit; for example, a [`wait`](@ref) can happen inside a call to [`read`](@ref) to wait for data to be available.

すべてのケースにおいて、[`wait`](@ref) は最終的に [`Condition`](@ref) オブジェクトで動作し、これはタスクのキューイングと再起動を担当します。タスクが `4d61726b646f776e2e436f64652822222c2022776169742229_40726566` を `4d61726b646f776e2e436f64652822222c2022436f6e646974696f6e2229_40726566` に対して呼び出すと、そのタスクは非実行可能としてマークされ、条件のキューに追加され、スケジューラに切り替わります。スケジューラは別のタスクを実行するか、外部イベントを待つためにブロックします。すべてがうまくいけば、最終的にイベントハンドラが条件に対して [`notify`](@ref) を呼び出し、その条件を待っているタスクが再び実行可能になります。

[`Task`](@ref)によって明示的に作成されたタスクは、最初はスケジューラに知られていません。これにより、必要に応じて[`yieldto`](@ref)を使用してタスクを手動で管理できます。ただし、そのようなタスクがイベントを待機している場合、イベントが発生すると自動的に再起動されることは予想通りです。
