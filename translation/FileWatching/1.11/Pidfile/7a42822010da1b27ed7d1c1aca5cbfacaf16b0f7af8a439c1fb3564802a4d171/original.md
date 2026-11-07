```julia
trymkpidlock([f::Function], at::String, [pid::Cint]; kwopts...)
trymkpidlock(at::String, proc::Process; kwopts...)
```

Like `mkpidlock` except returns `false` instead of waiting if the file is already locked.

!!! compat "Julia 1.10"
    This function requires at least Julia 1.10.

