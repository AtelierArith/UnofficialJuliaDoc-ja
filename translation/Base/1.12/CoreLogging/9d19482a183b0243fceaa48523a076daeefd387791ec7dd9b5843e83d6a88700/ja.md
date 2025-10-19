```julia
shouldlog(logger, level, _module, group, id)
```

`logger`が`level`で生成されたメッセージを受け入れる場合、`_module`、`group`、およびユニークなログ識別子`id`に対して`true`を返します。
