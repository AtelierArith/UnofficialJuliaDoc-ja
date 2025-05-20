```
@test ex
@test f(args...) key=val ...
@test ex broken=true
@test ex skip=true
```

Test that the expression `ex` evaluates to `true`. If executed inside a `@testset`, return a `Pass` `Result` if it does, a `Fail` `Result` if it is `false`, and an `Error` `Result` if it could not be evaluated. If executed outside a `@testset`, throw an exception instead of returning `Fail` or `Error`.

# Examples

```jldoctest
julia> @test true
Test Passed

julia> @test [1, 2] + [2, 1] == [3, 3]
Test Passed
```

The `@test f(args...) key=val...` form is equivalent to writing `@test f(args..., key=val...)` which can be useful when the expression is a call using infix syntax such as approximate comparisons:

```jldoctest
julia> @test π ≈ 3.14 atol=0.01
Test Passed
```

This is equivalent to the uglier test `@test ≈(π, 3.14, atol=0.01)`. It is an error to supply more than one expression unless the first is a call expression and the rest are assignments (`k=v`).

You can use any key for the `key=val` arguments, except for `broken` and `skip`, which have special meanings in the context of `@test`:

  * `broken=cond` indicates a test that should pass but currently consistently fails when `cond==true`.  Tests that the expression `ex` evaluates to `false` or causes an exception.  Returns a `Broken` `Result` if it does, or an `Error` `Result` if the expression evaluates to `true`.  Regular `@test ex` is evaluated when `cond==false`.
  * `skip=cond` marks a test that should not be executed but should be included in test summary reporting as `Broken`, when `cond==true`.  This can be useful for tests that intermittently fail, or tests of not-yet-implemented functionality. Regular `@test ex` is evaluated when `cond==false`.

# Examples

```jldoctest
julia> @test 2 + 2 ≈ 6 atol=1 broken=true
Test Broken
  Expression: ≈(2 + 2, 6, atol = 1)

julia> @test 2 + 2 ≈ 5 atol=1 broken=false
Test Passed

julia> @test 2 + 2 == 5 skip=true
Test Broken
  Skipped: 2 + 2 == 5

julia> @test 2 + 2 == 4 skip=false
Test Passed
```

!!! compat "Julia 1.7"
    The `broken` and `skip` keyword arguments require at least Julia 1.7.

