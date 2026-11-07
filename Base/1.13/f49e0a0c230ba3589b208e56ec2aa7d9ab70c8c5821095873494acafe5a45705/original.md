```julia
isgreater(x, y)
```

Not the inverse of `isless`! Test whether `x` is greater than `y`, according to a fixed total order compatible with `min`.

Defined with `isless`, this function is usually `isless(y, x)`, but `NaN` and [`missing`](@ref) are ordered as smaller than any regular value with `missing` smaller than `NaN`.

So `isless` defines an ascending total order with `NaN` and `missing` as the largest values and `isgreater` defines a descending total order with `NaN` and `missing` as the smallest values.

!!! note
    Like `min`, `isgreater` orders containers (tuples, vectors, etc) lexicographically with `isless(y, x)` rather than recursively with itself:

    ```jldoctest
    julia> Base.isgreater(1, NaN) # 1 is greater than NaN
    true

    julia> Base.isgreater((1,), (NaN,)) # But (1,) is not greater than (NaN,)
    false

    julia> sort([1, 2, 3, NaN]; lt=Base.isgreater)
    4-element Vector{Float64}:
       3.0
       2.0
       1.0
     NaN

    julia> sort(tuple.([1, 2, 3, NaN]); lt=Base.isgreater)
    4-element Vector{Tuple{Float64}}:
     (NaN,)
     (3.0,)
     (2.0,)
     (1.0,)
    ```


# Implementation

This is unexported. Types should not usually implement this function. Instead, implement `isless`.
