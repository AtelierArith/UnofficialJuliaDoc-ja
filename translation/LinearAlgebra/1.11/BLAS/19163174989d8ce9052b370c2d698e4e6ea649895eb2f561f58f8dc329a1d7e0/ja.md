```
set_num_threads(n::Integer)
set_num_threads(::Nothing)
```

BLASライブラリが使用するスレッドの数を`n::Integer`に設定します。

また、`nothing`を受け入れます。この場合、juliaはデフォルトのスレッド数を推測しようとします。`nothing`を渡すことは推奨されず、主に歴史的な理由から存在します。
