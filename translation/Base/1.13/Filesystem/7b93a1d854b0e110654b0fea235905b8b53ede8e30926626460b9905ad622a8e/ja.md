```julia
iswritable(path::String)
```

指定された`path`へのアクセス権限で現在のユーザーによる書き込みが許可されている場合、`true`を返します。

!!! note
    ユーザーが`open`を呼び出す前に、この権限が変更される可能性があります。そのため、まず`iswritable`を呼び出すのではなく、`open`だけを呼び出し、失敗した場合はエラーを処理することをお勧めします。


!!! note
    現在、この関数はWindows上のファイルシステムACLを正しく照会できないため、誤った結果を返すことがあります。


!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。


関連項目: [`ispath`](@ref)、[`isexecutable`](@ref)、[`isreadable`](@ref)。
