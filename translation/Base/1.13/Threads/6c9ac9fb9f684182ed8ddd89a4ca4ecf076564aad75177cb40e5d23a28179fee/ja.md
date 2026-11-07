```julia
Threads.atomic_min!(x::Atomic{T}, val::T) where T
```

`x` と `val` の最小値を `x` にアトミックに格納します。

`x[] = min(x[], val)` をアトミックに実行します。**古い**値を返します。

詳しくは、LLVM の `atomicrmw min` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(7)
Base.Threads.Atomic{Int64}(7)

julia> Threads.atomic_min!(x, 5)
7

julia> x[]
5
```
