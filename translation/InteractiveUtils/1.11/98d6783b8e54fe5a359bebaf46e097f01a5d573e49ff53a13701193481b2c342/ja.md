```julia
@trace_compile
```

式を実行し、コンパイルされた（または黄色で再コンパイルされた）メソッドを表示するマクロで、julia args `--trace-compile=stderr --trace-compile-timing` に似ていますが、特に呼び出しに対してです。

```julia-repl
julia> @trace_compile rand(2,2) * rand(2,2)
#=   39.1 ms =# precompile(Tuple{typeof(Base.rand), Int64, Int64})
#=  102.0 ms =# precompile(Tuple{typeof(Base.:(*)), Array{Float64, 2}, Array{Float64, 2}})
2×2 Matrix{Float64}:
 0.421704  0.864841
 0.211262  0.444366
```

!!! compat "Julia 1.12"
    このマクロは少なくともJulia 1.12が必要です。

