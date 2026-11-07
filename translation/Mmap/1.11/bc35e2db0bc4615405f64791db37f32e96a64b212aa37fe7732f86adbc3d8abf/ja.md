```julia
Mmap.Anonymous(name::AbstractString="", readonly::Bool=false, create::Bool=true)
```

`IO`のようなオブジェクトを作成します。ファイルに紐付かない、ゼロ初期化されたメモリマップ領域を作成し、[`mmap`](@ref mmap)で使用します。共有メモリ配列の作成には`SharedArray`が使用します。

# Examples

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
