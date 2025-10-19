```julia
lstrip([pred=isspace,] str::AbstractString) -> SubString
lstrip(str::AbstractString, chars) -> SubString
```

`str`から先頭の文字を削除します。削除する文字は、`chars`で指定されたものか、または関数`pred`が`true`を返すものです。

デフォルトの動作は、先頭の空白と区切り文字を削除することです。正確な詳細については[`isspace`](@ref)を参照してください。

オプションの`chars`引数は、削除する文字を指定します。これは単一の文字、または文字のベクターまたはセットであることができます。

他にも[`strip`](@ref)や[`rstrip`](@ref)があります。

# 例

```jldoctest
julia> a = lpad("March", 20)
"               March"

julia> lstrip(a)
"March"
```
