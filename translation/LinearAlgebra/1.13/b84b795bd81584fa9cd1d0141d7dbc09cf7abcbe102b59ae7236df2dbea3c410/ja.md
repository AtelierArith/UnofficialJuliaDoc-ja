```julia
copyto!(B::AbstractMatrix, ir_dest::AbstractUnitRange, jr_dest::AbstractUnitRange,
        tM::AbstractChar,
        M::AbstractVecOrMat, ir_src::AbstractUnitRange, jr_src::AbstractUnitRange) -> B
```

文字パラメーター `tM` に応じて、行列 `M` の要素を `B` に効率よくコピーします。

|  `tM` | コピー先                  | コピー元                           |
| -----:|:--------------------- |:------------------------------ |
| `'N'` | `B[ir_dest, jr_dest]` | `M[ir_src, jr_src]`            |
| `'T'` | `B[ir_dest, jr_dest]` | `transpose(M)[ir_src, jr_src]` |
| `'C'` | `B[ir_dest, jr_dest]` | `adjoint(M)[ir_src, jr_src]`   |

`B[ir_dest, jr_dest]` の要素は上書きされます。また、インデックス範囲のパラメーターは `length(ir_dest) == length(ir_src)` および `length(jr_dest) == length(jr_src)` を満たす必要があります。

[`copy_transpose!`](@ref) および [`copy_adjoint!`](@ref) も参照してください。
