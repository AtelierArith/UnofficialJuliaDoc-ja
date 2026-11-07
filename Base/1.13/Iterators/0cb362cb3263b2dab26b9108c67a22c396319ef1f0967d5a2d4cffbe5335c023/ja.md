```julia
Stateful(itr)
```

このイテレーターラッパーについては、いくつかの異なる捉え方があります。

1. イテレーターとその反復状態を、可変なラッパーで包むもの。
2. イテレーターのような抽象を、`Channel`のような抽象に変換するもの。
3. 要素を生成するたびに自身を残りのイテレーターへと変化させるイテレーター。

`Stateful`は、標準的なイテレーターインターフェースを提供します。他の可変イテレーター（例：[`Base.Channel`](@ref)）と同様に、反復を途中で停止した場合（たとえば、[`for`](@ref)ループ内で[`break`](@ref)を使った場合）、同じイテレーターオブジェクトで反復を続ければ、停止した位置から再開できます（不変イテレーターの場合は、先頭から再開します）。

# Examples

```jldoctest
julia> a = Iterators.Stateful("abcdef");

julia> isempty(a)
false

julia> popfirst!(a)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> collect(Iterators.take(a, 3))
3-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
 'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)

julia> collect(a)
2-element Vector{Char}:
 'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)
 'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)

julia> Iterators.reset!(a); popfirst!(a)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> Iterators.reset!(a, "hello"); popfirst!(a)
'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)
```

```jldoctest
julia> a = Iterators.Stateful([1,1,1,2,3,4]);

julia> for x in a; x == 1 || break; end

julia> peek(a)
3

julia> sum(a) # Sum the remaining elements
7
```
