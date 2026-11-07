```julia
iterate(iter [, state])::Union{Nothing, Tuple{Any, Any}}
```

イテレーターを進めて次の要素を取得します。要素が残っていない場合は、`nothing`を返します。そうでない場合は、次の要素と新しい反復状態からなる2要素のタプルを返します。
