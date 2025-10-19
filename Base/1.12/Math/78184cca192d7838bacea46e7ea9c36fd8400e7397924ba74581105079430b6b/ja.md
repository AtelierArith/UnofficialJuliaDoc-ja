```julia
log10(x)
```

`x`の10を底とする対数を計算します。負の[`Real`](@ref)引数に対しては[`DomainError`](@ref)をスローします。

# 例

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> log10(100)
2.0

julia> log10(2)
0.3010299956639812

julia> log10(-2)
ERROR: DomainError with -2.0:
log10は負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。log10(Complex(x))を試してください。
Stacktrace:
 [1] throw_complex_domainerror(f::Symbol, x::Float64) at ./math.jl:31
[...]
```
