```julia
escape_exception!(astate::AnalysisState, tryregions::Vector{UnitRange{Int}})
```

Propagates escapes via exceptions that can happen in `tryregions`.

Naively it seems enough to propagate escape information imposed on `:the_exception` object, but actually there are several other ways to access to the exception object such as `Base.current_exceptions` and manual catch of `rethrow`n object. For example, escape analysis needs to account for potential escape of the allocated object via `rethrow_escape!()` call in the example below:

```julia
const Gx = Ref{Any}()
@noinline function rethrow_escape!()
    try
        rethrow()
    catch err
        Gx[] = err
    end
end
unsafeget(x) = isassigned(x) ? x[] : throw(x)

code_escapes() do
    r = Ref{String}()
    try
        t = unsafeget(r)
    catch err
        t = typeof(err)  # `err` (which `r` may alias to) doesn't escape here
        rethrow_escape!() # `r` can escape here
    end
    return t
end
```

As indicated by the above example, it requires a global analysis in addition to a base escape analysis to reason about all possible escapes via existing exception interfaces correctly. For now we conservatively always propagate `AllEscape` to all potentially thrown objects, since such an additional analysis might not be worthwhile to do given that exception handlings and error paths usually don't need to be very performance sensitive, and optimizations of error paths might be very ineffective anyway since they are sometimes "unoptimized" intentionally for latency reasons.
