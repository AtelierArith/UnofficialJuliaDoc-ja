```julia
peel(iter)
```

最初の要素と、残りの要素を反復するイテレータを返します。

イテレータが空の場合は、`nothing`（`iterate`など）を返します。

!!! compat "Julia 1.7"
    以前のバージョンでは、イテレータが空の場合にBoundsErrorがスローされます。


関連項目: [`Iterators.drop`](@ref)、[`Iterators.take`](@ref)。

# Examples

```jldoctest
julia> (a, rest) = Iterators.peel("abc");

julia> a
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> collect(rest)
2-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
```
