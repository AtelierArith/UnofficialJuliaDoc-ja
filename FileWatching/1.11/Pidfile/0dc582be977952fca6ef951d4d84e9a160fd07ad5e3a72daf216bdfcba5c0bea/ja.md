```julia
trymkpidlock([f::Function], at::String, [pid::Cint]; kwopts...)
trymkpidlock(at::String, proc::Process; kwopts...)
```

`mkpidlock`と同様ですが、ファイルがすでにロックされている場合は待機するのではなく`false`を返します。

!!! compat "Julia 1.10"
    この関数は少なくともJulia 1.10が必要です。

