```
Threads.atomic_max!(x::Atomic{T}, val::T) where T
```

`x`と`val`の最大値を原子的に`x`に格納します。

原子的に`x[] = max(x[], val)`を実行します。**古い**値を返します。

詳細については、LLVMの`atomicrmw max`命令を参照してください。

# 例

```jldoctest
julia> x = Threads.Atomic{Int}(5)
Base.Threads.Atomic{Int64}(5)

julia> Threads.atomic_max!(x, 7)
5

julia> x[]
7
```
