```julia
strides(A)
```

各次元のメモリストライドのタプルを返します。

関連: [`stride`](@ref).

# 例

```jldoctest
julia> A = fill(1, (3,4,5));

julia> strides(A)
(1, 3, 12)
```
