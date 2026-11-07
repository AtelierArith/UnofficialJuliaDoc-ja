```julia
Lockable(value, lock = ReentrantLock())
```

`Lockable`を作成します。このオブジェクトは`value`をラップし、指定された`lock`に関連付けます。[`@lock`](@ref)、[`lock`](@ref)、[`trylock`](@ref)、[`unlock`](@ref)をサポートします。値にアクセスするには、ロックを保持した状態でロック可能オブジェクトをインデックス指定します。

!!! compat "Julia 1.11"
    Julia 1.11以降が必要です。


## Example

```jldoctest
julia> locked_list = Base.Lockable(Int[]);

julia> @lock(locked_list, push!(locked_list[], 1)) # must hold the lock to access the value
1-element Vector{Int64}:
 1

julia> lock(summary, locked_list)
"1-element Vector{Int64}"
```
