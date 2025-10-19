```julia
f ∘ g
```

関数の合成：すなわち、`(f ∘ g)(args...; kwargs...)` は `f(g(args...; kwargs...))` を意味します。`∘` シンボルは、Julia REPL（および適切に設定されたほとんどのエディタ）で `\circ<tab>` と入力することで入力できます。

関数の合成はプレフィックス形式でも機能します：`∘(f, g)` は `f ∘ g` と同じです。プレフィックス形式は複数の関数の合成をサポートします：`∘(f, g, h) = f ∘ g ∘ h` および iterable コレクションの関数を合成するためのスプラッティング `∘(fs...)`。`∘` の最後の引数が最初に実行されます。

!!! compat "Julia 1.4"
    複数の関数の合成には少なくとも Julia 1.4 が必要です。


!!! compat "Julia 1.5"
    一つの関数の合成 ∘(f) には少なくとも Julia 1.5 が必要です。


!!! compat "Julia 1.7"
    キーワード引数の使用には少なくとも Julia 1.7 が必要です。


# 例

```jldoctest
julia> map(uppercase∘first, ["apple", "banana", "carrot"])
3-element Vector{Char}:
 'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)
 'B': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
 'C': ASCII/Unicode U+0043 (category Lu: Letter, uppercase)

julia> (==(6)∘length).(["apple", "banana", "carrot"])
3-element BitVector:
 0
 1
 1

julia> fs = [
           x -> 2x
           x -> x-1
           x -> x/2
           x -> x+1
       ];

julia> ∘(fs...)(3)
2.0
```

他にも [`ComposedFunction`](@ref)、[`!f::Function`](@ref) を参照してください。
