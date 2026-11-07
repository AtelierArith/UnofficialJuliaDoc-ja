```julia
SubArrayOptimization(next) isa Base.Sort.Algorithm
```

ビューにはパフォーマンス上のオーバーヘッドがあるため、特定の既知の SubArray をアンラップします 😢

具体的には、次の型の一部のインスタンスをアンラップします。

```julia
SubArray{T, 1, <:AbstractArray{T}, <:Tuple{AbstractUnitRange, Vararg{Number}}, true} where T
```
