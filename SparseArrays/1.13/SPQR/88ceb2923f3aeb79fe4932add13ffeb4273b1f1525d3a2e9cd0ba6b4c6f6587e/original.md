```julia
copy(F::QRSparse)
```

A shallow copy of QRSparse for use in multithreaded solve applications. Shares the factorization data but duplicates the workspace so that each copy can be used independently in a different thread.
