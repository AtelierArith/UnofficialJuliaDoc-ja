```julia
(::ComputeTryCatch{Handler})(code, [, bbs]) -> handler_info::Union{Nothing,HandlerInfo{Handler}}
const compute_trycatch = ComputeTryCatch{SimpleHandler}()
```

Given the code of a function, compute, at every statement, the current try/catch handler, and the current exception stack top. This function returns a tuple of:

```julia
1. `handler_info.handler_at`: A statement length vector of tuples
   `(catch_handler, exception_stack)`, which are indices into `handlers`

2. `handler_info.handlers`: A `Handler` vector of handlers
```
