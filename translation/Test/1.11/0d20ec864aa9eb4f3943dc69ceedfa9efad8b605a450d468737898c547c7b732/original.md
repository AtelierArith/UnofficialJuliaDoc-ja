Simple unit testing functionality:

  * `@test`
  * `@test_throws`

All tests belong to a *test set*. There is a default, task-level test set that throws on the first failure. Users can choose to wrap their tests in (possibly nested) test sets that will store results and summarize them at the end of the test set with `@testset`.
