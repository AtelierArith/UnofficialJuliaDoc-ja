```julia
stacktrace([trace::Vector{Ptr{Cvoid}},] [c_funcs::Bool=false]) -> StackTrace
```

`StackFrame`のベクターの形式でスタックトレースを返します。（デフォルトでは`stacktrace`はC関数を返しませんが、これを有効にすることができます。）トレースを指定せずに呼び出すと、`stacktrace`は最初に`backtrace`を呼び出します。
