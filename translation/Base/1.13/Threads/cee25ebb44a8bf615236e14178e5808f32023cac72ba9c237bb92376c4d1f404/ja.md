```julia
Threads.atomic_add!(x::Atomic{T}, val::T) where T <: ArithmeticTypes
```

`val` を `x` にアトミックに加算します。

`x[] += val` をアトミックに実行します。**古い**値を返します。`Atomic{Bool}` には定義されていません。

詳しくは、LLVM の `atomicrmw add` 命令を参照してください。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_add!(x, 2)
3

julia> x[]
5
```
