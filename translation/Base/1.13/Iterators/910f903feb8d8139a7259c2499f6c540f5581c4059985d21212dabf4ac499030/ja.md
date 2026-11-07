```julia
zip(iters...)
```

複数のイテレータを同時に実行し、いずれかが使い果たされるまで値を生成します。`zip` の値の型は、サブイテレータの値を要素とするタプルです。

!!! note
    `zip` は、あるイテレータが現在の反復で終了した場合に、状態を持つほかのイテレータが進まないよう、サブイテレータの呼び出し順序を調整します。


!!! note
    引数なしで `zip()` を呼び出すと、空のタプルを無限に生成するイテレータが返されます。


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
