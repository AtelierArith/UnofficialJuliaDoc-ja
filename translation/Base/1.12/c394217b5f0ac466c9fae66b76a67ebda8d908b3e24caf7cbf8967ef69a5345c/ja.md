```julia
rstrip([pred=isspace,] str::AbstractString) -> SubString
rstrip(str::AbstractString, chars) -> SubString
```

`str`から末尾の文字を削除します。削除する文字は、`chars`で指定されたもの、または関数`pred`が`true`を返すものです。

デフォルトの動作は、末尾の空白と区切り文字を削除することです。正確な詳細については[`isspace`](@ref)を参照してください。

オプションの`chars`引数は、削除する文字を指定します。これは単一の文字、または文字のベクターまたはセットであることができます。

他にも[`strip`](@ref)や[`lstrip`](@ref)があります。

# 例

```jldoctest
julia> a = rpad("March", 20)
"March               "

julia> rstrip(a)
"March"
```
