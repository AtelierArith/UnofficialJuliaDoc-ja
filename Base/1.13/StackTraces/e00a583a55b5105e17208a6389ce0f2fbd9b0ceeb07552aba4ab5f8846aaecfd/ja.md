```julia
stacktrace([trace::Vector{Ptr{Cvoid}},] [c_funcs::Bool=false])::StackTrace
```

`StackFrame`のベクターとしてスタックトレースを返します。（デフォルトでは、スタックトレースにC関数は含まれませんが、有効にできます。）トレースを指定せずに呼び出すと、`stacktrace`はまず`backtrace`を呼び出します。
