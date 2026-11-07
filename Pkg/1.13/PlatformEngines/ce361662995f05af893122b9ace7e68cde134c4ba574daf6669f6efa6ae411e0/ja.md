```julia
download_verify_unpack(
    url::AbstractString,
    hash::Union{AbstractString, Nothing},
    dest::AbstractString;
    tarball_path = nothing,
    ignore_existence::Bool = false,
    force::Bool = false,
    verbose::Bool = false,
    quiet_download::Bool = false,
    io::IO=stderr,
)
```

`url` にある tarball をダウンロードし、指定された `hash` と一致することを検証してから、フォルダー `dest` に展開するヘルパーメソッドです。通常、tarball をダウンロードして `Prefix` にインストールするには、メソッド `install()` を使用してください。このメソッドは、`install()` の追加機能が不要な場合にのみ使用してください。

`tarball_path` が指定されている場合、指定された `url` は `tarball_path` にダウンロードされ、ダウンロードと検証が完了した後も削除されません。指定されていない場合、tarball は一時的な場所にダウンロードされ、検証の完了後に削除されます。

`force` が指定されている場合、検証に失敗すると、`tarball_path` が存在すれば削除され、`dest` フォルダーも存在すれば削除されたうえで、tarball が再ダウンロードされ、再検証されます。2 回目の検証にも失敗した場合は、例外が送出されます。`force` が指定されていない場合、検証に失敗すると直ちに例外が送出されます。

`ignore_existence` が設定されている場合、展開先のディレクトリがすでに存在していても tarball を展開します。

tarball が実際に展開された場合は `true` を返し、インストール先のプレフィックスに変更がなかった場合は `false` を返します。
