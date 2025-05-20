```
arg_readers(arg :: AbstractString, [ type = ArgRead ]) do arg::Function
    ## pre-test setup ##
    @arg_test arg begin
        arg :: ArgRead
        ## test using `arg` ##
    end
    ## post-test cleanup ##
end
```

The `arg_readers` function takes a path to be read and a single-argument do block, which is invoked once for each test reader type that `arg_read` can handle. If the optional `type` argument is given then the do block is only invoked for readers that produce arguments of that type.

The `arg` passed to the do block is not the argument value itself, because some of test argument types need to be initialized and finalized for each test case. Consider an open file handle argument: once you've used it for one test, you can't use it again; you need to close it and open the file again for the next test. This function `arg` can be converted into an `ArgRead` instance using `@arg_test arg begin ... end`.
