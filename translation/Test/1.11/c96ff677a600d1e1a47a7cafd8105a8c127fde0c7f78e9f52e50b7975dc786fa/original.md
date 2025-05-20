```
@test_throws exception expr
```

Tests that the expression `expr` throws `exception`. The exception may specify either a type, a string, regular expression, or list of strings occurring in the displayed error message, a matching function, or a value (which will be tested for equality by comparing fields). Note that `@test_throws` does not support a trailing keyword form.

!!! compat "Julia 1.8"
    The ability to specify anything other than a type or a value as `exception` requires Julia v1.8 or later.


# Examples

```jldoctest
julia> @test_throws BoundsError [1, 2, 3][4]
Test Passed
      Thrown: BoundsError

julia> @test_throws DimensionMismatch [1, 2, 3] + [1, 2]
Test Passed
      Thrown: DimensionMismatch

julia> @test_throws "Try sqrt(Complex" sqrt(-1)
Test Passed
     Message: "DomainError with -1.0:\nsqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x))."
```

In the final example, instead of matching a single string it could alternatively have been performed with:

  * `["Try", "Complex"]` (a list of strings)
  * `r"Try sqrt\([Cc]omplex"` (a regular expression)
  * `str -> occursin("complex", str)` (a matching function)
