```julia
Threads.threadid([t::Task]) -> Int
```

現在の実行スレッドのID番号、またはタスク`t`のスレッドのID番号を取得します。マスタースレッドのIDは`1`です。

# 例

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
    タスクが実行されるスレッドは、タスクが中断されると変更される可能性があり、これを[`Task Migration`](@ref man-task-migration)と呼びます。このため、ほとんどの場合、`threadid([task])`を使用して、たとえばバッファや状態を持つオブジェクトのベクターにインデックスを付けることは安全ではありません。

