```julia
length(A::AbstractArray)
```

配列内の要素数を返します。デフォルトでは `prod(size(A))` です。

# 例

```jldoctest
julia> length([1, 2, 3, 4])
4

julia> length([1 2; 3 4])
4
```
