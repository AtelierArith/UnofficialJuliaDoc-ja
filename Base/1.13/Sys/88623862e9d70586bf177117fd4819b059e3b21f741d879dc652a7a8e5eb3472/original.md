```julia
Sys.sysimage_target()
```

Return the CPU target string that was used to build the current system image.

This function returns the original CPU target specification that was passed to Julia when the system image was compiled. This can be useful for reproducing the same system image or for understanding what CPU features were enabled during compilation.

If the system image was built with the default settings this will return `"native"`.

See also [`JULIA_CPU_TARGET`](@ref).
