```julia
Stateful(itr)
```

このイテレーターラッパーは、いくつかの異なる観点から捉えることができます。

1. イテレーターとその反復状態を包む、変更可能なラッパーです。
2. イテレーターのような抽象化を、`Channel`のような抽象化に変換します。
3. 要素を生成するたびに、自身の残りのイテレーターへと変化するイテレーターです。

`Stateful`は、標準的なイテレーターインターフェースを提供します。他の変更可能なイテレーター（例：[`Base.Channel`](@ref)）と同様に、反復を途中で停止した場合（例：[`for`](@ref)ループ内で[`break`](@ref)を使った場合）、同じイテレーターオブジェクトに対する反復を続ければ、停止した位置から再開できます（これに対し、変更不可能なイテレーターでは先頭から再開します）。

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
