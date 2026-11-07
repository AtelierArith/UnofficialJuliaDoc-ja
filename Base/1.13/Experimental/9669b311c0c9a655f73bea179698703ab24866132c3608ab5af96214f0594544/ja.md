```julia
Experimental.@force_compile
```

ブロックまたは関数を強制的にコンパイルします（Julia の組み込みインタープリターでは実行できません）。

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
