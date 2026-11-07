```julia
istaskstarted(t::Task)::Bool
```

タスクの実行が開始されたかどうかを判定します。

# Examples

```jldoctest
julia> a3() = sum(i for i in 1:1000);

julia> b = Task(a3);

julia> istaskstarted(b)
false
```
