```
redirect_stderr(f::Function, stream)
```

Run the function `f` while redirecting [`stderr`](@ref) to `stream`. Upon completion, [`stderr`](@ref) is restored to its prior setting.
