```julia
copy_transpose!(B::AbstractMatrix, ir_dest::AbstractUnitRange, jr_dest::AbstractUnitRange,
                tM::AbstractChar,
                M::AbstractVecOrMat, ir_src::AbstractUnitRange, jr_src::AbstractUnitRange) -> B
```

文字パラメーター `tM` に応じて、行列 `M` の要素を `B` に効率よくコピーします。

|  `tM` | コピー先                  | コピー元                           |
| -----:|:--------------------- |:------------------------------ |
| `'N'` | `B[ir_dest, jr_dest]` | `transpose(M)[jr_src, ir_src]` |
| `'T'` | `B[ir_dest, jr_dest]` | `M[jr_src, ir_src]`            |
| `'C'` | `B[ir_dest, jr_dest]` | `conj(M)[jr_src, ir_src]`      |

`B[ir_dest, jr_dest]` の要素は上書きされます。また、インデックス範囲のパラメーターは `length(ir_dest) == length(jr_src)` および `length(jr_dest) == length(ir_src)` を満たす必要があります。

[`copyto!`](@ref) および [`copy_adjoint!`](@ref) も参照してください。
