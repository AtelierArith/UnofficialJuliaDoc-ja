```julia
x || y
```

ショートサーキットブールOR。

これは `x ? true : y` と同等です：`x` が `true` の場合は `true` を返し、`x` が `false` の場合は `y` を評価した結果を返します。`y` が式である場合、`x` が `false` のときのみ評価されることに注意してください。これを「ショートサーキット」動作と呼びます。

また、`y` はブール値である必要はありません。これは、`(condition) || (statement)` が任意の `statement` に対して `if !(condition); statement; end` の短縮形として使用できることを意味します。

参照： [`|`](@ref), [`xor`](@ref), [`&&`](@ref)。

# 例

```jldoctest
julia> pi < 3 || ℯ < 3
true

julia> false || true || println("どちらも真ではありません！")
true

julia> pi < 3 || "ブールではない"
"ブールではない"
```
