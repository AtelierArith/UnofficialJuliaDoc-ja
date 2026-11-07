```julia
S_IRUSR
S_IWUSR
S_IXUSR
S_IRGRP
S_IWGRP
S_IXGRP
S_IROTH
S_IWOTH
S_IXOTH
```

ファイルのアクセス権限ビットを表す定数です。一般的な形式は `S_I[permission][class]` です。ここで、`permission` は、読み取りの場合は `R`、書き込みの場合は `W`、実行の場合は `X` となります。また、`class` は、ユーザー（所有者）の場合は `USR`、グループの場合は `GRP`、その他の場合は `OTH` となります。
