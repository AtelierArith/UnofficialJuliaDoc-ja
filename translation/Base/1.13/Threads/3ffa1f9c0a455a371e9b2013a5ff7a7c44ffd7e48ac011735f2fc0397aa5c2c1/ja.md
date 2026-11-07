```julia
Threads.atomic_and!(x::Atomic{T}, val::T) where T
```

`x` と `val` のビット単位の AND をアトミックに実行します。

`x[] &= val` をアトミックに実行します。**古い**値を返します。

詳しくは、LLVM の `atomicrmw and` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_and!(x, 2)
3

julia> x[]
2
```
