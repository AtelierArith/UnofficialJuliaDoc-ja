```julia
@fastmath expr
```

式を変換したうえで実行します。この変換では、厳密な IEEE セマンティクスに違反する可能性のある関数が呼び出されます。これにより最速の処理が可能になりますが、結果は未定義です。数値結果が変わる可能性があるため、使用には注意してください。

これは [LLVM Fast-Math flags](https://llvm.org/docs/LangRef.html#fast-math-flags) を設定するもので、clang の `-ffast-math` オプションに相当します。詳しくは [the notes on performance annotations](@ref man-performance-annotations) を参照してください。

# Examples

```jldoctest
julia> @fastmath 1+2
3

julia> @fastmath(sin(3))
0.1411200080598672
```
