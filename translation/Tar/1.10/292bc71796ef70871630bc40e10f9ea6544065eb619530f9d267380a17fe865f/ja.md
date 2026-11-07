`Header`型は、tarファイル内の1つのレコードに関する基本的なメタデータを表す構造体で、定義は次のとおりです。

```julia
struct Header
    path :: String # path relative to the root
    type :: Symbol # type indicator (see below)
    mode :: UInt16 # mode/permissions (best viewed in octal)
    size :: Int64  # size of record data in bytes
    link :: String # target path of a symlink
end
```

型は、次のシンボルで表されます: `file`、`hardlink`、`symlink`、`chardev`、`blockdev`、`directory`、`fifo`。不明な型の場合は、typeflag文字がシンボルとして使われます。[`extract`](@ref)は、`file`、`symlink`、`directory`以外のレコード型の展開を拒否します。また、[`list`](@ref)は、`strict=false`を指定して呼び出した場合に限り、その他の種類のレコードを一覧表示します。

tar形式には、ユーザーIDやグループID、ユーザー名やグループ名、タイムスタンプなど、レコードに関するさまざまなメタデータも含まれています。`Tar`パッケージは、設計上、これらを一切扱いません。tarファイルの作成時には、これらのフィールドは常にゼロまたは空に設定されます。読み込み時には、各ヘッダーレコードのヘッダーチェックサムをすべてのフィールドについて検証する場合を除き、これらのフィールドは無視されます。
