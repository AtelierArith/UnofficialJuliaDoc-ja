```julia
cp(src::AbstractString, dst::AbstractString; force::Bool=false, follow_symlinks::Bool=false)
```

`src` から `dst` に、ファイル、リンク、またはディレクトリをコピーします。`force=true` は、既存の `dst` を最初に削除します。

`follow_symlinks=false` がシンボリックリンクであり、`src` もシンボリックリンクの場合、`dst` はシンボリックリンクとして作成されます。`follow_symlinks=true` がシンボリックリンクであり、`src` もシンボリックリンクの場合、`dst` は、`src` が指すファイルまたはディレクトリのコピーになります。`dst` を返します。

!!! note
    `cp` 関数は、Unix コマンドの `cp` とは異なります。`cp` 関数は、`dst` がファイルであると常に仮定して動作します。一方、このコマンドは、`dst` がディレクトリかファイルかによって動作が異なります。`dst` がディレクトリの場合に `force=true` を使用すると、`dst` ディレクトリ内のすべての内容が失われ、代わりに `dst` は `src` の内容を持つファイルになります。

