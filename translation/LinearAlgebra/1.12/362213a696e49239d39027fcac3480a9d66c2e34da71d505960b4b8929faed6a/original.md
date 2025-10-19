```julia
PosDefException
```

Exception thrown when the input matrix was not [positive definite](https://en.wikipedia.org/wiki/Definiteness_of_a_matrix). Some linear algebra functions and factorizations are only applicable to positive definite matrices. The `info` field indicates the location of (one of) the eigenvalue(s) which is (are) less than/equal to 0.
