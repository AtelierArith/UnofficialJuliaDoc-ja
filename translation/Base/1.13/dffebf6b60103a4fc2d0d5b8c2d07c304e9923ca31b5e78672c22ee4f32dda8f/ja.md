```julia
close(t::Union{Timer, AsyncCondition})
```

オブジェクト `t` を閉じ、非アクティブとしてマークします。タイマーまたは条件が非アクティブになると、新しいイベントは発生しません。

関連項目: [`isopen`](@ref)
