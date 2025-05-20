```
TestLogger(; min_level=Info, catch_exceptions=false)
```

Create a `TestLogger` which captures logged messages in its `logs::Vector{LogRecord}` field.

Set `min_level` to control the `LogLevel`, `catch_exceptions` for whether or not exceptions thrown as part of log event generation should be caught, and `respect_maxlog` for whether or not to follow the convention of logging messages with `maxlog=n` for some integer `n` at most `n` times.

See also: [`LogRecord`](@ref).

## Examples

```jldoctest
julia> using Test, Logging

julia> f() = @info "Hi" number=5;

julia> test_logger = TestLogger();

julia> with_logger(test_logger) do
           f()
           @info "Bye!"
       end

julia> @test test_logger.logs[1].message == "Hi"
Test Passed

julia> @test test_logger.logs[1].kwargs[:number] == 5
Test Passed

julia> @test test_logger.logs[2].message == "Bye!"
Test Passed
```
