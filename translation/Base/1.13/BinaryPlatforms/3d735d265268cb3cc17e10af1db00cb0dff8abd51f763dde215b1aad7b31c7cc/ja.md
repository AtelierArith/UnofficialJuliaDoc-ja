```julia
libc(p::AbstractPlatform)
```

指定された`Platform`オブジェクトのlibcを、`String`として取得します。明示的な`libc`の選択肢がないプラットフォーム（ほとんどのプラットフォーム）では、`nothing`を返します。

# Examples

```jldoctest
julia> libc(Platform("armv7l", "Linux"))
"glibc"

julia> libc(Platform("aarch64", "linux"; libc="musl"))
"musl"

julia> libc(Platform("i686", "Windows"))
```
