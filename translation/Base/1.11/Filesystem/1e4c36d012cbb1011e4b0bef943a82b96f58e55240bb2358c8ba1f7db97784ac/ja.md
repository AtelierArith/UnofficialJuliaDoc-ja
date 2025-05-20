```
relpath(path::AbstractString, startpath::AbstractString = ".") -> String
```

`path` から現在のディレクトリまたはオプションの開始ディレクトリからの相対ファイルパスを返します。これはパス計算です：ファイルシステムにアクセスして `path` または `startpath` の存在や性質を確認することはありません。

Windows では、ドライブレターを除くパスのすべての部分に対して大文字と小文字の区別が適用されます。`path` と `startpath` が異なるドライブを指している場合、`path` の絶対パスが返されます。
