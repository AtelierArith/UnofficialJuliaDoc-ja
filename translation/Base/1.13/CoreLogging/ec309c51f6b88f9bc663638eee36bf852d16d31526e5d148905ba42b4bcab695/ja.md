```julia
with_logger(function, logger)
```

`function`を実行し、すべてのログメッセージを`logger`に出力します。

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
