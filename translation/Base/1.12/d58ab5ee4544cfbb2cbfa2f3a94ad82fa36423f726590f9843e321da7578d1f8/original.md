```julia
Base.runtests(tests=["all"]; ncores=ceil(Int, Sys.CPU_THREADS / 2),
              exit_on_error=false, revise=false, propagate_project=true, [seed], [julia_args::Cmd])
```

Run the Julia unit tests listed in `tests`, which can be either a string or an array of strings, using `ncores` processors. If `exit_on_error` is `false`, when one test fails, all remaining tests in other files will still be run; they are otherwise discarded, when `exit_on_error == true`. If `revise` is `true`, the `Revise` package is used to load any modifications to `Base` or to the standard libraries before running the tests. If `propagate_project` is true the current project is propagated to the test environment. If a seed is provided via the keyword argument, it is used to seed the global RNG in the context where the tests are run; otherwise the seed is chosen randomly. The argument `julia_args` can be used to pass custom `julia` command line flags to the test process.
