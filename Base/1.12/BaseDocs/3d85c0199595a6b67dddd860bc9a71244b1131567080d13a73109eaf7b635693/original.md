```julia
begin
```

`begin...end` denotes a block of code.

```julia
begin
    println("Hello, ")
    println("World!")
end
```

Usually `begin` will not be necessary, since keywords such as [`function`](@ref) and [`let`](@ref) implicitly begin blocks of code. See also [`;`](@ref).

`begin` may also be used when indexing to represent the first index of a collection or the first index of a dimension of an array. For example, `a[begin]` is the first element of an array `a`.

!!! compat "Julia 1.4"
    Use of `begin` as an index requires Julia 1.4 or later.


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> A[begin, :]
2-element Matrix{Int64}:
 1
 2
```
