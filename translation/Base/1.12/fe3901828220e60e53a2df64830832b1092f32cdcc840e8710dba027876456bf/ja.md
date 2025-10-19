```julia
@big_str str
```

文字列を [`BigInt`](@ref) または [`BigFloat`](@ref) に解析し、文字列が有効な数値でない場合は `ArgumentError` をスローします。整数の場合、`_` は文字列内で区切り文字として許可されています。

# 例

```jldoctest
julia> big"123_456"
123456

julia> big"7891.5"
7891.5

julia> big"_"
ERROR: ArgumentError: invalid number format _ for BigInt or BigFloat
[...]
```

!!! warning
    [`BigFloat`](@ref) 値を構築するために `@big_str` を使用すると、単純に期待される動作にならない場合があります: マクロとして、`@big_str` は *ロード時* のグローバル精度 ([`setprecision`](@ref)) と丸めモード ([`setrounding`](@ref)) 設定に従います。したがって、`() -> precision(big"0.3")` のような関数は、関数が定義された時点での精度の値に依存する定数を返します。**関数が呼び出された時点での精度ではありません。**

