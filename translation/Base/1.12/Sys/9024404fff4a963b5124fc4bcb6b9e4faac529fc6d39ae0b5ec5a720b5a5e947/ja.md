```julia
Sys.username() -> String
```

現在のユーザーのユーザー名を返します。ユーザー名を特定できない場合や空の場合、この関数はエラーをスローします。

環境変数を介して上書き可能なユーザー名を取得するには、例えば `USER` を使用して、次のように考慮してください。

```julia
user = get(Sys.username, ENV, "USER")
```

!!! compat "Julia 1.11"
    この関数は少なくとも Julia 1.11 を必要とします。


関連情報は [`homedir`](@ref) を参照してください。
