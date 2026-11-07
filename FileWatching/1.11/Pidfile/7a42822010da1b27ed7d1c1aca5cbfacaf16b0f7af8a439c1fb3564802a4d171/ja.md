```julia
trymkpidlock([f::Function], at::String, [pid::Cint]; kwopts...)
trymkpidlock(at::String, proc::Process; kwopts...)
```

`mkpidlock`と同様ですが、ファイルがすでにロックされている場合は待機せずに`false`を返します。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10以降が必要です。

