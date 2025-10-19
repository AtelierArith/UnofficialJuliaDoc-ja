```julia
isreadable(path::String)
```

与えられた `path` のアクセス権が現在のユーザーによる読み取りを許可している場合は `true` を返します。

!!! note
    この権限はユーザーが `open` を呼び出す前に変更される可能性があるため、最初に `isreadable` を呼び出すのではなく、単に `open` を呼び出して、失敗した場合にエラーを処理することをお勧めします。


!!! note
    現在、この関数はWindows上のファイルシステムACLを正しく調査しないため、誤った結果を返す可能性があります。


!!! compat "Julia 1.11"
    この関数は少なくともJulia 1.11を必要とします。


関連情報として [`ispath`](@ref), [`isexecutable`](@ref), [`iswritable`](@ref) を参照してください。
