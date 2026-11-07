```julia
BigInt(x)
```

任意精度整数を作成します。`x`は、`Int`（または`Int`に変換可能な任意の値）である場合があります。この型では通常の数学演算子が定義されており、演算結果は[`BigInt`](@ref)に昇格されます。

文字列からは[`parse`](@ref)を使ってインスタンスを作成できます。また、`big`文字列リテラルを使うこともできます。

# Examples

```jldoctest
julia> parse(BigInt, "42")
42

julia> big"313"
313

julia> BigInt(10)^19
10000000000000000000
```
