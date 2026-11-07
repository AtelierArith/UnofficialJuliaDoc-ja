```julia
@task
```

式を実行せずに[`Task`](@ref)でラップし、[`Task`](@ref)を返します。これはタスクを作成するだけで、実行はしません。

!!! warning
    デフォルトでは、タスクのstickyビットはtrue `t.sticky`に設定されます。これは、[`@async`](@ref)における従来のデフォルト動作を再現したものです。stickyタスクは、最初にスケジュールされたワーカースレッドでのみ実行できます。また、スケジュールされると、そのタスクをスケジュールしたタスクもstickyになります。[`Threads.@spawn`](@ref)の動作にするには、stickyビットを手動で`false`に設定してください。


# Examples

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
