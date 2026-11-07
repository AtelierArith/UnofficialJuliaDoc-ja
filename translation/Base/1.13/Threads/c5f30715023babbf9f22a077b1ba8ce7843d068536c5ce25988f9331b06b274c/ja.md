```julia
Threads.atomic_sub!(x::Atomic{T}, val::T) where T <: ArithmeticTypes
```

`val` を `x` からアトミックに減算します。

`x[] -= val` をアトミックに実行します。**古い**値を返します。`Atomic{Bool}` では定義されていません。

詳しくは、LLVM の `atomicrmw sub` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_sub!(x, 2)
3

julia> x[]
1
```
