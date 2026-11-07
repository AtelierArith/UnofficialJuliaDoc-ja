```julia
TestLogger(; min_level=Info, catch_exceptions=false)
```

ログに記録されたメッセージを`logs::Vector{LogRecord}`フィールドに格納する`TestLogger`を作成します。

`LogLevel`を制御するには`min_level`を設定します。ログイベントの生成中に発生した例外を捕捉するかどうかは`catch_exceptions`で、整数`n`に対して`maxlog=n`を付けたメッセージを最大`n`回記録する慣例に従うかどうかは`respect_maxlog`で設定します。

関連項目: [`LogRecord`](@ref)。

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
