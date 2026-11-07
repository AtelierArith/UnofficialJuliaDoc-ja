```julia
mmap(io, BitArray, [dims, offset])
```

メモリマッピングを使ってファイルに値を関連付ける[`BitArray`](@ref)を作成します。目的、動作、引数は[`mmap`](@ref mmap)と同じですが、バイト表現は異なります。

# Examples

```jldoctest
julia> using Mmap

julia> io = open("mmap.bin", "w+");

julia> B = mmap(io, BitArray, (25,30000));

julia> B[3, 4000] = true;

julia> Mmap.sync!(B);

julia> close(io);

julia> io = open("mmap.bin", "r+");

julia> C = mmap(io, BitArray, (25,30000));

julia> C[3, 4000]
true

julia> C[2, 4000]
false

julia> close(io)

julia> rm("mmap.bin")
```

これにより、ストリーム`io`に関連付けられたファイルにリンクする、25×30000の`BitArray`が作成されます。
