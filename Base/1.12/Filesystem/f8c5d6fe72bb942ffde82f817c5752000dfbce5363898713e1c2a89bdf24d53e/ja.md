```julia
isexecutable(path::String)
```

指定された `path` に実行権限がある場合は `true` を返します。

!!! note
    この権限はユーザーが `path` を実行する前に変更される可能性があるため、最初に `isexecutable` を呼び出すのではなく、ファイルを実行して失敗した場合にエラーを処理することをお勧めします。


!!! note
    Julia 1.6 より前は、Windows のファイルシステム ACL を正しく調査していなかったため、任意のファイルに対して `true` を返していました。Julia 1.6 以降は、ファイルが実行可能としてマークされているかどうかを正しく判断します。


関連情報として [`ispath`](@ref)、[`isreadable`](@ref)、[`iswritable`](@ref) を参照してください。
