```
モジュール
```

`Module`は別のグローバル変数ワークスペースです。詳細については、[`module`](@ref)および[モジュールに関するマニュアルセクション](@ref modules)を参照してください。

```
Module(name::Symbol=:anonymous, std_imports=true, default_names=true)
```

指定された名前のモジュールを返します。`baremodule`は`Module(:ModuleName, false)`に対応します。

名前を全く含まない空のモジュールは、`Module(:ModuleName, false, false)`を使用して作成できます。このモジュールは`Base`や`Core`をインポートせず、自身への参照を含みません。
