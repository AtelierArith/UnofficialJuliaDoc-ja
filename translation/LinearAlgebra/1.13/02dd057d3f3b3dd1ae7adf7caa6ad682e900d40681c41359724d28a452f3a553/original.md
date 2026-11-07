bk*rowcol*swap!(A, k, kp, kstep, upper, herm) -> did_swap::Bool

Performs the row and column interchange of the Bunch-Kaufman factorization. If `upper==true` then the rows and columns `kp` of `A[1:k,1:k]` are interchanged with either rows and columns `k` or `k-1` of `A[1:k,1:k]`, depending on whether `kstep==1` or `kstep==2`, respectively. If `upper==false` then the rows and columns `kp-k+1` of `A[k:N,k:N]` are interchanged with either rows and columns `1` or `2` of `A[k:N,k:N]`, depending on whether `kstep==1` or `kstep==2`, respectively. `herm=true` then it is assumed that `A` is Hermitian, and conjugation is applied to the appropriate entries of the interchanged rows and columns. If `herm=false` no conjugation is performed.

This is an internal helper function for the main Bunch-Kaufman factorization function, `generic_bunchkaufman!`. As such, validity of the input values is not verified.
