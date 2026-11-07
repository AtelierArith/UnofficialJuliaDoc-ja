```julia
wordsize(p::AbstractPlatform)
```

指定した`Platform`オブジェクトのワードサイズを取得します。

# Examples

```jldoctest
julia> wordsize(Platform("armv7l", "linux"))
32

julia> wordsize(Platform("x86_64", "macos"))
64
```
