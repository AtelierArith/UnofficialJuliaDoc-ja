```
Threads.@spawn [:default|:interactive] expr
```

[`Task`](@ref) を作成し、指定されたスレッドプール（指定されていない場合は `:default`）の任意の利用可能なスレッドで実行するように [`schedule`](@ref) します。タスクは、利用可能なスレッドが見つかると、そのスレッドに割り当てられます。タスクが完了するのを待つには、このマクロの結果に対して [`wait`](@ref) を呼び出すか、[`fetch`](@ref) を呼び出して待機し、その後戻り値を取得します。

値は `$` を介して `@spawn` に埋め込むことができ、これにより値が構築された基盤となるクロージャに直接コピーされます。これにより、変数の*値*を挿入でき、現在のタスク内での変数の値の変更から非同期コードを隔離できます。

!!! note
    タスクが実行されるスレッドは、タスクが中断されると変更される可能性があるため、`threadid()` はタスクに対して定数として扱うべきではありません。詳細な重要な注意事項については、[`Task Migration`](@ref man-task-migration) およびより広範な [multi-threading](@ref man-multithreading) マニュアルを参照してください。また、[threadpools](@ref man-threadpools) に関する章も参照してください。


!!! compat "Julia 1.3"
    このマクロは Julia 1.3 以降で利用可能です。


!!! compat "Julia 1.4"
    `$` を介して値を埋め込むことは Julia 1.4 以降で利用可能です。


!!! compat "Julia 1.9"
    スレッドプールは Julia 1.9 以降で指定できます。


# 例

```julia-repl
julia> t() = println("Hello from ", Threads.threadid());

julia> tasks = fetch.([Threads.@spawn t() for i in 1:4]);
Hello from 1
Hello from 1
Hello from 3
Hello from 4
```
