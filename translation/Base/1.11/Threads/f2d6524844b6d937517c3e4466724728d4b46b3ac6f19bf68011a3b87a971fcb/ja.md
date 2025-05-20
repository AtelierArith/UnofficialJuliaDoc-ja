```
Threads.atomic_or!(x::Atomic{T}, val::T) where T
```

`x`を`val`と原子的にビット単位で論理和します。

`x[] |= val`を原子的に実行します。**古い**値を返します。

詳細については、LLVMの`atomicrmw or`命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(5)
Base.Threads.Atomic{Int64}(5)

julia> Threads.atomic_or!(x, 7)
5

julia> x[]
7
```
