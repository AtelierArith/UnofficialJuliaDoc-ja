```
copyto!(B::AbstractMatrix, ir_dest::AbstractUnitRange, jr_dest::AbstractUnitRange,
        tM::AbstractChar,
        M::AbstractVecOrMat, ir_src::AbstractUnitRange, jr_src::AbstractUnitRange) -> B
```

Efficiently copy elements of matrix `M` to `B` conditioned on the character parameter `tM` as follows:

|  `tM` | Destination           | Source                         |
| -----:|:--------------------- |:------------------------------ |
| `'N'` | `B[ir_dest, jr_dest]` | `M[ir_src, jr_src]`            |
| `'T'` | `B[ir_dest, jr_dest]` | `transpose(M)[ir_src, jr_src]` |
| `'C'` | `B[ir_dest, jr_dest]` | `adjoint(M)[ir_src, jr_src]`   |

The elements `B[ir_dest, jr_dest]` are overwritten. Furthermore, the index range parameters must satisfy `length(ir_dest) == length(ir_src)` and `length(jr_dest) == length(jr_src)`.

See also [`copy_transpose!`](@ref) and [`copy_adjoint!`](@ref).
