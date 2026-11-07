```julia
hash(x[, h::UInt])::UInt
```

Compute an integer hash code such that `isequal(x,y)` implies `isequal(hash(x), hash(y))`. The optional second argument `h` is another hash code to be mixed with the result.

New types should implement the 2-argument form, typically by calling the 2-argument `hash` method recursively in order to mix hashes of the contents with each other (and with `h`). Typically, any type that implements `hash` should also implement its own [`==`](@ref) (hence [`isequal`](@ref)) to guarantee the property mentioned above.

The hash value may change when a new Julia process is started.

!!! warning
    When implementing the 2-argument form, the second argument `h` should *not* be given a default value such `h = UInt(0)` as this will implicitly create a 1-argument method that is more specific than the fallback (see [Note on Optional and keyword Arguments](@ref)), but potentially with the wrong seed, causing hash inconsistencies.


```jldoctest; filter = r"0x[0-9a-f]{16}"
julia> a = hash(10)
0x759d18cc5346a65f

julia> hash(10, a) # only use the output of another hash function as the second argument
0x03158cd61b1b0bd1
```

See also: [`objectid`](@ref), [`Dict`](@ref), [`Set`](@ref).
