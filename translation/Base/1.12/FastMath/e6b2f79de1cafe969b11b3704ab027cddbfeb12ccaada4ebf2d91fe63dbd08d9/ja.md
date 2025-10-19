```julia
@fastmath expr
```

厳密なIEEEセマンティクスに違反する可能性のある関数を呼び出す変換されたバージョンの式を実行します。これにより、可能な限り高速な操作が可能になりますが、結果は未定義です – これを行う際は注意が必要で、数値結果が変わる可能性があります。

これは、[LLVM Fast-Mathフラグ](https://llvm.org/docs/LangRef.html#fast-math-flags)を設定し、clangの`-ffast-math`オプションに対応します。詳細については、[パフォーマンス注釈に関するノート](@ref man-performance-annotations)を参照してください。

# 例

```jldoctest
julia> @fastmath 1+2
3

julia> @fastmath(sin(3))
0.1411200080598672
```
