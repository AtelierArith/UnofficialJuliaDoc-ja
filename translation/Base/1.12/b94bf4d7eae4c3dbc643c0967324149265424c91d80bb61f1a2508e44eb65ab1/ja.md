```julia
signbit(x)
```

`x`の符号の値が負であれば`true`を返し、そうでなければ`false`を返します。

関連情報として[`sign`](@ref)および[`copysign`](@ref)を参照してください。

# 例

```jldoctest
julia> signbit(-4)
true

julia> signbit(5)
false

julia> signbit(5.5)
false

julia> signbit(-4.1)
true
```
