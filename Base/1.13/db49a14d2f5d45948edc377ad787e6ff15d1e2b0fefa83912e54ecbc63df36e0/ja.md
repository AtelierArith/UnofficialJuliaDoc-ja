```julia
@big_str str
```

文字列を[`BigInt`](@ref)または[`BigFloat`](@ref)に変換します。文字列が有効な数値でない場合は、`ArgumentError`をスローします。整数の場合、区切り文字として`_`を文字列に含めることができます。

# Examples

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
    `@big_str`を使って[`BigFloat`](@ref)の値を構築しても、直感的に期待される動作にならない場合があります。マクロである`@big_str`は、グローバルな精度（[`setprecision`](@ref)）と丸めモード（[`setrounding`](@ref)）の設定を、*読み込み時*の値に従って適用します。そのため、`() -> precision(big"0.3")`のような関数は、関数の呼び出し時の精度ではなく、関数の定義時点での精度に依存する値を定数として返します。

