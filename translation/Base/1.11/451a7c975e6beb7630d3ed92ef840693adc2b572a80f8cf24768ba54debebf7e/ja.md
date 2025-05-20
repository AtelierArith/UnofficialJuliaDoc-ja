```
axes(A)
```

配列 `A` の有効なインデックスのタプルを返します。

関連情報: [`size`](@ref), [`keys`](@ref), [`eachindex`](@ref).

# 例

```jldoctest
julia> A = fill(1, (5,6,7));

julia> axes(A)
(Base.OneTo(5), Base.OneTo(6), Base.OneTo(7))
```
