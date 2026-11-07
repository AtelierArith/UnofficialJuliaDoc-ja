```julia
send_to_end!(f::Function, v::AbstractVector, o::Base.Order.DirectOrdering[, end_stable]; lo, hi)
```

Return `(a, b)` where `v[a:b]` are the elements that are not sent to the end.

If `o isa ReverseOrdering` then the "end" of `v` is `v[lo]`.

If `end_stable` is set, the elements that are sent to the end are stable instead of the elements that are not
