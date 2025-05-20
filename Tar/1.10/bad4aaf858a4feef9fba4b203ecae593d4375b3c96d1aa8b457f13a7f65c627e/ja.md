```
extract(
    [ predicate, ] tarball, [ dir ];
    [ skeleton = <none>, ]
    [ copy_symlinks = <auto>, ]
    [ set_permissions = true, ]
) -> dir

    predicate       :: Header --> Bool
    tarball         :: Union{AbstractString, AbstractCmd, IO}
    dir             :: AbstractString
    skeleton        :: Union{AbstractString, AbstractCmd, IO}
    copy_symlinks   :: Bool
    set_permissions :: Bool
```

指定されたパス `tarball` にある tar アーカイブ（"tarball"）をディレクトリ `dir` に抽出します。`tarball` がパスではなく IO オブジェクトの場合、アーカイブの内容はその IO ストリームから読み取られます。アーカイブは `dir` に抽出され、`dir` は既存の空のディレクトリであるか、新しいディレクトリとして作成できる存在しないパスでなければなりません。`dir` が指定されていない場合、アーカイブは一時ディレクトリに抽出され、そのディレクトリは `extract` によって返されます。

`predicate` 関数が渡されると、`tarball` を抽出している間に遭遇する各 `Header` オブジェクトに対して呼び出され、`predicate(hdr)` が true の場合のみエントリが抽出されます。これを使用してアーカイブの一部のみを選択的に抽出したり、`extract` がエラーをスローするエントリをスキップしたり、抽出プロセス中に何が抽出されたかを記録することができます。

`Header` オブジェクトは、tarball の生のヘッダーから多少修正されてから predicate 関数に渡されます：`path` フィールドは `.` エントリを削除し、複数の連続スラッシュを単一のスラッシュに置き換えるように正規化されます。エントリが `:hardlink` タイプの場合、リンクターゲットパスも同様に正規化され、ターゲットエントリのパスと一致するようになります。サイズフィールドはターゲットパスのサイズに設定されます（これはすでに見たファイルでなければなりません）。

`skeleton` キーワードが渡されると、抽出された tarball の「スケルトン」が指定されたファイルまたは IO ハンドルに書き込まれます。このスケルトンファイルは、`create` 関数に `skeleton` キーワードを渡すことで同一の tarball を再作成するために使用できます。`skeleton` と `predicate` 引数は一緒に使用することはできません。

`copy_symlinks` が `true` の場合、シンボリックリンクをそのまま抽出するのではなく、tarball 内部にあり、可能であればリンク先のコピーとして抽出されます。`/etc/passwd` へのリンクのような非内部シンボリックリンクはコピーされません。何らかの形で循環しているシンボリックリンクもコピーされず、スキップされます。デフォルトでは、`extract` は `dir` にシンボリックリンクを作成できるかどうかを検出し、作成できない場合は自動的にシンボリックリンクをコピーします。

`set_permissions` が `false` の場合、抽出されたファイルには権限が設定されません。
