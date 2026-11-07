```julia
Threads.@spawn [:default|:interactive|:samepool] expr
```

指定したスレッドプールで利用可能な任意のスレッド上で実行する[`Task`](@ref)を作成し、[`schedule`](@ref)します。スレッドプールには、`:default`、`:interactive`、または呼び出し元と同じスレッドプールを使う`:samepool`を指定できます。指定しない場合は`:default`が使われます。スレッドが空き次第、そのスレッドにタスクが割り当てられます。タスクの完了を待つには、このマクロの結果に対して[`wait`](@ref)を呼び出します。または、[`fetch`](@ref)を呼び出すと、完了を待ってから戻り値を取得できます。

`$`を使うと、値を`@spawn`に補間できます。これにより、値は構築される基底クロージャに直接コピーされます。変数の*値*を挿入できるため、現在のタスクでその変数の値が変更されても、非同期コードには影響しません。

!!! note
    タスクがyieldすると、実行されるスレッドが変わることがあります。そのため、タスク内で`threadid()`を定数として扱わないでください。重要な注意事項については、[`Task Migration`](@ref man-task-migration)および、より広範な[multi-threading](@ref man-multithreading)マニュアルを参照してください。[threadpools](@ref man-threadpools)の章も参照してください。


!!! compat "Julia 1.3"
    このマクロはJulia 1.3以降で利用できます。


!!! compat "Julia 1.4"
    `$`による値の補間は、Julia 1.4以降で利用できます。


!!! compat "Julia 1.9"
    Julia 1.9以降では、スレッドプールを指定できます。


!!! compat "Julia 1.12"
    Julia 1.12以降では、同じスレッドプールを指定できます。


# Examples

```julia-repl
julia> t() = println("Hello from ", Threads.threadid());

julia> tasks = fetch.([Threads.@spawn t() for i in 1:4]);
Hello from 1
Hello from 1
Hello from 3
Hello from 4
```
