```julia
length(A::AbstractArray)
```

配列の要素数を返します。デフォルトは`prod(size(A))`です。

# Examples

```jldoctest
julia> length([1, 2, 3, 4])
4

julia> length([1 2; 3 4])
4
```
