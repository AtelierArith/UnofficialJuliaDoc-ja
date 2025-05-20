```
iterate(iter [, state]) -> Union{Nothing, Tuple{Any, Any}}
```

イテレータを進めて次の要素を取得します。要素が残っていない場合は、`nothing`が返されるべきです。そうでなければ、次の要素と新しいイテレーション状態の2タプルが返されるべきです。
