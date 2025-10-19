```julia
unsafe_trunc(T, x)
```

絶対値が `x` の絶対値以下である `T` 型の最も近い整数値を返します。もしその値が `T` で表現できない場合は、任意の値が返されます。詳細は [`trunc`](@ref) を参照してください。

# 例

```jldoctest
julia> unsafe_trunc(Int, -2.2)
-2

julia> unsafe_trunc(Int, NaN)
-9223372036854775808
```
