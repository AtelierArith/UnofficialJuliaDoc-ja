```julia
mmap(io, BitArray, [dims, offset])
```

ファイルにリンクされた[`BitArray`](@ref)を作成します。これはメモリマッピングを使用しており、同じ目的を持ち、同じ方法で動作し、同じ引数を持ちますが、バイト表現が異なります。

# 例

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

これは、ストリーム`io`に関連付けられたファイルにリンクされた25×30000の`BitArray`を作成します。
