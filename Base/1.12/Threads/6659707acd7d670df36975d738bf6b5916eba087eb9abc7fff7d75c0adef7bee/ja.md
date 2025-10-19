```julia
Threads.atomic_min!(x::Atomic{T}, val::T) where T
```

`x`と`val`の最小値を原子的に`x`に格納します。

`x[] = min(x[], val)`を原子的に実行します。**古い**値を返します。

詳細については、LLVMの`atomicrmw min`命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(7)
Base.Threads.Atomic{Int64}(7)

julia> Threads.atomic_min!(x, 5)
7

julia> x[]
5
```
