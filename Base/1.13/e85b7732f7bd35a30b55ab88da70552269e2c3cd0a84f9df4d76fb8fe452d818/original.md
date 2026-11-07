```julia
Base.julia_cmd(juliapath=joinpath(Sys.BINDIR, julia_exename()); cpu_target::Union{Nothing,String}=nothing)
```

Return a julia command similar to the one of the running process. Propagates any of the `--cpu-target`, `--sysimage`, `--compile`, `--sysimage-native-code`, `--compiled-modules`, `--pkgimages`, `--inline`, `--check-bounds`, `--optimize`, `--min-optlevel`, `-g`, `--code-coverage`, `--track-allocation`, `--color`, `--startup-file`, and `--depwarn` command line arguments that are not at their default values.

Among others, `--math-mode`, `--warn-overwrite`, and `--trace-compile` are notably not propagated currently.

Unless set to `nothing`, the `cpu_target` keyword argument can be used to override the CPU target set for the running process.

To get the julia command without propagated command line arguments, `julia_cmd()[1]` can be used.

!!! compat "Julia 1.1"
    Only the `--cpu-target`, `--sysimage`, `--depwarn`, `--compile` and `--check-bounds` flags were propagated before Julia 1.1.


!!! compat "Julia 1.5"
    The flags `--color` and `--startup-file` were added in Julia 1.5.


!!! compat "Julia 1.9"
    The keyword argument `cpu_target` was added in 1.9. The flag `--pkgimages` was added in Julia 1.9.

