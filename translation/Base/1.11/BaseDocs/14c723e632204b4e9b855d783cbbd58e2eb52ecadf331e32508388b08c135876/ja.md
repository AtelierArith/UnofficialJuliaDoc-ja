```
tuple(xs...)
```

与えられたオブジェクトのタプルを構築します。

関連情報としては [`Tuple`](@ref), [`ntuple`](@ref), [`NamedTuple`](@ref) があります。

# 例

```jldoctest
julia> tuple(1, 'b', pi)
(1, 'b', π)

julia> ans === (1, 'b', π)
true

julia> Tuple(Real[1, 2, pi])  # コレクションを受け取ります
(1, 2, π)
```
