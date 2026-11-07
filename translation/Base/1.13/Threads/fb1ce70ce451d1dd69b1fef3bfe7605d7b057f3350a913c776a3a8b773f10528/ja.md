```julia
Threads.atomic_xchg!(x::Atomic{T}, newval::T) where T
```

`x` の値をアトミックに交換します。

`x` の値を `newval` とアトミックに交換します。**古い**値を返します。

詳しくは、LLVM の `atomicrmw xchg` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_xchg!(x, 2)
3

julia> x[]
2
```
