```julia
Threads.threadid([t::Task])::Int
```

現在実行中のスレッド、またはタスク `t` のスレッドの ID 番号を取得します。マスタースレッドの ID は `1` です。

# Examples

```julia-repl
julia> Threads.threadid()
1

julia> Threads.@threads for i in 1:4
          println(Threads.threadid())
       end
4
2
5
4

julia> Threads.threadid(Threads.@spawn "foo")
2
```

!!! note
    タスクが実行されるスレッドは、タスクが yield すると変わることがあります。これは [`Task Migration`](@ref man-task-migration) と呼ばれます。そのため、ほとんどの場合、`threadid([task])` を使って、たとえばバッファーや状態を持つオブジェクトのベクターをインデックス指定するのは安全ではありません。

