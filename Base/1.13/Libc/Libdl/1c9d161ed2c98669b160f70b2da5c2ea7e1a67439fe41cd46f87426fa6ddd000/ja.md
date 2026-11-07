```julia
find_library(names [, locations])
```

`names` 内で最初に見つかり、`locations` のリストにあるパス、`DL_LOAD_PATH`、またはシステムのライブラリパス（この順）から正常に dlopen できるライブラリを検索します。成功すると、戻り値はライブラリ名のいずれかになります（locations 内のパスが前置される場合があります）。この文字列は `global const` に代入し、以降の `ccall` でライブラリ名として使用できます。失敗した場合は空文字列を返します。
