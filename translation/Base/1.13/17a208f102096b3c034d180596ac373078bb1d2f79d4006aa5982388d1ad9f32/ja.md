```julia
Threads.foreach(f, channel::Channel;
                schedule::Threads.AbstractSchedule=Threads.FairSchedule(),
                ntasks=Threads.threadpoolsize())
```

`foreach(f, channel)`と同様ですが、`channel`の反復処理と`f`の呼び出しは、`Threads.@spawn`が生成する複数の`ntasks`タスクに分割されます。この関数は、内部で生成したすべてのタスクが完了するまで待ってから戻ります。

`schedule isa FairSchedule`の場合、`Threads.foreach`は、Juliaのスケジューラがスレッド間で作業項目をより柔軟に負荷分散できるような方法でタスクを生成します。この方法は一般に項目ごとのオーバーヘッドが大きくなりますが、他のマルチスレッド処理と同時に実行する場合、`StaticSchedule`より高い性能を発揮することがあります。

`schedule isa StaticSchedule`の場合、`Threads.foreach`は、`FairSchedule`より項目ごとのオーバーヘッドが小さい一方、負荷分散には適していない方法でタスクを生成します。そのため、この方法は粒度が細かく均一なワークロードに適している可能性がありますが、他のマルチスレッド処理と同時に実行する場合、`FairSchedule`より性能が低下することがあります。

# Examples

```julia-repl
julia> n = 20

julia> c = Channel{Int}(ch -> foreach(i -> put!(ch, i), 1:n), 1)

julia> d = Channel{Int}(n) do ch
           f = i -> put!(ch, i^2)
           Threads.foreach(f, c)
       end

julia> collect(d)
collect(d) = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400]
```

!!! compat "Julia 1.6"
    この関数を使用するには、Julia 1.6以降が必要です。

