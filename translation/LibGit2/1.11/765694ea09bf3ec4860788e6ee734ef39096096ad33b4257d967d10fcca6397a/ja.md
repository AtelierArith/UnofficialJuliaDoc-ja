```julia
GitShortHash(obj::GitObject)
```

`obj` の短縮識別子（`GitShortHash`）を取得します。最小文字数は `core.abbrev` 設定オプションによって決まり、リポジトリ内のオブジェクトを一意に識別できる長さになります。
