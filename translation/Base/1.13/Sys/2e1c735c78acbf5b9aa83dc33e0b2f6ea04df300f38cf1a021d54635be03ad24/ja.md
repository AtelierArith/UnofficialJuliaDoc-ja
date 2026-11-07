```julia
Sys.username()::String
```

現在のユーザー名を返します。ユーザー名を特定できない場合、または空の場合、この関数はエラーをスローします。

環境変数で上書きできるユーザー名を取得するには、たとえば `USER` を使用してください。

```julia
user = get(Sys.username, ENV, "USER")
```

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`homedir`](@ref)。
