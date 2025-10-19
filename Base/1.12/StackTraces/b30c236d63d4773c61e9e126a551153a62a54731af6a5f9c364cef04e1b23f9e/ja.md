```julia
remove_frames!(stack::StackTrace, name::Symbol)
```

`StackTrace`（`StackFrames`のベクター）と関数名（`Symbol`）を受け取り、指定された関数名によって指定された`StackFrame`を`StackTrace`から削除します（指定された関数の上にあるすべてのフレームも削除します）。主に、返す前に`StackTrace`から関数の`StackTraces`を削除するために使用されます。
