```
sparse!(I::AbstractVector{Ti}, J::AbstractVector{Ti}, V::AbstractVector{Tv},
        m::Integer, n::Integer, combine, klasttouch::Vector{Ti},
        csrrowptr::Vector{Ti}, csrcolval::Vector{Ti}, csrnzval::Vector{Tv},
        [csccolptr::Vector{Ti}], [cscrowval::Vector{Ti}, cscnzval::Vector{Tv}] ) where {Tv,Ti<:Integer}
```

Parent of and expert driver for [`sparse`](@ref); see [`sparse`](@ref) for basic usage. This method allows the user to provide preallocated storage for `sparse`'s intermediate objects and result as described below. This capability enables more efficient successive construction of [`SparseMatrixCSC`](@ref)s from coordinate representations, and also enables extraction of an unsorted-column representation of the result's transpose at no additional cost.

This method consists of three major steps: (1) Counting-sort the provided coordinate representation into an unsorted-row CSR form including repeated entries. (2) Sweep through the CSR form, simultaneously calculating the desired CSC form's column-pointer array, detecting repeated entries, and repacking the CSR form with repeated entries combined; this stage yields an unsorted-row CSR form with no repeated entries. (3) Counting-sort the preceding CSR form into a fully-sorted CSC form with no repeated entries.

Input arrays `csrrowptr`, `csrcolval`, and `csrnzval` constitute storage for the intermediate CSR forms and require `length(csrrowptr) >= m + 1`, `length(csrcolval) >= length(I)`, and `length(csrnzval >= length(I))`. Input array `klasttouch`, workspace for the second stage, requires `length(klasttouch) >= n`. Optional input arrays `csccolptr`, `cscrowval`, and `cscnzval` constitute storage for the returned CSC form `S`. If necessary, these are resized automatically to satisfy `length(csccolptr) = n + 1`, `length(cscrowval) = nnz(S)` and `length(cscnzval) = nnz(S)`; hence, if `nnz(S)` is unknown at the outset, passing in empty vectors of the appropriate type (`Vector{Ti}()` and `Vector{Tv}()` respectively) suffices, or calling the `sparse!` method neglecting `cscrowval` and `cscnzval`.

On return, `csrrowptr`, `csrcolval`, and `csrnzval` contain an unsorted-column representation of the result's transpose.

You may reuse the input arrays' storage (`I`, `J`, `V`) for the output arrays (`csccolptr`, `cscrowval`, `cscnzval`). For example, you may call `sparse!(I, J, V, csrrowptr, csrcolval, csrnzval, I, J, V)`. Note that they will be resized to satisfy the conditions above.

For the sake of efficiency, this method performs no argument checking beyond `1 <= I[k] <= m` and `1 <= J[k] <= n`. Use with care. Testing with `--check-bounds=yes` is wise.

This method runs in `O(m, n, length(I))` time. The HALFPERM algorithm described in F. Gustavson, "Two fast algorithms for sparse matrices: multiplication and permuted transposition," ACM TOMS 4(3), 250-269 (1978) inspired this method's use of a pair of counting sorts.
