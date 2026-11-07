```julia
remove_frames!(stack::StackTrace, m::Module)
```

提供された`Module`からすべての`StackFrame`を削除したうえで、`StackTrace`を返してください。
