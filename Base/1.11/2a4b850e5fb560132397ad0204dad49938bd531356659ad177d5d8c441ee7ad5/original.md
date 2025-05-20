```
StepRangeLen(         ref::R, step::S, len, [offset=1]) where {  R,S}
StepRangeLen{T,R,S}(  ref::R, step::S, len, [offset=1]) where {T,R,S}
StepRangeLen{T,R,S,L}(ref::R, step::S, len, [offset=1]) where {T,R,S,L}
```

A range `r` where `r[i]` produces values of type `T` (in the first form, `T` is deduced automatically), parameterized by a `ref`erence value, a `step`, and the `len`gth. By default `ref` is the starting value `r[1]`, but alternatively you can supply it as the value of `r[offset]` for some other index `1 <= offset <= len`. The syntax `a:b` or `a:b:c`, where any of `a`, `b`, or `c` are floating-point numbers, creates a `StepRangeLen`.

!!! compat "Julia 1.7"
    The 4th type parameter `L` requires at least Julia 1.7.

