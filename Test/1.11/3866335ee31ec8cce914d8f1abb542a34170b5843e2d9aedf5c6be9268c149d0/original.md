```julia
print_test_results(ts::AbstractTestSet, depth_pad=0)
```

Print the results of an `AbstractTestSet` as a formatted table.

`depth_pad` refers to how much padding should be added in front of all output.

Called inside of `Test.finish`, if the `finish`ed testset is the topmost testset.
