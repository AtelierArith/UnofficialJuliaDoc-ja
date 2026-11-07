```julia
isexecutable(path::String)
```

指定された`path`に実行権限がある場合は、`true`を返します。

!!! note
    ユーザーが`path`を実行する前に、この権限が変更される可能性があります。そのため、先に`isexecutable`を呼び出すよりも、ファイルを実行し、失敗した場合はエラーを処理することをおすすめします。


!!! note
    Julia 1.6より前のバージョンでは、WindowsのファイルシステムACLを正しく調べられず、どのファイルに対しても`true`を返していました。Julia 1.6以降では、ファイルに実行可能属性が設定されているかどうかを正しく判定します。


[`ispath`](@ref)、[`isreadable`](@ref)、[`iswritable`](@ref)も参照してください。
