```
include_dependency(path::AbstractString; track_content::Bool=true)
```

モジュール内で、`path`（相対または絶対）の指定されたファイル、ディレクトリ、またはシンボリックリンクがプリコンパイルの依存関係であることを宣言します。つまり、`track_content=true`の場合、`path`の内容が変更されるとモジュールは再コンパイルが必要になります（`path`がディレクトリの場合、内容は`join(readdir(path))`に等しいです）。`track_content=false`の場合、`path`の修正時間`mtime`が変更されると再コンパイルがトリガーされます。

これは、モジュールが[`include`](@ref)を介して使用されていないパスに依存している場合にのみ必要です。コンパイルの外では効果がありません。

!!! compat "Julia 1.11"
    キーワード引数`track_content`は少なくともJulia 1.11が必要です。`path`が読み取り可能でない場合はエラーがスローされます。

