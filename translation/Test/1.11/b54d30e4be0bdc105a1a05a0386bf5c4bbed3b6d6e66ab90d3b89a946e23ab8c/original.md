```julia
@testset [CustomTestSet] [options...] ["description"] begin test_ex end
@testset [CustomTestSet] [options...] ["description $v"] for v in itr test_ex end
@testset [CustomTestSet] [options...] ["description $v, $w"] for v in itrv, w in itrw test_ex end
@testset [CustomTestSet] [options...] ["description"] test_func()
@testset let v = v, w = w; test_ex; end
```

# With begin/end or function call

When @testset is used, with begin/end or a single function call, the macro starts a new test set in which to evaluate the given expression.

If no custom testset type is given it defaults to creating a `DefaultTestSet`. `DefaultTestSet` records all the results and, if there are any `Fail`s or `Error`s, throws an exception at the end of the top-level (non-nested) test set, along with a summary of the test results.

Any custom testset type (subtype of `AbstractTestSet`) can be given and it will also be used for any nested `@testset` invocations. The given options are only applied to the test set where they are given. The default test set type accepts the following options:

  * `verbose::Bool`: if `true`, the result summary of the nested testsets is shown even when they all pass (the default is `false`).
  * `showtiming::Bool`: if `true`, the duration of each displayed testset is shown (the default is `true`).
  * `failfast::Bool`: if `true`, any test failure or error will cause the testset and any child testsets to return immediately (the default is `false`). This can also be set globally via the env var `JULIA_TEST_FAILFAST`.
  * `rng::Random.AbstractRNG`: use the given random number generator (RNG) as the global one for the testset.  `rng` must be `copy!`-able.  This option can be useful to locally reproduce stochastic test failures which only depend on the state of the global RNG.

!!! compat "Julia 1.8"
    `@testset test_func()` requires at least Julia 1.8.


!!! compat "Julia 1.9"
    `failfast` requires at least Julia 1.9.


!!! compat "Julia 1.12"
    The `rng` option requires at least Julia 1.12.


The description string accepts interpolation from the loop indices. If no description is provided, one is constructed based on the variables. If a function call is provided, its name will be used. Explicit description strings override this behavior.

By default the `@testset` macro will return the testset object itself, though this behavior can be customized in other testset types. If a `for` loop is used then the macro collects and returns a list of the return values of the `finish` method, which by default will return a list of the testset objects used in each iteration.

Before the execution of the body of a `@testset`, there is an implicit call to `copy!(Random.default_rng(), rng)` where `rng` is the RNG of the current task, or the value of the RNG passed via the `rng` option. Moreover, after the execution of the body, the state of the global RNG is restored to what it was before the `@testset`. This is meant to ease reproducibility in case of failure, and to allow seamless re-arrangements of `@testset`s regardless of their side-effect on the global RNG state.

!!! note "RNG of nested testsets"
    Unless changed with the `rng` option, the same RNG is set at the beginning of all nested testsets.  The RNG printed to screen when a testset has failures is the global RNG of the outermost testset even if inner testsets have different RNGs manually set by the user.


## Examples

```jldoctest; filter = r"trigonometric identities |    4      4  [0-9\.]+s"
julia> @testset "trigonometric identities" begin
           θ = 2/3*π
           @test sin(-θ) ≈ -sin(θ)
           @test cos(-θ) ≈ cos(θ)
           @test sin(2θ) ≈ 2*sin(θ)*cos(θ)
           @test cos(2θ) ≈ cos(θ)^2 - sin(θ)^2
       end;
Test Summary:            | Pass  Total  Time
trigonometric identities |    4      4  0.2s
```

# `@testset for`

When `@testset for` is used, the macro starts a new test for each iteration of the provided loop. The semantics of each test set are otherwise identical to that of that `begin/end` case (as if used for each loop iteration).

# `@testset let`

When `@testset let` is used, the macro starts a *transparent* test set with the given object added as a context object to any failing test contained therein. This is useful when performing a set of related tests on one larger object and it is desirable to print this larger object when any of the individual tests fail. Transparent test sets do not introduce additional levels of nesting in the test set hierarchy and are passed through directly to the parent test set (with the context object appended to any failing tests.)

!!! compat "Julia 1.9"
    `@testset let` requires at least Julia 1.9.


!!! compat "Julia 1.10"
    Multiple `let` assignments are supported since Julia 1.10.


# Special implicit world age increment for `@testset begin`

World age inside `@testset begin` increments implicitly after every statement. This matches the behavior of ordinary toplevel code, but not that of ordinary `begin/end` blocks, i.e. with respect to world age, `@testset begin` behaves as if the body of the `begin/end` block was written at toplevel.

## Examples

```jldoctest
julia> @testset let logi = log(im)
           @test imag(logi) == π/2
           @test !iszero(real(logi))
       end
Test Failed at none:3
  Expression: !(iszero(real(logi)))
     Context: logi = 0.0 + 1.5707963267948966im

ERROR: There was an error during testing

julia> @testset let logi = log(im), op = !iszero
           @test imag(logi) == π/2
           @test op(real(logi))
       end
Test Failed at none:3
  Expression: op(real(logi))
     Context: logi = 0.0 + 1.5707963267948966im
              op = !iszero

ERROR: There was an error during testing
```
