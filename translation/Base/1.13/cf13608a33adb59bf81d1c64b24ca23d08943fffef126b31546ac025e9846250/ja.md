```julia
split(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
split(str::AbstractString; limit::Integer=0, keepempty::Bool=false)
```

`str`を、区切り文字`dlm`が現れる位置で分割し、部分文字列の配列を返します。`dlm`には、[`findnext`](@ref)の第1引数で使用できる形式（文字列、正規表現、関数）のほか、単一の文字または文字のコレクションを指定できます。

`dlm`を省略した場合、デフォルトは[`isspace`](@ref)です。

省略可能なキーワード引数は次のとおりです。

  * `limit`: 結果の最大サイズ。`limit=0`を指定すると上限なし（デフォルト）になります。
  * `keepempty`: 空のフィールドを結果に含めるかどうか。`dlm`引数を指定しない場合のデフォルトは`false`、`dlm`引数を指定した場合は`true`です。

関連項目: [`rsplit`](@ref)、[`eachsplit`](@ref)。

# Examples

```jldoctest
julia> a = "Ma.rch"
"Ma.rch"

julia> split(a, ".")
2-element Vector{SubString{String}}:
 "Ma"
 "rch"
```
