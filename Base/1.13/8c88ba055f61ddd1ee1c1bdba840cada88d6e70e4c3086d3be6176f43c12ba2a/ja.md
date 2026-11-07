```julia
timedwait(testcb, timeout::Real; pollint::Real=0.1)
```

`testcb()` が `true` または `timeout` 秒経過するまで待ちます。いずれか早い方が適用されます。テスト関数は `pollint` 秒ごとにポーリングされます。`pollint` の最小値は 0.001 秒、つまり 1 ミリ秒です。

`:ok` または `:timed_out` を返します。

# Examples

```jldoctest
julia> cb() = (sleep(5); return);

julia> t = @async cb();

julia> timedwait(()->istaskdone(t), 1)
:timed_out

julia> timedwait(()->istaskdone(t), 6.5)
:ok
```
