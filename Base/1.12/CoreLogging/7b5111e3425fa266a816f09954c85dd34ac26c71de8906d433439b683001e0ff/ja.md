```julia
handle_message(logger, level, message, _module, group, id, file, line; key1=val1, ...)
```

`logger`に`level`でメッセージをログします。メッセージが生成された論理的な場所はモジュール`_module`と`group`によって示され、ソースの場所は`file`と`line`によって示されます。`id`はフィルタリング時にログステートメントを識別するためのキーとして使用される任意の一意の値（通常は[`Symbol`](@ref)）です。
