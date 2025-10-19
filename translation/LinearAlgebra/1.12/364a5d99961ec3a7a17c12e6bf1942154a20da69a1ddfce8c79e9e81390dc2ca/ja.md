```julia
copyto!(B::AbstractMatrix, ir_dest::AbstractUnitRange, jr_dest::AbstractUnitRange,
        tM::AbstractChar,
        M::AbstractVecOrMat, ir_src::AbstractUnitRange, jr_src::AbstractUnitRange) -> B
```

行列 `M` の要素を、文字パラメータ `tM` に基づいて `B` に効率的にコピーします。以下のように：

|  `tM` | 宛先                    | ソース                            |
| -----:|:--------------------- |:------------------------------ |
| `'N'` | `B[ir_dest, jr_dest]` | `M[ir_src, jr_src]`            |
| `'T'` | `B[ir_dest, jr_dest]` | `transpose(M)[ir_src, jr_src]` |
| `'C'` | `B[ir_dest, jr_dest]` | `adjoint(M)[ir_src, jr_src]`   |

要素 `B[ir_dest, jr_dest]` は上書きされます。さらに、インデックス範囲パラメータは `length(ir_dest) == length(ir_src)` および `length(jr_dest) == length(jr_src)` を満たす必要があります。

他にも [`copy_transpose!`](@ref) と [`copy_adjoint!`](@ref) を参照してください。
