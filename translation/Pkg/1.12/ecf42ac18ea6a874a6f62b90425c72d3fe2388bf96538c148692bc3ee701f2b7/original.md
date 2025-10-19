```julia
Pkg.activate([s::String]; shared::Bool=false, io::IO=stderr)
Pkg.activate(; temp::Bool=false, shared::Bool=false, io::IO=stderr)
```

Activate the environment at `s`. The active environment is the environment that is modified by executing package commands. The logic for what path is activated is as follows:

  * If `shared` is `true`, the first existing environment named `s` from the depots in the depot stack will be activated. If no such environment exists, create and activate that environment in the first depot.
  * If `temp` is `true` this will create and activate a temporary environment which will be deleted when the julia process is exited.
  * If `s` is an existing path, then activate the environment at that path.
  * If `s` is a package in the current project and `s` is tracking a path, then activate the environment at the tracked path.
  * Otherwise, `s` is interpreted as a non-existing path, which is then activated.

If no argument is given to `activate`, then use the first project found in `LOAD_PATH` (ignoring `"@"`). For the default value of `LOAD_PATH`, the result is to activate the `@v#.#` environment.

# Examples

```julia
Pkg.activate()
Pkg.activate("local/path")
Pkg.activate("MyDependency")
Pkg.activate(; temp=true)
```

See also [`LOAD_PATH`](https://docs.julialang.org/en/v1/base/constants/#Base.LOAD_PATH).
