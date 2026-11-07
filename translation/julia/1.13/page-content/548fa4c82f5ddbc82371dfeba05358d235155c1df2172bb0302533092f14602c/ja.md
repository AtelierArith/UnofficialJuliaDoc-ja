# StackTraces

```@docs
Base.StackTraces.StackFrame
Base.StackTraces.StackTrace
Base.StackTraces.stacktrace
```

`Base.StackTraces` にある以下のメソッドと型はエクスポートされていないため、たとえば `StackTraces.lookup(ptr)` のように呼び出す必要があります。

```@docs
Base.StackTraces.lookup
Base.StackTraces.remove_frames!
```
