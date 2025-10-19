```julia
Threads.atomic_and!(x::Atomic{T}, val::T) where T
```

`x`を`val`と原子的にビット単位でANDします。

`x[] &= val`を原子的に実行します。**古い**値を返します。

詳細については、LLVMの`atomicrmw and`命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_and!(x, 2)
3

julia> x[]
2
```
