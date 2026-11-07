```julia
addenv(command::Cmd, env...; inherit::Bool = true)
```

新しい環境マッピングを指定された[`Cmd`](@ref)オブジェクトにマージし、新しい`Cmd`オブジェクトを返します。キーが重複する場合は、新しい値で置き換えられます。`command`に環境値が設定されていない場合、`inherit`が`true`であれば、`addenv()`の呼び出し時点の現在の環境を引き継ぎます。値が`nothing`のキーは、環境から削除されます。

関連項目: [`Cmd`](@ref)、[`setenv`](@ref)、[`ENV`](@ref)。

!!! compat "Julia 1.6"
    この関数を使用するには、Julia 1.6以降が必要です。

