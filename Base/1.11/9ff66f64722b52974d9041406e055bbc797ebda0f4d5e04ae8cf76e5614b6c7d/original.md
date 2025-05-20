Lockable(value, lock = ReentrantLock())

Creates a `Lockable` object that wraps `value` and associates it with the provided `lock`. This object supports [`@lock`](@ref), [`lock`](@ref), [`trylock`](@ref), [`unlock`](@ref). To access the value, index the lockable object while holding the lock.

!!! compat "Julia 1.11"
    Requires at least Julia 1.11.


## Example

```jldoctest
julia> locked_list = Base.Lockable(Int[]);

julia> @lock(locked_list, push!(locked_list[], 1)) # must hold the lock to access the value
1-element Vector{Int64}:
 1

julia> lock(summary, locked_list)
"1-element Vector{Int64}"
```
