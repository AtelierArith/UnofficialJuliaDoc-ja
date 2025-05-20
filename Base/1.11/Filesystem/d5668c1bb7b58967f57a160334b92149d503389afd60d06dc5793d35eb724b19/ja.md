```
chown(path::AbstractString, owner::Integer, group::Integer=-1)
```

`path`のオーナーおよび/またはグループを`owner`および/または`group`に変更します。`owner`または`group`に入力された値が`-1`の場合、対応するIDは変更されません。現在、整数の`owner`および`group`のみがサポートされています。`path`を返します。
