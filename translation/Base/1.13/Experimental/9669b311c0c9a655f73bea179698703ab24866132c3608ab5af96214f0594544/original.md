```julia
Experimental.@force_compile
```

Force compilation of the block or function (Julia's built-in interpreter is blocked from executing it).

# Examples

```julia
julia> occursin("interpreter", string(stacktrace(begin
           # with forced compilation
           Base.Experimental.@force_compile
           backtrace()
       end, true)))
false

julia> occursin("interpreter", string(stacktrace(begin
           # without forced compilation
           backtrace()
       end, true)))
true
```
