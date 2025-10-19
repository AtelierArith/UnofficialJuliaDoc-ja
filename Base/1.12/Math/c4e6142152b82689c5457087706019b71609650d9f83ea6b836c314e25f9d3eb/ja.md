```julia
log2(x)
```

`x`の底2の対数を計算します。負の[`Real`](@ref)引数に対しては[`DomainError`](@ref)をスローします。

関連: [`exp2`](@ref), [`ldexp`](@ref), [`ispow2`](@ref).

# 例

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> log2(4)
2.0

julia> log2(10)
3.321928094887362

julia> log2(-2)
ERROR: DomainError with -2.0:
log2は負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。log2(Complex(x))を試してください。
Stacktrace:
 [1] throw_complex_domainerror(f::Symbol, x::Float64) at ./math.jl:31
[...]

julia> log2.(2.0 .^ (-1:1))
3-element Vector{Float64}:
 -1.0
  0.0
  1.0
```
