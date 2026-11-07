```julia
union!(s::Union{AbstractSet,AbstractVector}, itrs...)
```

渡された集合の[`union`](@ref)を構築し、その結果で`s`を上書きします。配列を使って順序を維持してください。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が起こることがあります。


# Examples

```jldoctest; filter = r"^\s+\d$"m
julia> a = Set([3, 4, 5]);

julia> union!(a, 1:2:7);

julia> a
Set{Int64} with 5 elements:
  5
  4
  7
  3
  1
```
