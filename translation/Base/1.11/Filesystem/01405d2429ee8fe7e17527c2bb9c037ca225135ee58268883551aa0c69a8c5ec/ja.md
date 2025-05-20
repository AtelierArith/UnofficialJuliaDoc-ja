```
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

ファイルアクセス権ビットの定数。一般的な構造は `S_I[permission][class]` で、ここで `permission` は読み取りのための `R`、書き込みのための `W`、実行のための `X`、`class` はユーザー/オーナーのための `USR`、グループのための `GRP`、その他のための `OTH` です。
