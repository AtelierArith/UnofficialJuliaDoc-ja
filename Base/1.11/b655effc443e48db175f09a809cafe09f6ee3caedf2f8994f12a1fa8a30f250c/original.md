```
LOAD_PATH
```

An array of paths for `using` and `import` statements to consider as project environments or package directories when loading code. It is populated based on the [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) environment variable if set; otherwise it defaults to `["@", "@v#.#", "@stdlib"]`. Entries starting with `@` have special meanings:

  * `@` refers to the "current active environment", the initial value of which is initially determined by the [`JULIA_PROJECT`](@ref JULIA_PROJECT) environment variable or the `--project` command-line option.
  * `@stdlib` expands to the absolute path of the current Julia installation's standard library directory.
  * `@name` refers to a named environment, which are stored in depots (see [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)) under the `environments` subdirectory. The user's named environments are stored in `~/.julia/environments` so `@name` would refer to the environment in `~/.julia/environments/name` if it exists and contains a `Project.toml` file. If `name` contains `#` characters, then they are replaced with the major, minor and patch components of the Julia version number. For example, if you are running Julia 1.2 then `@v#.#` expands to `@v1.2` and will look for an environment by that name, typically at `~/.julia/environments/v1.2`.

The fully expanded value of `LOAD_PATH` that is searched for projects and packages can be seen by calling the `Base.load_path()` function.

See also [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH), [`JULIA_PROJECT`](@ref JULIA_PROJECT), [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH), and [Code Loading](@ref code-loading).
