```
@task
```

式を[`Task`](@ref)でラップし、実行せずに[`Task`](@ref)を返します。これはタスクを作成するだけで、実行はしません。

!!! warning
    デフォルトでは、タスクにはスティッキービットがtrue `t.sticky`に設定されます。これは[`@async`](@ref)の歴史的なデフォルトをモデル化しています。スティッキーなタスクは、最初にスケジュールされたワーカースレッドでのみ実行でき、スケジュールされると、そこからスケジュールされたタスクもスティッキーになります。[`Threads.@spawn`](@ref)の動作を得るには、スティッキービットを手動で`false`に設定してください。


# 例

```jldoctest
julia> a1() = sum(i for i in 1:1000);

julia> b = @task a1();

julia> istaskstarted(b)
false

julia> schedule(b);

julia> yield();

julia> istaskdone(b)
true
```
