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

`old_tarball`を`create`が生成する標準形式に書き換えつつ、`extract`がエラーを引き起こす原因となるものが含まれていないことを確認します。これは機能的には次のことと同等です。

```julia
Tar.create(Tar.extract(predicate, old_tarball), new_tarball)
```

ただし、ディスクに何も抽出せず、代わりに`seek`関数を使用して古いtarballのデータをナビゲートします。`new_tarball`引数が渡されない場合、新しいtarballは一時ファイルに書き込まれ、そのパスが返されます。

`predicate`関数が渡されると、`old_tarball`を抽出している間に遭遇する各`Header`オブジェクトに対して呼び出され、`predicate(hdr)`がtrueでない限りエントリはスキップされます。これにより、アーカイブの一部のみを選択的に書き換えたり、`extract`がエラーをスローする原因となるエントリをスキップしたり、書き換えプロセス中に遭遇したコンテンツを記録したりすることができます。

`predicate`関数に渡される前に、`Header`オブジェクトはtarballの生のヘッダーから若干修正されます：`path`フィールドは`.`エントリを削除し、連続するスラッシュを単一のスラッシュに置き換えるように正規化されます。エントリが`:hardlink`タイプの場合、リンクターゲットパスも同様に正規化され、ターゲットエントリのパスと一致するようになります；サイズフィールドはターゲットパスのサイズに設定されます（これはすでに見たファイルでなければなりません）。

`portable`フラグがtrueの場合、パス名はWindows上での有効性がチェックされ、不正な文字を含まないことや予約された名前を持たないことが保証されます。詳細についてはhttps://stackoverflow.com/a/31976060/659248を参照してください。
