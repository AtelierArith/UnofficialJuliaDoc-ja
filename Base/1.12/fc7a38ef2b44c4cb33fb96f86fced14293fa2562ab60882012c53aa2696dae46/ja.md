```julia
eachmatch(r::Regex, s::AbstractString; overlap::Bool=false)
```

正規表現 `r` のすべての一致を文字列 `s` で検索し、一致のイテレータを返します。`overlap` が `true` の場合、一致するシーケンスは元の文字列のインデックスで重複することが許可されます。そうでない場合は、異なる文字範囲からでなければなりません。

# 例

```jldoctest
julia> rx = r"a.a"
r"a.a"

julia> m = eachmatch(rx, "a1a2a3a")
Base.RegexMatchIterator{String}(r"a.a", "a1a2a3a", false)

julia> collect(m)
2-element Vector{RegexMatch}:
 RegexMatch("a1a")
 RegexMatch("a3a")

julia> collect(eachmatch(rx, "a1a2a3a", overlap = true))
3-element Vector{RegexMatch}:
 RegexMatch("a1a")
 RegexMatch("a2a")
 RegexMatch("a3a")
```
