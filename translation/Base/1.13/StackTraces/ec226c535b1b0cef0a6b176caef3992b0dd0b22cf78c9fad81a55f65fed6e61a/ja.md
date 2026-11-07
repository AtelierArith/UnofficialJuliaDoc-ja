```julia
remove_frames!(stack::StackTrace, name::Symbol)
```

`StackTrace`（`StackFrames`のベクトル）と関数名（`Symbol`）を受け取り、関数名で指定された`StackFrame`を`StackTrace`から削除します（指定された関数より上にあるすべてのフレームも削除します）。主に、返す前に`StackTrace`から`StackTraces`関数を取り除くために使用されます。
