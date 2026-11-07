```julia
call_abi(p::AbstractPlatform)
```

指定された`Platform`オブジェクトの呼び出しABIを、`String`として取得します。明示的な`call_abi`の選択肢がないプラットフォーム（ほとんどのプラットフォーム）では、`nothing`を返します。

# Examples

```jldoctest
julia> call_abi(Platform("armv7l", "Linux"))
"eabihf"

julia> call_abi(Platform("x86_64", "macos"))
```
