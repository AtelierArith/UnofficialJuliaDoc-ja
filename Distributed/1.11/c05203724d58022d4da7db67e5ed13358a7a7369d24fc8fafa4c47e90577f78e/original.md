```julia
addprocs(np::Integer=Sys.CPU_THREADS; restrict=true, kwargs...) -> List of process identifiers
```

Launch `np` workers on the local host using the in-built `LocalManager`.

Local workers inherit the current package environment (i.e., active project, [`LOAD_PATH`](@ref), and [`DEPOT_PATH`](@ref)) from the main process.

!!! warning
    Note that workers do not run a `~/.julia/config/startup.jl` startup script, nor do they synchronize their global state (such as command-line switches, global variables, new method definitions, and loaded modules) with any of the other running processes.


**Keyword arguments**:

  * `restrict::Bool`: if `true` (default) binding is restricted to `127.0.0.1`.
  * `dir`, `exename`, `exeflags`, `env`, `topology`, `lazy`, `enable_threaded_blas`: same effect as for `SSHManager`, see documentation for [`addprocs(machines::AbstractVector)`](@ref).

!!! compat "Julia 1.9"
    The inheriting of the package environment and the `env` keyword argument were added in Julia 1.9.

