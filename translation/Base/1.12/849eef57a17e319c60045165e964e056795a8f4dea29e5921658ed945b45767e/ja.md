```julia
match(r::Regex, s::AbstractString[, idx::Integer[, addopts]])
```

正規表現 `r` の最初の一致を `s` で検索し、一致が失敗した場合は [`RegexMatch`](@ref) オブジェクトを返します。一致した部分文字列は `m.match` にアクセスすることで取得でき、キャプチャされたシーケンスは `m.captures` にアクセスすることで取得できます。結果の [`RegexMatch`](@ref) オブジェクトは他のコレクションを構築するために使用できます：例えば `Tuple(m)`、`NamedTuple(m)` など。

!!! compat "Julia 1.11"
    NamedTuples と Dicts を構築するには Julia 1.11 が必要です


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
