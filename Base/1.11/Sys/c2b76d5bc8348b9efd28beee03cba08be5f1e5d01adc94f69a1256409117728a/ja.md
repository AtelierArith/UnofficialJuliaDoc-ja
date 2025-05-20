```
Sys.username() -> String
```

現在のユーザーのユーザー名を返します。ユーザー名を特定できない場合や空の場合、この関数はエラーをスローします。

環境変数（例：`USER`）を介して上書き可能なユーザー名を取得するには、次のようにします。

```julia
user = get(Sys.username, ENV, "USER")
```

!!! compat "Julia 1.11"
    この関数は少なくともJulia 1.11が必要です。


関連情報は[`homedir`](@ref)を参照してください。
