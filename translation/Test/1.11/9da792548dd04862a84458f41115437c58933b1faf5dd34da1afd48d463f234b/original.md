Simple unit testing functionality:

  * `@test`
  * `@test_throws`

All tests belong to a *test set*. There is a default, task-level test set that throws on the first failure. Users can choose to wrap their tests in (possibly nested) test sets that will store results and summarize them at the end of the test set with `@testset`.

Environment variables:

  * `JULIA_TEST_VERBOSE`: Set to `true` to enable verbose test output, including testset entry/exit messages and detailed hierarchical test summaries.
  * `JULIA_TEST_FAILFAST`: Set to `true` to stop testing on the first failure.
  * `JULIA_TEST_RECORD_PASSES`: Set to `true` to record passed tests (for debugging).
