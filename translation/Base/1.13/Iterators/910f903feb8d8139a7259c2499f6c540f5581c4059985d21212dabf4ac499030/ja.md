```julia
zip(iters...)
```

複数のイテレータを同時に実行し、いずれかが終了するまで続けます。`zip` の値の型は、そのサブイテレータの値を要素とするタプルです。

!!! note
    `zip` は、あるイテレータが現在の反復で終了したときに、状態を持つほかのイテレータが進まないよう、サブイテレータの呼び出し順序を調整します。


!!! note
    引数なしの `zip()` は、空のタプルを無限に返すイテレータを生成します。


関連項目: [`enumerate`](@ref)、[`Base.splat`](@ref)。

# Examples

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
