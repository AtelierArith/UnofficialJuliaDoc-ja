```
istaskdone(t::Task) -> Bool
```

タスクが終了したかどうかを判断します。

# 例

```jldoctest
julia> a2() = sum(i for i in 1:1000);

julia> b = Task(a2);

julia> istaskdone(b)
false

julia> schedule(b);

julia> yield();

julia> istaskdone(b)
true
```
