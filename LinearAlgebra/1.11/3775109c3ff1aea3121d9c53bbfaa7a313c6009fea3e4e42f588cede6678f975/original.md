```
LAPACKException
```

Generic LAPACK exception thrown either during direct calls to the [LAPACK functions](@ref man-linalg-lapack-functions) or during calls to other functions that use the LAPACK functions internally but lack specialized error handling. The `info` field contains additional information on the underlying error and depends on the LAPACK function that was invoked.
