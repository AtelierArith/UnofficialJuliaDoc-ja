```julia
.
```

The dot operator is used to access fields or properties of objects and access variables defined inside modules.

In general, `a.b` calls `getproperty(a, :b)` (see [`getproperty`](@ref Base.getproperty)).

# Examples

```jldoctest
julia> z = 1 + 2im; z.im
2

julia> Iterators.product
product (generic function with 1 method)
```
