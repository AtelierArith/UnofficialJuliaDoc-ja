```
Pkg.test(; kwargs...)
Pkg.test(pkg::Union{String, Vector{String}; kwargs...)
Pkg.test(pkgs::Union{PackageSpec, Vector{PackageSpec}}; kwargs...)
```

**Keyword arguments:**

  * `coverage::Union{Bool,String}=false`: enable or disable generation of coverage statistics for the tested package. If a string is passed it is passed directly to `--code-coverage` in the test process so e.g. "user" will test all user code.
  * `allow_reresolve::Bool=true`: allow Pkg to reresolve the package versions in the test environment
  * `julia_args::Union{Cmd, Vector{String}}`: options to be passed the test process.
  * `test_args::Union{Cmd, Vector{String}}`: test arguments (`ARGS`) available in the test process.

!!! compat "Julia 1.9"
    `allow_reresolve` requires at least Julia 1.9.


!!! compat "Julia 1.9"
    Passing a string to `coverage` requires at least Julia 1.9.


Run the tests for package `pkg`, or for the current project (which thus needs to be a package) if no positional argument is given to `Pkg.test`. A package is tested by running its `test/runtests.jl` file.

The tests are run by generating a temporary environment with only the `pkg` package and its (recursive) dependencies in it. If a manifest file exists and the `allow_reresolve` keyword argument is set to `false`, the versions in the manifest file are used. Otherwise a feasible set of packages is resolved and installed.

During the tests, test-specific dependencies are active, which are given in the project file as e.g.

```
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

The tests are executed in a new process with `check-bounds=yes` and by default `startup-file=no`. If using the startup file (`~/.julia/config/startup.jl`) is desired, start julia with `--startup-file=yes`. Inlining of functions during testing can be disabled (for better coverage accuracy) by starting julia with `--inline=no`. The tests can be run as if different command line arguments were passed to julia by passing the arguments instead to the `julia_args` keyword argument, e.g.

```
Pkg.test("foo"; julia_args=["--inline"])
```

To pass some command line arguments to be used in the tests themselves, pass the arguments to the `test_args` keyword argument. These could be used to control the code being tested, or to control the tests in some way. For example, the tests could have optional additional tests:

```
if "--extended" in ARGS
    @test some_function()
end
```

which could be enabled by testing with

```
Pkg.test("foo"; test_args=["--extended"])
```
