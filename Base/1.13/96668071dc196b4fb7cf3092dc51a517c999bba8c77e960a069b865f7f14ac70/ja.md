```julia
rstrip([pred=isspace,] str::AbstractString)::SubString
rstrip(str::AbstractString, chars)::SubString
```

`str` の末尾から、`chars` で指定した文字、または関数 `pred` が `true` を返す文字を削除します。

デフォルトでは、末尾の空白文字と区切り文字を削除します。詳しくは [`isspace`](@ref) を参照してください。

省略可能な `chars` 引数で、削除する文字を指定します。単一の文字、または文字のベクトルや集合を指定できます。

[`strip`](@ref) および [`lstrip`](@ref) も参照してください。

# Examples

```jldoctest
julia> a = rpad("March", 20)
"March               "

julia> rstrip(a)
"March"
```
