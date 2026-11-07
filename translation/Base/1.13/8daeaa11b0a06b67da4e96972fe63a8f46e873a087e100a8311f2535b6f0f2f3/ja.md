```julia
find_terminfo_file(term::String)
```

`term` の terminfo ファイルを検索し、見つからなかった場合は `nothing` を返します。

検索ポリシーについては、`terminfo(5)`「コンパイル済み記述の取得」を参照してください。Julia には terminfo データベースがデフォルトで含まれており、`@TERMINFO_DIRS@` の最初のエントリとして扱われます。
