```julia
timedwait(testcb, timeout::Real; pollint::Real=0.1)
```

`testcb()` が `true` を返すか、`timeout` 秒が経過するまで待機します。どちらか早い方が優先されます。テスト関数は毎 `pollint` 秒ごとにポーリングされます。`pollint` の最小値は 0.001 秒、すなわち 1 ミリ秒です。

`:ok` または `:timed_out` を返します。

# 例

```jldoctest
julia> cb() = (sleep(5); return);

julia> t = @async cb();

julia> timedwait(()->istaskdone(t), 1)
:timed_out

julia> timedwait(()->istaskdone(t), 6.5)
:ok
```
