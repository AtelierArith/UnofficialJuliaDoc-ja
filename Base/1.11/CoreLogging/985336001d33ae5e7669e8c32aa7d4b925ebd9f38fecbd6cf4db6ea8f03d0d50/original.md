```
with_logger(function, logger)
```

Execute `function`, directing all log messages to `logger`.

# Examples

```julia
function test(x)
    @info "x = $x"
end

with_logger(logger) do
    test(1)
    test([1,2])
end
```
