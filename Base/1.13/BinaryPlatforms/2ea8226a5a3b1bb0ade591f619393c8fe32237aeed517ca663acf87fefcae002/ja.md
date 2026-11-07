```julia
arch(p::AbstractPlatform)
```

指定した `Platform` オブジェクトのアーキテクチャを、`String` として取得します。

# Examples

```jldoctest
julia> arch(Platform("aarch64", "Linux"))
"aarch64"

julia> arch(Platform("amd64", "freebsd"))
"x86_64"
```
