```julia
copy_transpose!(B::AbstractMatrix, ir_dest::AbstractUnitRange, jr_dest::AbstractUnitRange,
                tM::AbstractChar,
                M::AbstractVecOrMat, ir_src::AbstractUnitRange, jr_src::AbstractUnitRange) -> B
```

行列 `M` の要素を、文字パラメータ `tM` に基づいて `B` に効率的にコピーします。

|  `tM` | 宛先                    | ソース                            |
| -----:|:--------------------- |:------------------------------ |
| `'N'` | `B[ir_dest, jr_dest]` | `transpose(M)[jr_src, ir_src]` |
| `'T'` | `B[ir_dest, jr_dest]` | `M[jr_src, ir_src]`            |
| `'C'` | `B[ir_dest, jr_dest]` | `conj(M)[jr_src, ir_src]`      |

要素 `B[ir_dest, jr_dest]` は上書きされます。さらに、インデックス範囲パラメータは `length(ir_dest) == length(jr_src)` および `length(jr_dest) == length(ir_src)` を満たす必要があります。

また、[`copyto!`](@ref) および [`copy_adjoint!`](@ref) も参照してください。
