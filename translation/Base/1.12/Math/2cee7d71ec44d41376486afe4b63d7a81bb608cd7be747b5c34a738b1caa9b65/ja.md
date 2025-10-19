```julia
sqrt(x)
```

返す $\sqrt{x}$。

負の [`Real`](@ref) 引数に対して [`DomainError`](@ref) をスローします。代わりに [`Complex`](@ref) の負の引数を使用して [`Complex`](@ref) の結果を得てください。

接頭辞演算子 `√` は `sqrt` と同等です。

!!! note "分岐切断"
    `sqrt` は負の実軸に沿って分岐切断を持ちます; `-0.0im` は軸の下にあると見なされます。


関連情報: [`hypot`](@ref)。

# 例

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> sqrt(big(81))
9.0

julia> sqrt(big(-81))
ERROR: DomainError with -81.0:
NaN result for non-NaN input.
Stacktrace:
 [1] sqrt(::BigFloat) at ./mpfr.jl:501
[...]

julia> sqrt(big(complex(-81)))
0.0 + 9.0im

julia> sqrt(-81 - 0.0im)  # -0.0im は分岐切断の下
0.0 - 9.0im

julia> .√(1:4)
4-element Vector{Float64}:
 1.0
 1.4142135623730951
 1.7320508075688772
 2.0
```
