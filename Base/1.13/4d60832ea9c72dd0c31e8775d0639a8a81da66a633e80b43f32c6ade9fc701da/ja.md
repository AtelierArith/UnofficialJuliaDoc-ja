```julia
eachrsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
eachrsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)
```

`SubString` のイテレーターを返します。これは `str` を区切り文字 `dlm` で分割して得られるもので、右から左の順に返されます。`dlm` には、[`findprev`](@ref) の第1引数で使用できる形式（文字列、単一の文字、関数）のほか、文字のコレクションも指定できます。

`dlm` を省略した場合は [`isspace`](@ref) が使われ、`keepempty` の既定値は `false` です。

省略可能なキーワード引数は次のとおりです。

  * `limit > 0` の場合、残りの文字列を分割せずに返すまでの分割回数を `limit - 1` 回までに制限します。`limit < 1` は分割回数を制限しないことを意味します（既定）。
  * `keepempty`: イテレーション時に空のフィールドを返すかどうか。`dlm` 引数を指定しない場合の既定値は `false`、`dlm` 引数を指定した場合の既定値は `true` です。

[`split`](@ref)、[`rsplit`](@ref)、[`eachsplit`](@ref) とは異なり、この関数は入力内の部分文字列を、出現順とは逆の右から左の順にイテレーションすることに注意してください。

関連項目: [`eachsplit`](@ref)、[`rsplit`](@ref)。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


# Examples

```jldoctest
julia> a = "Ma.r.ch";

julia> collect(eachrsplit(a, ".")) == ["ch", "r", "Ma"]
true

julia> collect(eachrsplit(a, "."; limit=2)) == ["ch", "Ma.r"]
true
```
