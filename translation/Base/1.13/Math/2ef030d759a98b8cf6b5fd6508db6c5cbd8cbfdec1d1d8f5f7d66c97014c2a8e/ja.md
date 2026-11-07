```julia
log(x)
```

`x` の自然対数を計算します。

負の [`Real`](@ref) 引数には [`DomainError`](@ref) をスローします。[`Complex`](@ref) 引数を使うと、[`Complex`](@ref) の結果が得られます。

!!! note "分岐切断"
    `log` の分岐切断は負の実軸に沿っており、`-0.0im` はその軸の下側にあるものとします。


関連項目: [`ℯ`](@ref)、[`log1p`](@ref)、[`log2`](@ref)、[`log10`](@ref)。

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> log(2)
0.6931471805599453

julia> log(-3)
ERROR: DomainError with -3.0:
log was called with a negative real argument but will only return a complex result if called with a complex argument. Try log(Complex(x)).
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

julia> log(-3 + 0im)
1.0986122886681098 + 3.141592653589793im

julia> log(-3 - 0.0im)
1.0986122886681098 - 3.141592653589793im

julia> log.(exp.(-1:1))
3-element Vector{Float64}:
 -1.0
  0.0
  1.0
```
