```julia
Sys.CPU_THREADS::Int
```

システムで利用可能な論理 CPU コアの数、つまり CPU が同時に実行できるスレッド数です。たとえば [hyper-threading](https://en.wikipedia.org/wiki/Hyper-threading) がある場合など、CPU コア数と一致するとは限りません。

物理コア数など、より詳しい情報については Hwloc.jl または CpuId.jl を参照してください。

関連項目: cgroup の制限を考慮した、コンテナ対応の CPU 数については [`Sys.EFFECTIVE_CPU_THREADS`](@ref) を参照してください。
