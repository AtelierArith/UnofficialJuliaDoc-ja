```
Test.Error <: Test.Result
```

The test condition couldn't be evaluated due to an exception, or it evaluated to something other than a [`Bool`](@ref). In the case of `@test_broken` it is used to indicate that an unexpected `Pass` `Result` occurred.
