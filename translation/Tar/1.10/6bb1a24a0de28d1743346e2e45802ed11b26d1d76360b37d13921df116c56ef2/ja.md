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

ディレクトリ `dir` の tar アーカイブ（"tarball"）を作成します。結果のアーカイブは、`tarball` のパスに書き込まれるか、パスが指定されていない場合は、一時的なパスが作成され、関数呼び出しによって返されます。`tarball` が IO オブジェクトの場合、tarball の内容はそのハンドルに書き込まれます（ハンドルはオープンのままです）。

`predicate` 関数が渡されると、`dir` を再帰的に検索する際に遭遇する各システムパスに対して呼び出され、`predicate(path)` が true の場合のみ `path` が tarball に含まれます。もし `predicate(path)` がディレクトリに対して false を返すと、そのディレクトリは完全に除外されます：そのディレクトリの下にあるものはアーカイブに含まれません。

`skeleton` キーワードが渡されると、指定されたファイルまたは IO ハンドルが tarball を生成するための「スケルトン」として使用されます。`extract` コマンドに `skeleton` キーワードを渡すことでスケルトンファイルを作成します。もしそのスケルトンファイルで `create` が呼び出され、抽出されたファイルが変更されていなければ、同一の tarball が再作成されます。`skeleton` と `predicate` 引数は一緒に使用することはできません。

`portable` フラグが true の場合、パス名が Windows での有効性をチェックされ、不正な文字を含まないことや予約された名前を持たないことが保証されます。詳細については https://stackoverflow.com/a/31976060/659248 を参照してください。
