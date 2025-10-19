```julia
Lockable(value, lock = ReentrantLock())
```

`value`をラップし、提供された`lock`に関連付けられた`Lockable`オブジェクトを作成します。このオブジェクトは[`@lock`](@ref)、[`lock`](@ref)、[`trylock`](@ref)、[`unlock`](@ref)をサポートします。値にアクセスするには、ロックを保持しながらロック可能オブジェクトをインデックスします。

!!! compat "Julia 1.11"
    Julia 1.11以上が必要です。


## 例

```jldoctest
julia> locked_list = Base.Lockable(Int[]);

julia> @lock(locked_list, push!(locked_list[], 1)) # 値にアクセスするにはロックを保持する必要があります
1-element Vector{Int64}:
 1

julia> lock(summary, locked_list)
"1-element Vector{Int64}"
```
