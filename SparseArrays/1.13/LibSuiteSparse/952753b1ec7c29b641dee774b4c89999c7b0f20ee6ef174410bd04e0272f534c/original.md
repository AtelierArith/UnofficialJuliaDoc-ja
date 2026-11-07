```julia
LibSuiteSparse.init_suitesparse
```

Internal function which is used to initialize the SuiteSparse libraries to the correct     memory management functions. Any package which directly wraps one of the following     SuiteSparse libraries *must* ensure that this function is called before the use of that     library: AMD, CAMD, COLAMD, CCOLAMD, UMFPACK, CXSparse, CHOLMOD, KLU, BTF, LDL, RBio,     SPQR, SPEX, and ParU

# Notes:

  * Currently this function only sets the memory management functions of SuiteSparse_config,   however there are also override functions for `printf`, `hypot`, and `divcomplex`.
  * SuiteSparse_config, and this initialization function, is not a dependency of CSparse,   GraphBLAS, or LAGraph.
