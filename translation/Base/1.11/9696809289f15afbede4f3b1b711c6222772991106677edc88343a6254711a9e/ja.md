```
load_path()
```

プロジェクトやパッケージを検索するために[`LOAD_PATH`](@ref)の完全に展開された値を返します。

!!! note
    `load_path`はキャッシュされた値への参照を返す可能性があるため、返されたベクターを変更することは安全ではありません。

