# [Asynchronous Programming](@id man-asynchronous)

プログラムが外部とやり取りする必要がある場合、たとえばインターネット経由で別のマシンと通信する場合、プログラム内の処理は予測できない順序で実行されることがあります。ファイルをダウンロードする必要があるとしましょう。ダウンロード処理を開始し、完了を待つ間にほかの処理を行い、ファイルが利用可能になったら、そのファイルを必要とするコードの実行を再開したいものです。このような状況を扱うのが非同期プログラミングです。概念上、複数の処理が同時に進行することから、並行プログラミングと呼ばれることもあります。

Juliaでは、このような状況に対応するために[`Task`](@ref)（対称コルーチン、軽量スレッド、協調的マルチタスク、ワンショット継続など、ほかにもいくつかの呼び名があります）が用意されています。ある計算処理（実際には、特定の関数の実行）を[`Task`](@ref)として指定すると、別の[`Task`](@ref)に切り替えて、その処理を中断できます。元の[`Task`](@ref)は後から再開でき、その時点で中断した箇所から実行を続けます。一見すると、これは関数呼び出しに似ているように思えるかもしれません。しかし、重要な違いが2つあります。まず、タスクの切り替えではスタック領域を消費しないため、呼び出しスタックを使い切ることなく、何度でもタスクを切り替えられます。次に、関数呼び出しでは呼び出された関数の実行が終わるまで呼び出し元に制御が戻りませんが、タスク間の切り替えは任意の順序で行えます。

## Basic `Task` operations

`Task`は、実行する計算処理の単位を表すハンドルと考えることができます。タスクには、作成、開始、実行、終了というライフサイクルがあります。タスクを作成するには、実行する引数なし関数を`Task`コンストラクターに渡すか、[`@task`](@ref)マクロを使います。

```julia-repl
julia> t = @task begin; sleep(5); println("done"); end
Task (runnable) @0x00007f13a40c0eb0
```

`@task x`は`Task(()->x)`と同等です。

このタスクは5秒間待機してから、`done`を出力します。ただし、まだ実行は開始されていません。準備ができたら、[`schedule`](@ref)を呼び出して実行できます。

```julia-repl
julia> schedule(t);
```

REPLで試すと、`schedule`がすぐに戻ることがわかります。これは、実行待ちタスクの内部キューに`t`を追加するだけだからです。その後、REPLは次のプロンプトを表示し、入力を待ちます。キーボード入力を待つ間は、ほかのタスクを実行できます。そのため、この時点で`t`の実行が始まります。`t`は[`sleep`](@ref)を呼び出し、タイマーを設定して実行を停止します。その時点でほかのタスクがスケジュールされていれば、それらを実行できます。5秒後にタイマーが作動すると、`t`の実行が再開され、`done`が出力されます。これで`t`は終了です。

[`wait`](@ref)関数は、別のタスクが終了するまで呼び出し元のタスクをブロックします。たとえば、次のように入力すると、

```julia-repl
julia> schedule(t); wait(t)
```

`schedule`を呼び出すだけの場合とは異なり、次の入力プロンプトが表示されるまで5秒間待つことになります。これは、REPLが処理を続ける前に`t`の終了を待つためです。

タスクを作成してすぐにスケジュールすることはよくあるため、そのためのマクロ[`Threads.@spawn`](@ref)が用意されています。`Threads.@spawn x`は`task = @task x; task.sticky = false; schedule(task)`と同等です。

## Communicating with Channels

必要な処理同士が関数呼び出しで自然につながらず、実行すべき処理の間に明確な「呼び出し元」や「呼び出し先」が存在しない問題もあります。たとえば、生産者・消費者問題では、複雑な処理の一方が値を生成し、もう一方がそれを消費します。生産者にはまだ生成すべき値が残っていて、すぐには戻れない可能性があるため、消費者が生産者関数を単純に呼び出して値を取得することはできません。タスクを使えば、生産者と消費者は必要なだけそれぞれ実行し、必要に応じて値をやり取りできます。

Juliaには、この問題を解決するための[`Channel`](@ref)機構があります。[`Channel`](@ref)は、複数のタスクが読み書きできる、待機可能な先入れ先出しキューです。

[`put!`](@ref)呼び出しで値を生成する生産者タスクを定義しましょう。値を消費するには、生産者を新しいタスクとしてスケジュールする必要があります。引数として1引数関数を受け取る特殊な[`Channel`](@ref)コンストラクターを使うと、チャネルにバインドされたタスクを実行できます。その後、チャネルオブジェクトから値を繰り返し[`take!`](@ref)できます。

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

この動作は、`producer`が複数回戻ることができた、と考えることもできます。[`put!`](@ref)の呼び出しの間、生産者の実行は中断され、消費者が制御を得ます。

返された[`Channel`](@ref)は、`for`ループで反復可能オブジェクトとして使えます。この場合、ループ変数には生成された値が順に代入されます。チャネルが閉じられると、ループは終了します。

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

生産者側でチャネルを明示的に閉じる必要がなかったことに注目してください。これは、[`Channel`](@ref)を[`Task`](@ref)にバインドすると、チャネルが開いている期間がバインド先のタスクの存続期間に結び付けられるためです。タスクが終了すると、チャネルオブジェクトは自動的に閉じられます。1つのタスクに複数のチャネルをバインドすることも、1つのチャネルを複数のタスクにバインドすることもできます。

[`Task`](@ref)コンストラクターが引数なし関数を受け取るのに対し、タスクにバインドされたチャネルを作成する[`Channel`](@ref)メソッドは、[`Channel`](@ref)型の引数を1つ受け取る関数を必要とします。生産者をパラメーター化するのはよくあるパターンです。その場合、引数が0個または1個の[anonymous function](@ref man-anonymous-functions)を作成するために、部分関数適用が必要になります。

[`Task`](@ref)オブジェクトでは、これを直接行うことも、便利なマクロを使うこともできます。

```julia
function mytask(myarg)
    ...
end

taskHdl = Task(() -> mytask(7))
# or, equivalently
taskHdl = @task mytask(7)
```

より高度な作業分配パターンを構成するには、[`bind`](@ref)と[`schedule`](@ref)を、[`Task`](@ref)および[`Channel`](@ref)コンストラクターと組み合わせて使うことで、チャネルの集合と生産者・消費者タスクの集合を明示的に関連付けられます。

### More on Channels

チャネルはパイプとして捉えることができます。つまり、書き込み側と読み取り側があります。

  * 異なるタスクに属する複数の書き手が、[`put!`](@ref)呼び出しを通じて、同じチャネルに同時に書き込めます。
  * 異なるタスクに属する複数の読み手が、[`take!`](@ref)呼び出しを通じて、同時にデータを読み取れます。
  * 例を示します。

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
  * チャネルは`Channel{T}(sz)`コンストラクターで作成します。チャネルに格納できるのは`T`型のオブジェクトだけです。型を指定しない場合は、任意の型のオブジェクトを格納できます。`sz`は、チャネルに同時に格納できる要素数の上限を表します。たとえば、`Channel(32)`は、任意の型のオブジェクトを最大32個格納できるチャネルを作成します。`Channel{MyType}(64)`は、`MyType`型のオブジェクトを最大64個格納できます。
  * [`Channel`](@ref)が空の場合、読み手はデータが利用可能になるまで（[`take!`](@ref)呼び出し時に）ブロックします（[`isempty`](@ref)を参照）。
  * [`Channel`](@ref)が満杯の場合、書き手は空きができるまで（[`put!`](@ref)呼び出し時に）ブロックします（[`isfull`](@ref)を参照）。
  * [`isready`](@ref)はチャネル内にオブジェクトがあるかどうかを調べます。一方、[`wait`](@ref)はオブジェクトが利用可能になるまで待機します。
  * 別のタスクがオブジェクトをチャネルに`put!`しようと待機している場合、チャネル内の要素数が容量を超えることがあります。
  * [`Channel`](@ref)は、最初は開いた状態です。そのため、[`take!`](@ref)および[`put!`](@ref)呼び出しを通じて、自由に読み書きできます。[`close`](@ref)は[`Channel`](@ref)を閉じます。閉じた[`Channel`](@ref)に対しては、[`put!`](@ref)が失敗します。たとえば、次のとおりです。

    ```jldoctest channel_example
    julia> c = Channel(2);

    julia> put!(c, 1) # `put!` on an open channel succeeds
    1

    julia> close(c);

    julia> put!(c, 2) # `put!` on a closed channel throws an exception.
    ERROR: InvalidStateException: Channel is closed.
    Stacktrace:
    [...]
    ```
  * チャネルを閉じた後でも、[`take!`](@ref)と[`fetch`](@ref)（値を取得しますが、削除はしません）は、チャネルが空になるまで既存の値を正常に返します。先ほどの例を続けると、次のようになります。

    ```jldoctest channel_example
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

タスク間通信にチャネルを使う簡単な例を見てみましょう。単一の`jobs`チャネルからデータを処理するタスクを4つ起動します。ジョブはID（`job_id`）で識別され、チャネルに書き込まれます。このシミュレーションでは、各タスクが`job_id`を読み取り、ランダムな時間だけ待機した後、`job_id`とシミュレーション上の所要時間を組み合わせたタプルを結果チャネルに書き込みます。最後に、すべての`results`を出力します。

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

`errormonitor(t)`の代わりに`bind(results, t)`を使うと、より堅牢な解決策になる場合があります。予期しない失敗を記録するだけでなく、関連するリソースを確実に閉じ、例外をすべての箇所に伝播させるためです。

## More task operations

タスク操作は、[`yieldto`](@ref)という低レベルのプリミティブを基盤としています。`yieldto(task, value)`は現在のタスクを中断して、指定された`task`に切り替え、そのタスクの直近の[`yieldto`](@ref)呼び出しが、指定された`value`を返すようにします。タスク形式の制御フローに必要な操作は[`yieldto`](@ref)だけです。呼び出しと復帰を行うのではなく、常に別のタスクへ切り替えます。この機能が「対称コルーチン」とも呼ばれるのはそのためです。どのタスクへの切り替えも、タスクからの切り替えも、同じ仕組みで行います。

[`yieldto`](@ref)は強力ですが、タスクを使う場面のほとんどでは直接呼び出しません。その理由を考えてみましょう。現在のタスクから切り替えた後は、いずれそのタスクに戻りたいはずです。しかし、いつ戻るのか、どのタスクが戻す責任を負うのかを把握するには、かなりの調整が必要になることがあります。たとえば、[`put!`](@ref)と[`take!`](@ref)はブロッキング操作です。チャネルと組み合わせて使うと、消費者がどのタスクなのかを記憶する状態を管理します。消費側のタスクを手動で追跡する必要がないため、低レベルの[`yieldto`](@ref)よりも[`put!`](@ref)のほうが使いやすくなっています。

[`yieldto`](@ref)に加えて、タスクを効果的に使うには、ほかにもいくつかの基本関数が必要です。

  * [`current_task`](@ref)は、現在実行中のタスクへの参照を取得します。
  * [`istaskdone`](@ref)は、タスクが終了したかどうかを調べます。
  * [`istaskstarted`](@ref)は、タスクがすでに実行されたかどうかを調べます。
  * [`task_local_storage`](@ref)は、現在のタスク固有のキーと値のストアを操作します。

## Tasks and events

タスクの切り替えの多くは、I/O要求などのイベントを待つことで発生し、Julia Baseに含まれるスケジューラーによって実行されます。スケジューラーは実行可能なタスクのキューを管理し、メッセージの到着などの外部イベントに応じてタスクを再開するイベントループを実行します。

イベントを待つ基本関数は[`wait`](@ref)です。複数のオブジェクトが[`wait`](@ref)を実装しています。たとえば、`Process`オブジェクトに対して[`wait`](@ref)を呼び出すと、そのオブジェクトが終了するまで待機します。[`wait`](@ref)は暗黙的に行われることもよくあります。たとえば、データが利用可能になるのを待つために[`read`](@ref)を呼び出すと、その内部で[`wait`](@ref)が発生することがあります。

これらの場合、[`wait`](@ref)は最終的に[`Condition`](@ref)オブジェクトを操作します。このオブジェクトがタスクのキューイングと再開を担います。タスクが[`Condition`](@ref)に対して[`wait`](@ref)を呼び出すと、そのタスクは実行不可としてマークされ、条件のキューに追加された後、スケジューラーに切り替わります。スケジューラーは別のタスクを実行するか、外部イベントを待ってブロックします。問題がなければ、最終的にイベントハンドラーが条件に対して[`notify`](@ref)を呼び出し、その条件を待っていたタスクが再び実行可能になります。

[`Task`](@ref)を呼び出して明示的に作成したタスクは、最初はスケジューラーに認識されていません。そのため、必要であれば[`yieldto`](@ref)を使ってタスクを手動で管理できます。ただし、そのようなタスクがイベントを待つ場合、期待どおり、イベントが発生すると自動的に再開されます。
