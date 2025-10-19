```julia
TestCounts
```

Holds the state for recursively gathering the results of a test set for display purposes.

Fields:

  * `customized`: Whether the function `get_test_counts` was customized for the `AbstractTestSet`               this counts object is for. If a custom method was defined, always pass `true`               to the constructor.
  * `passes`: The number of passing `@test` invocations.
  * `fails`: The number of failing `@test` invocations.
  * `errors`: The number of erroring `@test` invocations.
  * `broken`: The number of broken `@test` invocations.
  * `passes`: The cumulative number of passing `@test` invocations.
  * `fails`: The cumulative number of failing `@test` invocations.
  * `errors`: The cumulative number of erroring `@test` invocations.
  * `broken`: The cumulative number of broken `@test` invocations.
  * `duration`: The total duration the `AbstractTestSet` in question ran for, as a formatted `String`.
