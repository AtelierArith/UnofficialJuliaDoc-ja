```julia
detect_archive_format(tarball_path::AbstractString)
```

ファイルのマジックバイトを読み取り、圧縮形式を判定します。戻り値は、"zstd"、"gzip"、"bzip2"、"xz"、"lz4"、"tar"、"unknown" のいずれかです。

注: ダウンロード後のファイル拡張子の判定と、適切な展開ツールの選択の両方に使用されます。
