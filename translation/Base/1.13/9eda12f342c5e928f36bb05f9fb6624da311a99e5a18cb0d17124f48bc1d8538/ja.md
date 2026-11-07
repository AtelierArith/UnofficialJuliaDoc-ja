```julia
axes(A, d)
```

配列 `A` の次元 `d` における、有効なインデックスの範囲を返します。

[`size`](@ref) および [arrays with custom indices](@ref man-custom-indices) に関するマニュアルの章も参照してください。

# Examples

```jldoctest
julia> A = fill(1, (5,6,7));

julia> axes(A, 2)
Base.OneTo(6)

julia> axes(A, 4) == 1:1  # all dimensions d > ndims(A) have size 1
true
```

# Usage note

各インデックスは `AbstractUnitRange{<:Integer}` である必要がありますが、同時に、カスタムインデックスを使用する型でもかまいません。たとえば、部分集合が必要な場合は、`begin`/`end` や [`firstindex`](@ref)/[`lastindex`](@ref) のような汎用インデックス構文を使用してください。

```julia
ix = axes(v, 1)
ix[2:end]          # will work for eg Vector, but may fail in general
ix[(begin+1):end]  # works for generalized indexes
```
