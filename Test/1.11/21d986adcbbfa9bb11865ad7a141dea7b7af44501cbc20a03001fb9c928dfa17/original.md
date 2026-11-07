```julia
@test_throws exception expr
@test_throws extype pattern expr
```

Tests that the expression `expr` throws `exception`. The exception may specify either a type, a string, regular expression, or list of strings occurring in the displayed error message, a matching function, or a value (which will be tested for equality by comparing fields).

In the two-argument form, `@test_throws exception expr`, the `exception` can be a type or a pattern.

In the three-argument form, `@test_throws extype pattern expr`, both the exception type and a message pattern are tested. The `extype` must be a type, and `pattern` may be a string, regular expression, or list of strings occurring in the displayed error message, a matching function, or a value.

Note that `@test_throws` does not support a trailing keyword form.

!!! compat "Julia 1.8"
    The ability to specify anything other than a type or a value as `exception` requires Julia v1.8 or later.


!!! compat "Julia 1.13"
    The three-argument form `@test_throws extype pattern expr` requires Julia v1.12 or later.


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

julia> @test_throws ErrorException "error foo" error("error foo 1")
Test Passed
      Thrown: ErrorException
```

In the third example, instead of matching a single string it could alternatively have been performed with:

  * `["Try", "Complex"]` (a list of strings)
  * `r"Try sqrt\([Cc]omplex"` (a regular expression)
  * `str -> occursin("complex", str)` (a matching function)

In the final example, both the exception type (`ErrorException`) and message pattern (`"error foo"`) are tested.
