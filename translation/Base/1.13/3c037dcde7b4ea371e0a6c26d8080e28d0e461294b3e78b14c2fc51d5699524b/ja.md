```julia
match(r::Regex, s::AbstractString[, idx::Integer[, addopts]])
```

正規表現 `r` の最初の一致を `s` から検索し、一致した場合はその一致を含む [`RegexMatch`](@ref) オブジェクトを返します。一致しなかった場合は何も返しません。省略可能な `idx` 引数には、検索を開始するインデックスを指定します。一致した部分文字列は `m.match` にアクセスして取得でき、キャプチャされたシーケンスは `m.captures` にアクセスして取得できます。結果の [`RegexMatch`](@ref) オブジェクトを使って、ほかのコレクションを構築できます。例: `Tuple(m)`、`NamedTuple(m)`。

!!! compat "Julia 1.11"
    NamedTuple と Dict の構築には Julia 1.11 が必要です


# Examples

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

# See also

[`eachmatch`](@ref)、[`occursin`](@ref)、[`findfirst`](@ref)
