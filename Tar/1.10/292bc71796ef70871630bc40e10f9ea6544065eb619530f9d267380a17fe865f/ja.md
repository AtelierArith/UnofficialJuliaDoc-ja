`Header` 型は、tar ファイル内の単一レコードに関する基本的なメタデータを表す構造体で、次のように定義されています。

```julia
struct Header
    path :: String # path relative to the root
    type :: Symbol # type indicator (see below)
    mode :: UInt16 # mode/permissions (best viewed in octal)
    size :: Int64  # size of record data in bytes
    link :: String # target path of a symlink
end
```

型は次のシンボルで表されます: `file`、`hardlink`、`symlink`、`chardev`、`blockdev`、`directory`、`fifo`。不明な型の場合は、typeflag の文字をシンボルとして使用します。[`extract`](@ref) は、`file`、`symlink`、`directory` 以外のレコード型の展開を拒否します。また、[`list`](@ref) は、`strict=false` を指定して呼び出した場合に限り、その他の種類のレコードを一覧表示します。

tar 形式には、ユーザー ID とグループ ID、ユーザー名とグループ名、タイムスタンプなど、レコードに関するさまざまなメタデータも含まれています。`Tar` パッケージは、設計上、これらを完全に無視します。tar ファイルを作成する際、これらのフィールドは常にゼロまたは空に設定されます。tar ファイルを読み込む際は、各ヘッダーレコードのすべてのフィールドについてヘッダーのチェックサムを検証する場合を除き、これらのフィールドは無視されます。
