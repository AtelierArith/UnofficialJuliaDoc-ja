```julia
cmp(a::AbstractString, b::AbstractString)::Int
```

2つの文字列を比較します。両方の文字列の長さが同じで、各インデックスの文字も同じ場合は、`0`を返します。`a`が`b`の接頭辞である場合、または`a`がアルファベット順で`b`より前に来る場合は、`-1`を返します。`b`が`a`の接頭辞である場合、または`b`がアルファベット順（厳密にはUnicodeコードポイント順）で`a`より前に来る場合は、`1`を返します。

# Examples

```jldoctest
julia> cmp("abc", "abc")
0

julia> cmp("ab", "abc")
-1

julia> cmp("abc", "ab")
1

julia> cmp("ab", "ac")
-1

julia> cmp("ac", "ab")
1

julia> cmp("α", "a")
1

julia> cmp("b", "β")
-1
```
