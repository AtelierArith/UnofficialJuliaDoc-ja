```julia
copy_adjoint!(B::AbstractVecOrMat, ir_dest::AbstractRange{Int}, jr_dest::AbstractRange{Int},
                A::AbstractVecOrMat, ir_src::AbstractRange{Int}, jr_src::AbstractRange{Int}) -> B
```

行列 `A` の要素を、次のように隣接させて `B` に効率よくコピーします。

```julia
B[ir_dest, jr_dest] = adjoint(A)[jr_src, ir_src]
```

要素 `B[ir_dest, jr_dest]` は上書きされます。また、インデックス範囲のパラメーターは `length(ir_dest) == length(jr_src)` および `length(jr_dest) == length(ir_src)` を満たす必要があります。
