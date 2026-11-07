```julia
f ∘ g
```

関数合成: つまり、`(f ∘ g)(args...; kwargs...)` は `f(g(args...; kwargs...))` を意味します。`∘` 記号は、Julia REPL（および適切に設定されたほとんどのエディター）で `\circ<tab>` と入力すると入力できます。

関数合成は前置形式でも使えます。`∘(f, g)` は `f ∘ g` と同じです。前置形式では、複数の関数の合成（`∘(f, g, h) = f ∘ g ∘ h`）や、反復可能な関数コレクションを合成するためのスプラッティング（`∘(fs...)`）もサポートされています。`∘` の最後の引数が最初に実行されます。

!!! compat "Julia 1.4"
    複数の関数の合成には、Julia 1.4 以降が必要です。


!!! compat "Julia 1.5"
    1つの関数の合成 ∘(f) には、Julia 1.5 以降が必要です。


!!! compat "Julia 1.7"
    キーワード引数を使うには、Julia 1.7 以降が必要です。


# Examples

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

[`ComposedFunction`](@ref)、[`!f::Function`](@ref) も参照してください。
