```julia
Threads.atomic_nand!(x::Atomic{T}, val::T) where T
```

原子的に `x` と `val` のビットワイズ NAND（非論理積）を行います。

`x[] = ~(x[] & val)` を原子的に実行します。**古い**値を返します。

詳細については、LLVMの `atomicrmw nand` 命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_nand!(x, 2)
3

julia> x[]
-3
```
