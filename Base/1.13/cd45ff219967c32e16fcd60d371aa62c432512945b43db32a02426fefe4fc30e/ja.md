```julia
keytype(T::Type{<:AbstractArray})
keytype(A::AbstractArray)
```

配列のキー型を返します。これは `keys(...)` の結果の [`eltype`](@ref) と等しく、主に辞書インターフェースとの互換性のために用意されています。

# Examples

```jldoctest
julia> keytype([1, 2, 3]) == Int
true

julia> keytype([1 2; 3 4])
CartesianIndex{2}
```

!!! compat "Julia 1.2"
    配列の場合、この関数を使用するには Julia 1.2 以降が必要です。

