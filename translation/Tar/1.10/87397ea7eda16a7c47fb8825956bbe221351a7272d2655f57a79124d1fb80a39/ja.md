```julia
rewrite(
    [ predicate, ] old_tarball, [ new_tarball ];
    [ portable = false, ]
) -> new_tarball

    predicate   :: Header --> Bool
    old_tarball :: Union{AbstractString, AbstractCmd, IO}
    new_tarball :: Union{AbstractString, AbstractCmd, IO}
    portable    :: Bool
```

`old_tarball` を `create` が生成する標準形式に書き換えます。同時に、`extract` でエラーを引き起こす内容が含まれていないことも確認します。これは機能的には次の操作と同等です。

```julia
Tar.create(Tar.extract(predicate, old_tarball), new_tarball)
```

ただし、ディスクへの展開は一切行わず、代わりに `seek` 関数を使って元の tarball のデータをたどります。`new_tarball` 引数を渡さない場合、新しい tarball は一時ファイルに書き込まれ、そのパスが返されます。

`predicate` 関数を渡すと、`old_tarball` の展開中に見つかった各 `Header` オブジェクトに対してその関数が呼び出され、`predicate(hdr)` が true でない限り、そのエントリはスキップされます。これにより、アーカイブの一部だけを選択的に書き換えたり、`extract` でエラーを引き起こすエントリをスキップしたり、書き換え処理中に見つかった内容を記録したりできます。

述語関数に渡される前に、`Header` オブジェクトには tarball 内の生のヘッダーからいくつかの変更が加えられます。`path` フィールドは、`.` エントリを削除し、連続する複数のスラッシュを単一のスラッシュに置き換えることで正規化されます。エントリの種類が `:hardlink` の場合、リンク先のパスも同様に正規化され、リンク先エントリのパスと一致するようになります。また、サイズフィールドは、リンク先のパスにあるファイルのサイズに設定されます。このファイルは、すでに処理済みでなければなりません。

`portable` フラグが true の場合、パス名が Windows で有効かどうかを検証し、使用できない文字が含まれていないことや、予約名が使われていないことを確認します。詳細は https://stackoverflow.com/a/31976060/659248 を参照してください。
