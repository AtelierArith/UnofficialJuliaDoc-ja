Helper method for `halfperm!`. Computes `transpose(A[:,q])`'s column pointers, storing them shifted one position forward in `getcolptr(X)`; `_distributevals_halfperm!` fixes this shift.
