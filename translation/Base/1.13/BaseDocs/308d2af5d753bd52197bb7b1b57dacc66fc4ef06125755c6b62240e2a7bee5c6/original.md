```julia
Base.donotdelete(args...)
```

This function prevents dead-code elimination (DCE) of itself and any arguments passed to it, but is otherwise the lightest barrier possible. In particular, it is not a GC safepoint, does not model an observable heap effect, does not expand to any code itself and may be re-ordered with respect to other side effects (though the total number of executions may not change).

A useful model for this function is that it hashes all memory `reachable` from args and escapes this information through some observable side-channel that does not otherwise impact program behavior. Of course that's just a model. The function does nothing and returns `nothing`.

This is intended for use in benchmarks that want to guarantee that `args` are actually computed. (Otherwise DCE may see that the result of the benchmark is unused and delete the entire benchmark code).

!!! note
    `donotdelete` does not affect constant folding. For example, in `donotdelete(1+1)`, no add instruction needs to be executed at runtime and the code is semantically equivalent to `donotdelete(2).`


!!! note
    This intrinsic does not affect the semantics of code that is dead because it is *unreachable*. For example, the body of the function `f(x) = false && donotdelete(x)` may be deleted in its entirety. The semantics of this intrinsic only guarantee that *if* the intrinsic is semantically executed, then there is some program state at which the value of the arguments of this intrinsic were available (in a register, in memory, etc.).


!!! compat "Julia 1.8"
    This method was added in Julia 1.8.


# Examples

```julia
function loop()
    for i = 1:1000
        # The compiler must guarantee that there are 1000 program points (in the correct
        # order) at which the value of `i` is in a register, but has otherwise
        # total control over the program.
        donotdelete(i)
    end
end
```
