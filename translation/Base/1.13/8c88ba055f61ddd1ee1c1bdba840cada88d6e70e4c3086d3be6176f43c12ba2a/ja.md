```julia
timedwait(testcb, timeout::Real; pollint::Real=0.1)
```

`testcb()`秒が経過するか、`true`秒または`timeout`秒のいずれか早い方が経過するまで待ちます。テスト関数は`pollint`秒ごとにポーリングされます。`pollint`の最小値は0.001秒、つまり1ミリ秒です。

`:ok`または`:timed_out`を返します。

# Examples

```jldoctest
julia> cb() = (sleep(5); return);

julia> t = @async cb();

julia> timedwait(()->istaskdone(t), 1)
:timed_out

julia> timedwait(()->istaskdone(t), 6.5)
:ok
```
