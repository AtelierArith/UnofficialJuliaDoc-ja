```julia
download_verify(
    url::AbstractString,
    hash::Union{AbstractString, Nothing},
    dest::AbstractString;
    verbose::Bool = false,
    force::Bool = false,
    quiet_download::Bool = false,
)
```

`url` にあるファイルをダウンロードし、指定された `hash` と一致することを検証します。問題が発生した場合はエラーをスローします。`dest` がすでに存在する場合は、検証のみを行います。`force` が `true` に設定されている場合、ファイルが存在していて指定された `hash` と一致しなければ、そのファイルを上書きします。

このメソッドは、ファイルのダウンロードに成功した場合は `true` を返し、`force` の使用によって既存のファイルが削除された場合は `false` を返します。また、`force` が設定されておらず、すでに存在するファイルの検証に失敗した場合、または `force` が設定されていて検証に失敗し、ファイルを再ダウンロードした後も検証に失敗した場合は、エラーをスローします。

`quiet_download` が `false` に設定されている場合、新しいファイルのダウンロード時に標準出力へメッセージを表示します。`true`（デフォルト。`verbose` が `false` に設定されている場合）に設定されている場合、ダウンロード処理は完全に無音になります。`verbose` が `true` に設定されている場合は、ダウンロードに関するメッセージに加えて、整合性検証に関するメッセージも表示されます。
