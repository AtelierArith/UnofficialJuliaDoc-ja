```julia
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


Run the tests for the given package(s), or for the current project if no positional argument is given to `Pkg.test` (the current project would need to be a package). The package is tested by running its `test/runtests.jl` file.

The tests are run in a temporary environment that also includes the test specific dependencies of the package. The versions of dependencies in the current project are used for the test environment unless there is a compatibility conflict between the version of the dependencies and the test-specific dependencies. In that case, if `allow_reresolve` is `false` an error is thrown and if `allow_reresolve` is `true` a feasible set of versions of the dependencies is resolved and used.

Test-specific dependnecies are declared in the project file as:

```toml
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

The tests are executed in a new process with the same `check-bounds` setting as the current Julia session and by default `startup-file=no`. If using the startup file (`~/.julia/config/startup.jl`) is desired, start julia with `--startup-file=yes`.

Inlining of functions during testing can be disabled (for better coverage accuracy) by starting julia with `--inline=no`. The tests can be run as if different command line arguments were passed to julia by passing the arguments instead to the `julia_args` keyword argument, e.g.

```julia
Pkg.test("foo"; julia_args=["--inline"])
```

To pass some command line arguments to be used in the tests themselves, pass the arguments to the `test_args` keyword argument. These could be used to control the code being tested, or to control the tests in some way. For example, the tests could have optional additional tests:

```julia
if "--extended" in ARGS
    @test some_function()
end
```

which could be enabled by testing with

```julia
Pkg.test("foo"; test_args=["--extended"])
```
