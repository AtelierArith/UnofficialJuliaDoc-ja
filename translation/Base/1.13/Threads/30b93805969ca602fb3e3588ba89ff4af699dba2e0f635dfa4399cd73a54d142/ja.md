```julia
Threads.@spawn [:default|:interactive|:samepool] expr
```

指定したスレッドプール内で利用可能な任意のスレッド上で実行されるように、[`Task`](@ref) と [`schedule`](@ref) を作成します。スレッドプールには `:default`、`:interactive`、または呼び出し元と同じものを使う `:samepool` を指定できます。指定しない場合は `:default` が使われます。スレッドが利用可能になると、そのスレッドにタスクが割り当てられます。タスクの完了を待つには、このマクロの結果に対して [`wait`](@ref) を呼び出すか、[`fetch`](@ref) を呼び出して待機し、戻り値を取得します。

`@spawn` には、`$` を使って値を補間できます。これにより、値が構築される基底のクロージャに直接コピーされます。変数の *値* を挿入できるため、現在のタスクでその変数の値が変更されても、非同期コードには影響しません。

!!! note
    タスクが yield すると、実行されるスレッドが変わることがあります。そのため、タスク内で `threadid()` を定数として扱わないでください。重要な注意事項については [`Task Migration`](@ref man-task-migration) と、より広範な [multi-threading](@ref man-multithreading) マニュアルを参照してください。また、[threadpools](@ref man-threadpools) の章も参照してください。


!!! compat "Julia 1.3"
    このマクロは Julia 1.3 以降で利用できます。


!!! compat "Julia 1.4"
    `$` による値の補間は Julia 1.4 以降で利用できます。


!!! compat "Julia 1.9"
    Julia 1.9 以降ではスレッドプールを指定できます。


!!! compat "Julia 1.12"
    Julia 1.12 以降では同じスレッドプールを指定できます。


# Examples

```julia-repl
julia> t() = println("Hello from ", Threads.threadid());

julia> tasks = fetch.([Threads.@spawn t() for i in 1:4]);
Hello from 1
Hello from 1
Hello from 3
Hello from 4
```
