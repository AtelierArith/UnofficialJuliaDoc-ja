```julia
Threads.atomic_max!(x::Atomic{T}, val::T) where T
```

`x` と `val` のうち大きい方を、`x` にアトミックに格納します。

`x[] = max(x[], val)` をアトミックに実行します。**古い**値を返します。

詳しくは、LLVM の `atomicrmw max` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(5)
Base.Threads.Atomic{Int64}(5)

julia> Threads.atomic_max!(x, 7)
5

julia> x[]
7
```
