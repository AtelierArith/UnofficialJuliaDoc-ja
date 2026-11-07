```julia
stacktrace([trace::Vector{Ptr{Cvoid}},] [c_funcs::Bool=false])::StackTrace
```

`StackFrame`のベクター形式でスタックトレースを返します。（デフォルトではスタックトレースにC関数は含まれませんが、有効にできます。）トレースを指定せずに呼び出すと、`stacktrace`はまず`backtrace`を呼び出します。
