```julia
Mmap.Anonymous(name::AbstractString="", readonly::Bool=false, create::Bool=true)
```

ファイルに結びついていないゼロ初期化されたメモリマッピング用の`IO`ライクなオブジェクトを作成します。これは[`mmap`](@ref mmap)で使用されます。`SharedArray`によって共有メモリ配列を作成するために使用されます。

# 例

```jldoctest
julia> using Mmap

julia> anon = Mmap.Anonymous();

julia> isreadable(anon)
true

julia> iswritable(anon)
true

julia> isopen(anon)
true
```
