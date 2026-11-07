```julia
eachsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
eachsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)
```

`str`を区切り文字`dlm`で分割し、部分文字列のイテレータを返します。`dlm`には、[`findnext`](@ref)の第1引数で使用できる形式（文字列、正規表現、関数）のほか、単一の文字または文字のコレクションを指定できます。

`dlm`を省略した場合、デフォルト値は[`isspace`](@ref)です。

省略可能なキーワード引数は次のとおりです。

  * `limit`: 結果の最大サイズ。`limit=0`を指定すると上限なし（デフォルト）
  * `keepempty`: 結果に空のフィールドを含めるかどうか。デフォルトは、`dlm`引数を指定しない場合は`false`、`dlm`引数を指定した場合は`true`です。

関連項目: [`split`](@ref)。

!!! compat "Julia 1.8"
    `eachsplit`関数を使用するには、Julia 1.8以降が必要です。


# Examples

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
