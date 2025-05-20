```
LibGit2.reftype(ref::GitReference) -> Cint
```

`ref`のタイプに対応する`Cint`を返します：

  * 参照が無効な場合は`0`
  * 参照がオブジェクトIDの場合は`1`
  * 参照がシンボリックの場合は`2`
