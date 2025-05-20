```
IOBuffer(string::String)
```

与えられた文字列の基になるデータ上に読み取り専用の `IOBuffer` を作成します。

# 例

```jldoctest
julia> io = IOBuffer("Haho");

julia> String(take!(io))
"Haho"

julia> String(take!(io))
"Haho"
```
