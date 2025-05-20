```
Threads.atomic_xchg!(x::Atomic{T}, newval::T) where T
```

`x`の値を原子的に交換します。

`x`の値を`newval`と原子的に交換します。**古い**値を返します。

詳細については、LLVMの`atomicrmw xchg`命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_xchg!(x, 2)
3

julia> x[]
2
```
