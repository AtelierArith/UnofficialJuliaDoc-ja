```julia
@trace_compile
```

式を実行し、コンパイルされたメソッド（再コンパイルされたメソッドは黄色で表示）を表示するマクロです。julia の引数 `--trace-compile=stderr --trace-compile-timing` と同様ですが、特定の呼び出しを対象とします。

```julia-repl
julia> @trace_compile rand(2,2) * rand(2,2)
#=   39.1 ms =# precompile(Tuple{typeof(Base.rand), Int64, Int64})
#=  102.0 ms =# precompile(Tuple{typeof(Base.:(*)), Array{Float64, 2}, Array{Float64, 2}})
2×2 Matrix{Float64}:
 0.421704  0.864841
 0.211262  0.444366
```

!!! compat "Julia 1.12"
    このマクロを使用するには、Julia 1.12 以降が必要です。

