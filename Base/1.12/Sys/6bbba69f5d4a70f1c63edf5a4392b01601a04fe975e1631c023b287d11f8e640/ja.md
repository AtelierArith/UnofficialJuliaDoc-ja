```julia
Sys.CPU_THREADS::Int
```

システムで利用可能な論理CPUコアの数、すなわちCPUが同時に実行できるスレッドの数です。これは必ずしもCPUコアの数ではなく、たとえば[ハイパースレッディング](https://en.wikipedia.org/wiki/Hyper-threading)が存在する場合などです。

物理コアの数を含む詳細情報については、Hwloc.jlまたはCpuId.jlを参照してください。
