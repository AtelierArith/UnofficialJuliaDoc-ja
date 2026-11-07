```julia
copy_transpose!(B::AbstractVecOrMat, ir_dest::AbstractRange{Int}, jr_dest::AbstractRange{Int},
                A::AbstractVecOrMat, ir_src::AbstractRange{Int}, jr_src::AbstractRange{Int}) -> B
```

行列 `A` の要素を転置しながら `B` に効率よくコピーするには、次のようにします。

```julia
B[ir_dest, jr_dest] = transpose(A)[jr_src, ir_src]
```

`B[ir_dest, jr_dest]` の要素は上書きされます。また、インデックス範囲のパラメーターは `length(ir_dest) == length(jr_src)` および `length(jr_dest) == length(ir_src)` を満たす必要があります。
