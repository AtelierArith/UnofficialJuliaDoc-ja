```
iswritable(path::String)
```

指定された `path` のアクセス権が現在のユーザーによる書き込みを許可している場合は `true` を返します。

!!! note
    この権限はユーザーが `open` を呼び出す前に変更される可能性があるため、最初に `iswritable` を呼び出すのではなく、単に `open` を呼び出し、失敗した場合にエラーを処理することをお勧めします。


!!! note
    現在、この関数はWindows上のファイルシステムACLを正しく調査しないため、誤った結果を返す可能性があります。


!!! compat "Julia 1.11"
    この関数は少なくともJulia 1.11が必要です。


関連項目として [`ispath`](@ref)、[`isexecutable`](@ref)、[`isreadable`](@ref) を参照してください。
