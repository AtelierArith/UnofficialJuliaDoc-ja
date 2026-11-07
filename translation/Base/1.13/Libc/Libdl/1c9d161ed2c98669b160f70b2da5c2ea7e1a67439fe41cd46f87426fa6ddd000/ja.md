```julia
find_library(names [, locations])
```

`locations` リスト内のパス、`DL_LOAD_PATH`、システムのライブラリパスの順に検索し、`names` 内で最初に見つかった、dlopen に成功するライブラリを探します。成功すると、戻り値はライブラリ名のいずれかになります（locations 内のパスが前置される場合があります）。この文字列は `global const` に代入し、以降の `ccall` でライブラリ名として使用できます。失敗した場合は、空文字列を返します。
