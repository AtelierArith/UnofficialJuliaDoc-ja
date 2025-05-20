```
//(num, den)
```

2つの整数または有理数を割り算し、[`Rational`](@ref) 結果を返します。より一般的には、`//` は整数または有理数の成分を持つ他の数値型、例えば整数成分を持つ複素数の正確な有理数除算に使用できます。

浮動小数点数（[`AbstractFloat`](@ref)）の引数は `//` では許可されていません（たとえ値が有理数であっても）。引数は [`Integer`](@ref)、`Rational`、またはそれらの合成型のサブタイプでなければなりません。

# 例

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
