```julia
Threads.foreach(f, channel::Channel;
                schedule::Threads.AbstractSchedule=Threads.FairSchedule(),
                ntasks=Threads.threadpoolsize())
```

`foreach(f, channel)`と似ていますが、`channel`の反復処理と`f`への呼び出しは、`Threads.@spawn`によって生成された`ntasks`タスクに分割されます。この関数は、内部で生成されたすべてのタスクが完了するのを待ってから戻ります。

`schedule isa FairSchedule`の場合、`Threads.foreach`は、Juliaのスケジューラがスレッド間で作業項目をより自由にロードバランスできるようにタスクを生成しようとします。このアプローチは一般的にアイテムごとのオーバーヘッドが高くなりますが、他のマルチスレッドワークロードと同時に実行する場合、`StaticSchedule`よりもパフォーマンスが向上する可能性があります。

`schedule isa StaticSchedule`の場合、`Threads.foreach`は、`FairSchedule`よりもアイテムごとのオーバーヘッドが低くなるようにタスクを生成しますが、ロードバランスにはあまり適していません。このアプローチは、細かく均一なワークロードにより適している可能性がありますが、他のマルチスレッドワークロードと同時に実行する場合、`FairSchedule`よりもパフォーマンスが悪くなる可能性があります。

# 例

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
    この関数はJulia 1.6以降が必要です。

