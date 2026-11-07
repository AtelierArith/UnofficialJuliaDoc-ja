```julia
AsyncCondition(callback::Function)
```

指定された`callback`関数を呼び出す非同期条件を作成します。`callback`には、非同期条件オブジェクト自体が引数として1つ渡されます。
