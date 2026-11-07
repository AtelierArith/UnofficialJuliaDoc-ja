```julia
union_split(f, x, ts::Tuple{Vararg{Val}}, args...)
```

`ts`で指定されたすべての型に対してユニオン分割を行う`f(x, args...)`の呼び出し

`union_split(f, x, (Val{T1}(), Val{T2}()), y, z)`は次と同等です。

```julia
if x isa T1
    f(x, y, z)
elseif x isa T2
    f(x, y, z)
else
    f(x, y, z)
end
```
