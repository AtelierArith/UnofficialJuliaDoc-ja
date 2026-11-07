```julia
include_dependency(path::AbstractString; track_content::Bool=true)
```

モジュール内で、`path`（相対パスまたは絶対パス）で指定したファイル、ディレクトリ、またはシンボリックリンクがプリコンパイル時の依存関係であることを宣言します。つまり、`track_content=true` の場合、`path` の内容が変更されると、モジュールを再コンパイルする必要があります（`path` がディレクトリの場合、その内容とは `join(readdir(path))` を指します）。`track_content=false` の場合は、`path` の更新日時 `mtime` が変更されると、再コンパイルが実行されます。

これは、モジュールが [`include`](@ref) 経由では使用されないパスに依存している場合にのみ必要です。コンパイル以外では効果はありません。

!!! compat "Julia 1.11"
    キーワード引数 `track_content` を使用するには、Julia 1.11 以降が必要です。`path` が読み取り可能でない場合、エラーがスローされるようになりました。

