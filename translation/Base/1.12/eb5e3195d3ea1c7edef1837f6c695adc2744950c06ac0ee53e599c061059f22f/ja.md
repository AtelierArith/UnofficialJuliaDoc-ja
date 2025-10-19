```julia
keytype(T::Type{<:AbstractArray})
keytype(A::AbstractArray)
```

配列のキータイプを返します。これは `keys(...)` の結果の [`eltype`](@ref) と等しく、主に辞書インターフェースとの互換性のために提供されています。

# 例

```jldoctest
julia> keytype([1, 2, 3]) == Int
true

julia> keytype([1 2; 3 4])
CartesianIndex{2}
```

!!! compat "Julia 1.2"
    配列の場合、この関数は少なくとも Julia 1.2 を必要とします。

