```julia
Module
```

`Module`は、独立したグローバル変数のワークスペースです。詳しくは、[`module`](@ref)および[manual section about modules](@ref modules)を参照してください。

```julia
Module(name::Symbol=:anonymous, std_imports=true, default_names=true)
```

指定した名前のモジュールを返します。`baremodule`は`Module(:ModuleName, false)`に対応します。

名前を一切含まない空のモジュールは、`Module(:ModuleName, false, false)`で作成できます。このモジュールは`Base`も`Core`もインポートせず、自身への参照も含みません。
