```julia
//(num, den)
```

2つの整数または有理数を除算し、[`Rational`](@ref)の結果を返します。より一般には、`//`を使うと、整数成分または有理数成分を持つ複素数など、ほかの数値型についても正確な有理数除算を行えます。

浮動小数点数（[`AbstractFloat`](@ref)）は、値が有理数であっても、`//`では引数として使用できないことに注意してください。引数は[`Integer`](@ref)、`Rational`、またはそれらから構成される型のサブタイプである必要があります。

# Examples

```jldoctest
julia> 3 // 5
3//5

julia> (3 // 5) // (2 // 1)
3//10

julia> (1+2im) // (3+4im)
11//25 + 2//25*im

julia> 1.0 // 2
ERROR: MethodError: no method matching //(::Float64, ::Int64)
[...]
```
