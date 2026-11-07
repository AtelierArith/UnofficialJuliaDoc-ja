```julia
union_split(f, x, ts::Tuple{Vararg{Val}}, args...)
```

call `f(x, args...)`, union-splitting on all the types specified by `ts`

`union_split(f, x, (Val{T1}(), Val{T2}()), y, z)` is equivalent to

```julia
if x isa T1
    f(x, y, z)
elseif x isa T2
    f(x, y, z)
else
    f(x, y, z)
end
```
