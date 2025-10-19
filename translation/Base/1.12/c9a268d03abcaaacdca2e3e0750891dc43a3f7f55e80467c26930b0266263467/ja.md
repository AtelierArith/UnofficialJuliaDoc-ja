```julia
eachsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
eachsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)
```

`str`を区切り文字`dlm`の出現に基づいて分割し、部分文字列のイテレータを返します。`dlm`は[`findnext`](@ref)の最初の引数で許可されている形式（すなわち、文字列、正規表現、または関数）や、単一の文字または文字のコレクションとして指定できます。

`dlm`が省略された場合、デフォルトは[`isspace`](@ref)になります。

オプションのキーワード引数は次のとおりです：

  * `limit`: 結果の最大サイズ。`limit=0`は最大なしを意味します（デフォルト）
  * `keepempty`: 空のフィールドを結果に保持するかどうか。`dlm`引数がない場合のデフォルトは`false`、`dlm`引数がある場合のデフォルトは`true`です。

他にも[`split`](@ref)を参照してください。

!!! compat "Julia 1.8"
    `eachsplit`関数は少なくともJulia 1.8が必要です。


# 例

```jldoctest
julia> a = "Ma.rch"
"Ma.rch"

julia> b = eachsplit(a, ".")
Base.SplitIterator{String, String}("Ma.rch", ".", 0, true)

julia> collect(b)
2-element Vector{SubString{String}}:
 "Ma"
 "rch"
```
