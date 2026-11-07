```julia
print_test_errors([io::IO], ts::AbstractTestSet)
```

Prints the errors that were recorded by this `AbstractTestSet` after it was `finish`ed. If `io` is not provided, defaults to `stdout`.
