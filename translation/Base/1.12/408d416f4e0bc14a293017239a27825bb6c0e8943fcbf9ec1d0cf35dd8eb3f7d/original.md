```julia
one(x)
one(T::Type)
```

Return a multiplicative identity for `x`: a value such that `one(x)*x == x*one(x) == x`. If the multiplicative identity can be deduced from the type alone, then a type may be given as an argument to `one` (e.g. `one(Int)` will work because the multiplicative identity is the same for all instances of `Int`, but `one(Matrix{Int})` is not defined because matrices of different shapes have different multiplicative identities.)

If possible, `one(x)` returns a value of the same type as `x`, and `one(T)` returns a value of type `T`.  However, this may not be the case for types representing dimensionful quantities (e.g. time in days), since the multiplicative identity must be dimensionless.  In that case, `one(x)` should return an identity value of the same precision (and shape, for matrices) as `x`.

If you want a quantity that is of the same type as `x`, or of type `T`, even if `x` is dimensionful, use [`oneunit`](@ref) instead.

See also the [`identity`](@ref) function, and `I` in [`LinearAlgebra`](@ref man-linalg) for the identity matrix.

# Examples

```jldoctest
julia> one(3.7)
1.0

julia> one(Int)
1

julia> import Dates; one(Dates.Day(1))
1
```
