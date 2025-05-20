```
put!(f::Function, x::OrderedSynchronizer, i::Int, incr::Int=1)
```

Schedule `f` to be called when `x` is at order `i`. Note that `put!` will block until `f` is executed. The typical usage involves something like:

```julia
x = OrderedSynchronizer()
@sync for i = 1:N
    Threads.@spawn begin
        # do some concurrent work
        # once work is done, schedule synchronization
        put!(x, $i) do
            # report back result of concurrent work
            # won't be executed until all `i-1` calls to `put!` have already finished
        end
    end
end
```

The `incr` argument controls how much the synchronizer's state is incremented after `f` is called. By default, `incr` is 1.
