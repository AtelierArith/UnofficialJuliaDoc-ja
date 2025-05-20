```
RankDeficientException
```

Exception thrown when the input matrix is [rank deficient](https://en.wikipedia.org/wiki/Rank_(linear_algebra)). Some linear algebra functions, such as the Cholesky decomposition, are only applicable to matrices that are not rank deficient. The `info` field indicates the computed rank of the matrix.
