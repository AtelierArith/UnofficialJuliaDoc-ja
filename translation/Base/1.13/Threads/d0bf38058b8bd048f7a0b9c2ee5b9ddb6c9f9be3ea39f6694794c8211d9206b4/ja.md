```julia
Threads.atomic_or!(x::Atomic{T}, val::T) where T
```

`x` と `val` のビット単位の OR をアトミックに実行します。

`x[] |= val` をアトミックに実行します。**古い**値を返します。

詳しくは、LLVM の `atomicrmw or` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(5)
Base.Threads.Atomic{Int64}(5)

julia> Threads.atomic_or!(x, 7)
5

julia> x[]
7
```
