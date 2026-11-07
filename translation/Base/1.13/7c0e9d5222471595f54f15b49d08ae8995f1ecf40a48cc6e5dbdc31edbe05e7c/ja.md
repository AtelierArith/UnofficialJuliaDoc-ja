```julia
lstrip([pred=isspace,] str::AbstractString)::SubString
lstrip(str::AbstractString, chars)::SubString
```

`str` の先頭から文字を削除します。削除する文字は、`chars` で指定するか、関数 `pred` が `true` を返す文字です。

デフォルトでは、先頭の空白文字と区切り文字を削除します。詳しくは [`isspace`](@ref) を参照してください。

省略可能な引数 `chars` では、削除する文字を指定します。単一の文字、または文字のベクトルや集合を指定できます。

関連項目: [`strip`](@ref)、[`rstrip`](@ref)。

# Examples

```jldoctest
julia> a = lpad("March", 20)
"               March"

julia> lstrip(a)
"March"
```
