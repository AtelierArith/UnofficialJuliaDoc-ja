```
finish(ts::AbstractTestSet)
```

Do any final processing necessary for the given testset. This is called by the `@testset` infrastructure after a test block executes.

Custom `AbstractTestSet` subtypes should call `record` on their parent (if there is one) to add themselves to the tree of test results. This might be implemented as:

```julia
if get_testset_depth() != 0
    # Attach this test set to the parent test set
    parent_ts = get_testset()
    record(parent_ts, self)
    return self
end
```
