```julia
cp(src::AbstractString, dst::AbstractString; force::Bool=false, follow_symlinks::Bool=false)
```

`src`から`dst`にファイル、リンク、またはディレクトリをコピーします。`force=true`の場合、最初に既存の`dst`を削除します。

`follow_symlinks=false`の場合、`src`がシンボリックリンクであれば、`dst`はシンボリックリンクとして作成されます。`follow_symlinks=true`で`src`がシンボリックリンクの場合、`dst`は`src`が指すファイルまたはディレクトリのコピーになります。`dst`を返します。

!!! note
    `cp`関数は`cp` Unixコマンドとは異なります。`cp`関数は常に`dst`がファイルであると仮定して動作しますが、コマンドは`dst`がディレクトリかファイルかによって異なる動作をします。`dst`がディレクトリのときに`force=true`を使用すると、`dst`ディレクトリ内のすべての内容が失われ、`dst`は`src`の内容を持つファイルになります。

