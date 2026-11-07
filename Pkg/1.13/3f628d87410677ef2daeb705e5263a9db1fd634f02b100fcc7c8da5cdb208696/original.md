```julia
Pkg.gc(; collect_delay::Period=Day(7), io::IO=stderr)
```

Garbage-collect package and artifact installations by sweeping over all known `Manifest.toml` and `Artifacts.toml` files, noting those that have been deleted, and then finding artifacts and packages that are thereafter not used by any other projects, marking them as "orphaned".  This method will only remove orphaned objects (package versions, artifacts, and scratch spaces) that have been continually un-used for a period of `collect_delay`; which defaults to seven days.

To disable automatic garbage collection, you can set the environment variable `JULIA_PKG_GC_AUTO` to `"false"` before starting Julia or call `API.auto_gc(false)`.
