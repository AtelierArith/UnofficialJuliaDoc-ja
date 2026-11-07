```julia
IOBuffer(string::String)
```

指定された文字列の基になるデータに対する読み取り専用の`IOBuffer`を作成します。

# Examples

```jldoctest
julia> io = IOBuffer("Haho");

julia> takestring!(io)
"Haho"

julia> takestring!(io)
"Haho"
```
