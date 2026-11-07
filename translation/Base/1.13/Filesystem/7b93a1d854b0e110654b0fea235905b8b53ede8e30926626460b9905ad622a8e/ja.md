```julia
iswritable(path::String)
```

指定された`path`のアクセス権限で現在のユーザーによる書き込みが許可されている場合、`true`を返します。

!!! note
    ユーザーが`open`を呼び出す前に、この権限が変更される可能性があります。そのため、先に`iswritable`を呼び出すのではなく、`open`だけを呼び出し、失敗した場合はエラーを処理することを推奨します。


!!! note
    現在、この関数はWindows上のファイルシステムACLを正しく調べられないため、誤った結果を返すことがあります。


!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。


関連項目: [`ispath`](@ref)、[`isexecutable`](@ref)、[`isreadable`](@ref)。
