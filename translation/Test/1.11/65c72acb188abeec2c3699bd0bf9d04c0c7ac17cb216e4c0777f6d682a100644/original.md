"     get*test*counts(::AbstractTestSet) -> TestCounts

Recursive function that counts the number of test results of each type directly in the testset, and totals across the child testsets.

Custom `AbstractTestSet` should implement this function to get their totals counted & displayed with `DefaultTestSet` as well.

If this is not implemented for a custom `TestSet`, the printing falls back to reporting `x` for failures and `?s` for the duration.
