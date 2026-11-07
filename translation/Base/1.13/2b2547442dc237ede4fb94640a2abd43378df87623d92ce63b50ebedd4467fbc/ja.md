```julia
fbody = bodyfunction(basemethod::Method)
```

「body function」（メソッド本体を含む関数。省略されたキーワード引数すべてにデフォルト値が割り当てられた後に呼び出される）というキーワードを探してください。`basemethod`は、[`which`](@ref)または[`methods`](@ref)から取得できるメソッドです。
