```julia
write(filename::AbstractString, content)
```

`content` の正規バイナリ表現をファイルに書き込みます。ファイルが存在しない場合は新規作成し、存在する場合は上書きします。

ファイルに書き込んだバイト数を返します。
