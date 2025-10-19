```julia
redirect_stdout(f::Function, stream)
```

Run the function `f` while redirecting [`stdout`](@ref) to `stream`. Upon completion, [`stdout`](@ref) is restored to its prior setting.
