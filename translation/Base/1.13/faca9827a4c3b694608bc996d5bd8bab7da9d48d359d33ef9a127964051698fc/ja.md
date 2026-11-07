```julia
indentation(str::AbstractString; tabwidth=8) -> (width::Int, empty::Bool)
```

先頭の空白の幅を計算します。幅と、文字列が空かどうかを示すフラグを返します。

# Examples

```jldoctest
julia> Base.indentation("")
(0, true)

julia> Base.indentation("  a")
(2, false)

julia> Base.indentation("\ta"; tabwidth=3)
(3, false)
```
