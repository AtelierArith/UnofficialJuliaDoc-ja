```julia
create(
    [ predicate, ] dir, [ tarball ];
    [ skeleton, ] [ portable = false ]
) -> tarball

    predicate :: String --> Bool
    dir       :: AbstractString
    tarball   :: Union{AbstractString, AbstractCmd, IO}
    skeleton  :: Union{AbstractString, AbstractCmd, IO}
    portable  :: Bool
```

ディレクトリ `dir` の tar アーカイブ（「tarball」）を作成します。作成したアーカイブはパス `tarball` に書き込まれます。パスが指定されていない場合は、一時パスが作成され、関数呼び出しから返されます。`tarball` が IO オブジェクトの場合は、代わりにそのハンドルへ tarball の内容を書き込みます（ハンドルは開いたままです）。

`predicate` 関数が渡された場合、`dir` を再帰的に検索する際に見つかった各システムパスに対してその関数を呼び出します。`path` は、`predicate(path)` が true の場合にのみ tarball に含まれます。ディレクトリに対して `predicate(path)` が false を返すと、そのディレクトリは完全に除外され、その配下の内容もアーカイブに含まれません。

`skeleton` キーワードを渡すと、指定したファイルまたは IO ハンドルを「スケルトン」として使用し、tarball を生成します。`extract` コマンドに `skeleton` キーワードを渡すと、スケルトンファイルを作成できます。そのスケルトンファイルを指定して `create` を呼び出し、展開したファイルに変更がなければ、同一の tarball が再作成されます。`skeleton` と `predicate` の引数は同時に使用できません。

`portable` フラグが true の場合、パス名が Windows で有効かどうかを検証します。これにより、パス名に使用できない文字が含まれていたり、予約済みの名前が使われたりすることを防ぎます。詳細は https://stackoverflow.com/a/31976060/659248 を参照してください。
