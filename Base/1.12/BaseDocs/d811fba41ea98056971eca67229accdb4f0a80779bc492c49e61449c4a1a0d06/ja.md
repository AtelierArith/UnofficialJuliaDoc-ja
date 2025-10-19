```julia
x && y
```

ショートサーキットブールAND。

これは `x ? y : false` と同等です：`x` が `false` の場合は `false` を返し、`x` が `true` の場合は `y` を評価した結果を返します。`y` が式である場合、`x` が `true` のときのみ評価されることに注意してください。これを「ショートサーキット」動作と呼びます。

また、`y` はブール値である必要はありません。これは、`(condition) && (statement)` が任意の `statement` に対して `if condition; statement; end` の短縮形として使用できることを意味します。

他にも [`&`](@ref)、三項演算子 `? :`、および [制御フロー](@ref man-conditional-evaluation) に関するマニュアルのセクションを参照してください。

# 例

```jldoctest
julia> x = 3;

julia> x > 1 && x < 10 && x isa Int
true

julia> x < 0 && error("expected positive x")
false

julia> x > 0 && "not a boolean"
"not a boolean"
```
