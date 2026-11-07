```julia
detect_archive_format(tarball_path::AbstractString)
```

ファイルのマジックバイトを読み取って圧縮形式を検出します。"zstd"、"gzip"、"bzip2"、"xz"、"lz4"、"tar"、"unknown" のいずれかを返します。

注: これは、ダウンロード後のファイル拡張子の決定と、適切な解凍ツールの選択の両方に使用されます。
