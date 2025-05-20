```
GitShortHash(obj::GitObject)
```

`obj`の短縮識別子（`GitShortHash`）を取得します。最小の長さ（文字数）は`core.abbrev`設定オプションによって決定され、リポジトリ内のオブジェクトを明確に識別するのに十分な長さになります。
