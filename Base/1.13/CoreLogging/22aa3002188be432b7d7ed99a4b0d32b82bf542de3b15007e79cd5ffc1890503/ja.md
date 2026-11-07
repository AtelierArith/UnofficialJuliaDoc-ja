```julia
handle_message(logger, level, message, _module, group, id, file, line; key1=val1, ...)
```

`level`で、`logger`にメッセージを記録します。メッセージが生成された論理上の位置は、モジュール`_module`と`group`で示されます。ソース上の位置は、`file`と`line`で示されます。`id`は任意の一意な値（通常は[`Symbol`](@ref)）で、フィルタリング時にログ文を識別するキーとして使用します。
