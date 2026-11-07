```julia
strip([pred=isspace,] str::AbstractString)::SubString
strip(str::AbstractString, chars)::SubString
```

`str` の先頭と末尾から、`chars` で指定した文字、または関数 `pred` が `true` を返す文字を削除します。

デフォルトでは、先頭と末尾の空白文字および区切り文字を削除します。詳しくは、[`isspace`](@ref) を参照してください。

省略可能な `chars` 引数では、削除する文字を指定します。単一の文字、文字のベクトル、または文字の集合を指定できます。

[`lstrip`](@ref) および [`rstrip`](@ref) も参照してください。

!!! compat "Julia 1.2"
    述語関数を受け取るメソッドを使用するには、Julia 1.2 以降が必要です。


# Examples

```jldoctest
julia> strip("{3, 5}\n", ['{', '}', '\n'])
"3, 5"
```
