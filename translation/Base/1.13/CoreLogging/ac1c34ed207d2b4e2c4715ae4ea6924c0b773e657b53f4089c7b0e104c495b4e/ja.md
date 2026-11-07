```julia
shouldlog(logger, level, _module, group, id)
```

`true`を返します。これは、`logger`が`level`でメッセージを受け付けたときに生成され、`_module`、`group`、および一意のログ識別子`id`が含まれます。
