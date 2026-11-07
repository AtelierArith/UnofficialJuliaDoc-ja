```julia
struct NotFound end
const NOT_FOUND = NotFound()
```

変数がまだ解析されていないことを表す、特殊なシングルトンです。特に、新しい `InferenceState` を作成するとき、すべての SSA 値の型は `NOT_FOUND` として初期化されます。これは抽象状態 `VarTable` を更新する `smerge` でのみ使用されるため、この値に対する束は定義しません。
