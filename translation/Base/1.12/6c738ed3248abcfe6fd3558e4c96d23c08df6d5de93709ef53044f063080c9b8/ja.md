```julia
cmp(a::AbstractString, b::AbstractString) -> Int
```

2つの文字列を比較します。両方の文字列が同じ長さで、各インデックスの文字が両方の文字列で同じであれば `0` を返します。`a` が `b` の接頭辞である場合、または `a` がアルファベット順で `b` の前に来る場合は `-1` を返します。`b` が `a` の接頭辞である場合、または `b` がアルファベット順で `a` の前に来る場合は `1` を返します（技術的には、Unicode コードポイントによる辞書順です）。

# 例

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
