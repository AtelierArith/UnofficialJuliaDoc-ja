```julia
Threads.atomic_xor!(x::Atomic{T}, val::T) where T
```

原子的に `x` と `val` のビット単位の排他的論理和 (XOR) を計算します。

`x[] $= val` を原子的に実行します。**古い**値を返します。

詳細については、LLVMの `atomicrmw xor` 命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(5)
Base.Threads.Atomic{Int64}(5)

julia> Threads.atomic_xor!(x, 7)
5

julia> x[]
2
```
