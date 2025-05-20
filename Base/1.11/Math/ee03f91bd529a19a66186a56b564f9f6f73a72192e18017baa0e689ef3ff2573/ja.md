```
sqrt(x)
```

返す $\sqrt{x}$。

負の [`Real`](@ref) 引数に対して [`DomainError`](@ref) をスローします。代わりに複素数の負の引数を使用してください。`sqrt` は負の実数軸に沿った分岐切断を持つことに注意してください。

接頭辞演算子 `√` は `sqrt` と同等です。

関連項目: [`hypot`](@ref)。

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

julia> sqrt(-81 - 0.0im)  # -0.0im は分岐切断の下にあります
0.0 - 9.0im

julia> .√(1:4)
4-element Vector{Float64}:
 1.0
 1.4142135623730951
 1.7320508075688772
 2.0
```
