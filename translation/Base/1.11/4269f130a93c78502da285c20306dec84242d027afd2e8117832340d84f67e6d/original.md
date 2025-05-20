```
redirect_stdin(f::Function, stream)
```

Run the function `f` while redirecting [`stdin`](@ref) to `stream`. Upon completion, [`stdin`](@ref) is restored to its prior setting.
