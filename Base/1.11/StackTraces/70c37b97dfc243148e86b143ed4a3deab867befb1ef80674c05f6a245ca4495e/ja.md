```
stacktrace([trace::Vector{Ptr{Cvoid}},] [c_funcs::Bool=false]) -> StackTrace
```

スタックトレースを `StackFrame` のベクターの形で返します。（デフォルトでは stacktrace は C 関数を返しませんが、これを有効にすることができます。）トレースを指定せずに呼び出すと、`stacktrace` は最初に `backtrace` を呼び出します。
