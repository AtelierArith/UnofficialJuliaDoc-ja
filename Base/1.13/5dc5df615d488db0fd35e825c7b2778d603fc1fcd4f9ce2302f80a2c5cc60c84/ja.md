```julia
@v_str
```

文字列を解析して[`VersionNumber`](@ref)に変換する文字列マクロ。

# Examples

```jldoctest
julia> v"1.2.3"
v"1.2.3"

julia> v"2.0.1-rc1"
v"2.0.1-rc1"
```
