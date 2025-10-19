```julia
Stateful(itr)
```

このイテレータラッパーについて考える方法はいくつかあります：

1. イテレータとその反復状態を包む可変ラッパーを提供します。
2. イテレータのような抽象を `Channel` のような抽象に変えます。
3. アイテムが生成されるたびに、自分自身の残りのイテレータになるように変化するイテレータです。

`Stateful` は通常のイテレータインターフェースを提供します。他の可変イテレータ（例：[`Base.Channel`](@ref)）と同様に、反復が早期に停止された場合（例：[`break`](@ref) を [`for`](@ref) ループ内で使用した場合）、同じイテレータオブジェクトを使って反復を続けることで、同じ場所から反復を再開できます（対照的に、不変のイテレータは最初から再スタートします）。

# 例

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

julia> sum(a) # 残りの要素の合計
7
```
