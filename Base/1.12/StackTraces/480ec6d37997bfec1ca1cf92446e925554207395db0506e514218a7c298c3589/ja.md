```julia
remove_frames!(stack::StackTrace, m::Module)
```

指定された `Module` からすべての `StackFrame` を削除した `StackTrace` を返します。
