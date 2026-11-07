Working space for Umfpack so `ldiv!` doesn't allocate.

To use multiple threads, each thread should have their own workspace this can be done using`copy(::UmfpackLU)`

The constructor is overloaded so to create appropriate sized working space based on the lu factorization or the sparse matrix and the refinement setting.
