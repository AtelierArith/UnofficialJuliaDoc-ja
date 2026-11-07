```julia
NTuple{N, T}
```

すべての要素が型`T`である、長さ`N`のタプルの型を簡潔に表す方法です。

# Examples

```jldoctest
julia> isa((1, 2, 3, 4, 5, 6), NTuple{6, Int})
true
```

[`ntuple`](@ref)も参照してください。
