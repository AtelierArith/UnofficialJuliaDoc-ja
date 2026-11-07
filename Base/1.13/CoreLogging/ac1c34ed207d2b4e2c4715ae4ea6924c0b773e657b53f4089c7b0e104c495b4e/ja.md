```julia
shouldlog(logger, level, _module, group, id)
```

`logger` が `_module` 用に生成されたメッセージを `level` で受け付けたとき、`group` と一意のログ識別子 `id` を含む `true` を返します。
