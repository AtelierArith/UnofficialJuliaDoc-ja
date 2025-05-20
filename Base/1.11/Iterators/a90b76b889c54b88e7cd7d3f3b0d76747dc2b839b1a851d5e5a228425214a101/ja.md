```
peel(iter)
```

最初の要素と残りの要素に対するイテレータを返します。

イテレータが空の場合は `nothing` を返します（`iterate` のように）。

!!! compat "Julia 1.7"
    以前のバージョンでは、イテレータが空の場合に BoundsError が発生します。


参照: [`Iterators.drop`](@ref), [`Iterators.take`](@ref).

# 例

```jldoctest
julia> (a, rest) = Iterators.peel("abc");

julia> a
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> collect(rest)
2-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
```
