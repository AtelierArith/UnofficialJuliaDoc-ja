```
copy_transpose!(B::AbstractVecOrMat, ir_dest::AbstractRange{Int}, jr_dest::AbstractRange{Int},
                A::AbstractVecOrMat, ir_src::AbstractRange{Int}, jr_src::AbstractRange{Int}) -> B
```

Efficiently copy elements of matrix `A` to `B` with transposition as follows:

```
B[ir_dest, jr_dest] = transpose(A)[jr_src, ir_src]
```

The elements `B[ir_dest, jr_dest]` are overwritten. Furthermore, the index range parameters must satisfy `length(ir_dest) == length(jr_src)` and `length(jr_dest) == length(ir_src)`.
