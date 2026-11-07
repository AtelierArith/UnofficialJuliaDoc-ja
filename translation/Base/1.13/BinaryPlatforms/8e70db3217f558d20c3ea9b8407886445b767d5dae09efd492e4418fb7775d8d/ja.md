```julia
triplet(p::AbstractPlatform)
```

指定した`Platform`オブジェクトのターゲットトリプレットを、`String`として取得します。

# Examples

```jldoctest
julia> triplet(Platform("x86_64", "MacOS"))
"x86_64-apple-darwin"

julia> triplet(Platform("i686", "Windows"))
"i686-w64-mingw32"

julia> triplet(Platform("armv7l", "Linux"; libgfortran_version="3"))
"armv7l-linux-gnueabihf-libgfortran3"
```
