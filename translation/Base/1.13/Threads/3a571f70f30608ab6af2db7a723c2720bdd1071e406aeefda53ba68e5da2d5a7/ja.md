```julia
Threads.atomic_xor!(x::Atomic{T}, val::T) where T
```

`x` と `val` のビット単位の排他的論理和（XOR）をアトミックに実行します。

`x[] $= val` をアトミックに実行します。**古い**値を返します。

詳しくは、LLVM の `atomicrmw xor` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(5)
Base.Threads.Atomic{Int64}(5)

julia> Threads.atomic_xor!(x, 7)
5

julia> x[]
2
```
