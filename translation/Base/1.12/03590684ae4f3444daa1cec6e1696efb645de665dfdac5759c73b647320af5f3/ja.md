```julia
istaskstarted(t::Task) -> Bool
```

タスクが実行を開始したかどうかを判断します。

# 例

```jldoctest
julia> a3() = sum(i for i in 1:1000);

julia> b = Task(a3);

julia> istaskstarted(b)
false
```
