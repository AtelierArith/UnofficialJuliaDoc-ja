```julia
zip(iters...)
```

複数のイテレータを同時に実行し、そのうちのいずれかが尽きるまで続けます。`zip`イテレータの値の型は、そのサブイテレータの値のタプルです。

!!! note
    `zip`は、状態を持つイテレータが現在のイテレーションで他のイテレータが終了したときに進まないように、サブイテレータへの呼び出しを順序付けます。


!!! note
    引数なしの`zip()`は、空のタプルの無限イテレータを生成します。


参照: [`enumerate`](@ref), [`Base.splat`](@ref).

# 例

```jldoctest
julia> a = 1:5
1:5

julia> b = ["e","d","b","c","a"]
5-element Vector{String}:
 "e"
 "d"
 "b"
 "c"
 "a"

julia> c = zip(a,b)
zip(1:5, ["e", "d", "b", "c", "a"])

julia> length(c)
5

julia> first(c)
(1, "e")
```
