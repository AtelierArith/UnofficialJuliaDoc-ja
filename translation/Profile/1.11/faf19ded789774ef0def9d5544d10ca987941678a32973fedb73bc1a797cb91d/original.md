```julia
flatten(btdata::Vector, lidict::LineInfoDict) -> (newdata::Vector{UInt64}, newdict::LineInfoFlatDict)
```

Produces "flattened" backtrace data. Individual instruction pointers sometimes correspond to a multi-frame backtrace due to inlining; in such cases, this function inserts fake instruction pointers for the inlined calls, and returns a dictionary that is a 1-to-1 mapping between instruction pointers and a single StackFrame.
