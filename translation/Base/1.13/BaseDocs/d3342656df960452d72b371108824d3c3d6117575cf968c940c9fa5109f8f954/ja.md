```julia
x && y
```

短絡評価を行う論理 AND。

これは `x ? y : false` と同等です。`x` が `false` の場合は `false` を返し、そうでない場合は `x` が `true` であれば `y` の評価結果を返します。`y` が式の場合、`x` が `true` のときにのみ評価されます。この動作を「短絡評価」と呼びます。

また、`y` はブール値である必要はありません。そのため、任意の `statement` に対して、`(condition) && (statement)` を `if condition; statement; end` の略記として使用できます。

[`&`](@ref)、三項演算子 `? :`、および [control flow](@ref man-conditional-evaluation) のマニュアルの節も参照してください。

# Examples

```jldoctest
julia> x = 3;

julia> x > 1 && x < 10 && x isa Int
true

julia> x < 0 && error("expected positive x")
false

julia> x > 0 && "not a boolean"
"not a boolean"
```
