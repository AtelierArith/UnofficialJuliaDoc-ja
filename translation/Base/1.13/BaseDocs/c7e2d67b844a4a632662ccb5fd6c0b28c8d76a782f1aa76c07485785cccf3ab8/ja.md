```julia
x || y
```

短絡評価を行う論理和。

これは `x ? true : y` と同等です。`x` が `true` の場合は `true` を返し、`x` が `false` の場合は `y` を評価した結果を返します。`y` が式の場合、`x` が `false` のときにのみ評価されます。この動作を「短絡評価」と呼びます。

また、`y` はブール値である必要はありません。そのため、任意の `statement` に対して、`(condition) || (statement)` を `if !(condition); statement; end` の略記として使えます。

関連項目: [`|`](@ref)、[`xor`](@ref)、[`&&`](@ref)。

# Examples

```jldoctest
julia> pi < 3 || ℯ < 3
true

julia> false || true || println("neither is true!")
true

julia> pi < 3 || "not a boolean"
"not a boolean"
```
