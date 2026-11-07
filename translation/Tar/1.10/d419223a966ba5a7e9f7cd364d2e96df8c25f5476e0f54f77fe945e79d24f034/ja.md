```julia
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

パス `tarball` にある tar アーカイブ（「tarball」）を、ディレクトリ `dir` に展開します。`tarball` がパスではなく IO オブジェクトの場合、アーカイブの内容はその IO ストリームから読み込まれます。アーカイブは `dir` に展開されます。このパスは、既存の空ディレクトリか、新しいディレクトリとして作成可能な未作成のパスでなければなりません。`dir` が指定されていない場合、アーカイブは一時ディレクトリに展開され、そのディレクトリが `extract` によって返されます。

`predicate` 関数が渡された場合、`tarball` の展開中に見つかった各 `Header` オブジェクトに対してその関数が呼び出され、`predicate(hdr)` が true の場合にのみ、そのエントリが展開されます。これにより、アーカイブの一部だけを選択して展開したり、`extract` がエラーをスローするエントリをスキップしたり、展開中に何が展開されたかを記録したりできます。

述語関数に渡される前に、`Header` オブジェクトは tarball 内の生のヘッダーから多少変更されます。`path` フィールドでは `.` エントリが削除され、連続する複数のスラッシュが単一のスラッシュに置き換えられます。エントリの型が `:hardlink` の場合、リンク先のパスも同様に正規化され、対象エントリのパスと一致するようになります。また、size フィールドにはリンク先パスのサイズが設定されます（対象はすでに読み込まれたファイルでなければなりません）。

`skeleton` キーワードを渡すと、展開した tarball の「スケルトン」が、指定されたファイルまたは IO ハンドルに書き込まれます。このスケルトンファイルは、`create` 関数に `skeleton` キーワードを渡すことで、同一の tarball を再作成するために使用できます。`skeleton` 引数と `predicate` 引数は同時に使用できません。

`copy_symlinks` が `true` の場合、シンボリックリンクはそのままではなく、tarball 内部を指していて、かつ可能な場合に、リンク先のコピーとして展開されます。`/etc/passwd` へのリンクなど、tarball 内部を指していないシンボリックリンクはコピーされません。循環を含むシンボリックリンクもコピーされず、スキップされます。デフォルトでは、`extract` は `dir` でシンボリックリンクを作成できるかどうかを判定し、作成できない場合は自動的にコピーします。

`set_permissions` が `false` の場合、展開したファイルには権限が設定されません。
