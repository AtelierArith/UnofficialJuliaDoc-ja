```julia
Pkg.activate([s::String]; shared::Bool=false, io::IO=stderr)
Pkg.activate(; temp::Bool=false, shared::Bool=false, io::IO=stderr)
```

Activate the environment at `s`, or return to the default environment if no argument is given. The active environment is the environment that is modified by executing package commands. Activating an environment only affects the current Julia session and does not persist when you restart Julia (unless you use the `--project` startup flag).

# Returning to the default environment

If no argument is given to `activate`, this returns you to the default shared environment (typically `@v#.#` in `~/.julia/environments/v#.#/`). This is the standard way to "deactivate" a project environment and return to your base package setup. There is no separate `deactivate` command—`Pkg.activate()` with no arguments serves this purpose.

# Activating a path

When `s` is provided, the logic for what path is activated is as follows:

  * If `shared` is `true`, the first existing environment named `s` from the depots in the depot stack will be activated. If no such environment exists, create and activate that environment in the first depot.
  * If `temp` is `true` this will create and activate a temporary environment which will be deleted when the julia process is exited.
  * If `s` is an existing path, then activate the environment at that path.
  * If `s` is a package in the current project and `s` is tracking a path, then activate the environment at the tracked path.
  * Otherwise, `s` is interpreted as a non-existing path, which is then activated.

# Examples

```julia
# Return to default environment (deactivate current project)
Pkg.activate()

# Activate a project in a specific directory
Pkg.activate("local/path")

# Activate a developed package by name
Pkg.activate("MyDependency")

# Create and activate a temporary environment
Pkg.activate(; temp=true)
```

See also [`LOAD_PATH`](https://docs.julialang.org/en/v1/base/constants/#Base.LOAD_PATH).
