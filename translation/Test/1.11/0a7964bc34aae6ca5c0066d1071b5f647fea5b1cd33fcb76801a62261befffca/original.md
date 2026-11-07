```julia
print_test_results([io::IO], ts::AbstractTestSet, depth_pad=0)
```

Print the results of an `AbstractTestSet` as a formatted table.

`depth_pad` refers to how much padding should be added in front of all output. If `io` is not provided, defaults to `stdout`.

Called inside of `Test.finish`, if the `finish`ed testset is the topmost testset.
