```
match(r::Regex, s::AbstractString[, idx::Integer[, addopts]])
```

正規表現 `r` の最初の一致を `s` で検索し、一致が失敗した場合は何も返さない [`RegexMatch`](@ref) オブジェクトを返します。一致した部分文字列は `m.match` にアクセスすることで取得でき、キャプチャされたシーケンスは `m.captures` にアクセスすることで取得できます。オプションの `idx` 引数は、検索を開始するインデックスを指定します。

# 例

```jldoctest
julia> rx = r"a(.)a"
r"a(.)a"

julia> m = match(rx, "cabac")
RegexMatch("aba", 1="b")

julia> m.captures
1-element Vector{Union{Nothing, SubString{String}}}:
 "b"

julia> m.match
"aba"

julia> match(rx, "cabac", 3) === nothing
true
```
