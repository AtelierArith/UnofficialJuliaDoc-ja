```julia
precompilepkgs(pkgs; kwargs...)
```

Precompile packages and their dependencies, with support for parallel compilation, progress tracking, and various compilation configurations.

`pkgs::Union{Vector{String}, Vector{PkgId}}`: Packages to precompile. When empty (default), precompiles all project dependencies. When specified, precompiles only the given packages and their dependencies (unless `manifest=true`).

!!! note
    Errors will only throw when precompiling the top-level dependencies, given that not all manifest dependencies may be loaded by the top-level dependencies on the given system. This can be overridden to make errors in all dependencies throw by setting the kwarg `strict` to `true`


# Keyword Arguments

  * `internal_call::Bool`: Indicates this is an automatic precompilation call from somewhere external (e.g. Pkg). Do not use this parameter.
  * `strict::Bool`: Controls error reporting scope. When `false` (default), only reports errors for direct project dependencies. Only relevant when `manifest=true`.
  * `warn_loaded::Bool`: When `true` (default), checks for and warns about packages that are precompiled but already loaded with a different version. Displays a warning that Julia needs to be restarted to use the newly precompiled versions.
  * `timing::Bool`: When `true` (not default), displays timing information for each package compilation, but only if compilation might have succeeded. Disables fancy progress bar output (timing is shown in simple text mode).
  * `_from_loading::Bool`: Internal flag indicating the call originated from the package loading system. When `true` (not default): returns early instead of throwing when packages are not found; suppresses progress messages when not in an interactive session; allows packages outside the current environment to be added as serial precompilation jobs; skips LOADING_CACHE initialization; and changes cachefile locking behavior.
  * `configs::Union{Config,Vector{Config}}`: Compilation configurations to use. Each Config is a `Pair{Cmd, Base.CacheFlags}` specifying command flags and cache flags. When multiple configs are provided, each package is precompiled for each configuration.
  * `io::IO`: Output stream for progress messages, warnings, and errors. Can be redirected (e.g., to `devnull` when called from loading in non-interactive mode).
  * `fancyprint::Bool`: Controls output format. When `true`, displays an animated progress bar with spinners. When `false`, instead enables `timing` mode. Automatically disabled when `timing=true` or when called from loading in non-interactive mode.
  * `manifest::Bool`: Controls the scope of packages to precompile. When `false` (default), precompiles only packages specified in `pkgs` and their dependencies. When `true`, precompiles all packages in the manifest (workspace mode), typically used by Pkg for workspace precompile requests.
  * `ignore_loaded::Bool`: Controls whether already-loaded packages affect cache freshness checks. When `false` (not default), loaded package versions are considered when determining if cache files are fresh.

# Return

  * `Vector{String}`: Paths to cache files for the requested packages.
  * `Nothing`: precompilation should be skipped

# Notes

  * Packages in circular dependency cycles are skipped with a warning.
  * Packages with `__precompile__(false)` are skipped if they are from loading to avoid repeated work on every session.
  * Parallel compilation is controlled by `JULIA_NUM_PRECOMPILE_TASKS` environment variable (defaults to CPU_THREADS + 1, capped at 16, halved on Windows).
  * Extensions are precompiled when all their triggers are available in the environment.
