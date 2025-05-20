```
@test_broken ex
@test_broken f(args...) key=val ...
```

Indicates a test that should pass but currently consistently fails. Tests that the expression `ex` evaluates to `false` or causes an exception. Returns a `Broken` `Result` if it does, or an `Error` `Result` if the expression evaluates to `true`.  This is equivalent to [`@test ex broken=true`](@ref @test).

The `@test_broken f(args...) key=val...` form works as for the `@test` macro.

# Examples

```jldoctest
julia> @test_broken 1 == 2
Test Broken
  Expression: 1 == 2

julia> @test_broken 1 == 2 atol=0.1
Test Broken
  Expression: ==(1, 2, atol = 0.1)
```
