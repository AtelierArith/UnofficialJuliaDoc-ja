```julia
remove_frames!(stack::StackTrace, m::Module)
```

指定された`Module`から、すべての`StackFrame`を削除した`StackTrace`を返してください。
