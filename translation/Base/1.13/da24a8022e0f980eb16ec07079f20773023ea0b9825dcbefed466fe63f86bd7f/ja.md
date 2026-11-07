```julia
eachmatch(r::Regex, s::AbstractString; overlap::Bool=false)
```

正規表現 `r` に一致するすべての箇所を `s` から検索し、一致箇所を反復処理するイテレーターを返します。`overlap` が `true` の場合、一致する文字列は元の文字列内でインデックスが重複してもかまいません。それ以外の場合は、異なる文字範囲に含まれている必要があります。

# Examples

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

# See also

[`match`](@ref), [`findall`](@ref), [`count`](@ref)
