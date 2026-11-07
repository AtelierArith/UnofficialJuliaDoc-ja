```julia
atand(y::T) where T -> float(T)
atand(y::T, x::S) where {T,S} -> promote_type(T,S)
atand(y::AbstractMatrix{T}) where T -> AbstractMatrix{Complex{float(T)}}
```

`y` または `y/x` の逆正接を計算します。出力は度単位です。

`isnan(y)` または `isnan(x)` の場合は、`NaN` を返します。返される `NaN` は、引数が1つの形式では `T`、引数が2つの形式では `promote_type(T,S)` です。

!!! compat "Julia 1.7"
    1引数メソッドが正方行列の引数をサポートするようになったのは Julia 1.7 以降です。

