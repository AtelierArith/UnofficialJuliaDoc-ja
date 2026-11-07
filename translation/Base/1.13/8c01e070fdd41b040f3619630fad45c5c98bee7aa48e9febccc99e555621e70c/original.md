```julia
Base.generating_output([incremental::Bool])::Bool
```

Return `true` if the current process is being used to pre-generate a code cache via any of the `--output-*` command line arguments. The optional `incremental` argument further specifies the precompilation mode: when set to `true`, the function will return `true` only for package precompilation; when set to `false`, it will return `true` only for system image generation.

!!! compat "Julia 1.11"
    This function requires at least Julia 1.11.

