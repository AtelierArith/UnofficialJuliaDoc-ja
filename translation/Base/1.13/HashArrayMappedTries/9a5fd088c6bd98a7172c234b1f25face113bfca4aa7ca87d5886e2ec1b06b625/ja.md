```julia
path(trie, h, copyf)::(found, present, trie, i, top, level)
```

HAMTを走査し、ハッシュに対応するスロットを見つける内部関数です。値が`present`であるかどうかと、値が`found`であるかどうかを返します。

`trie.data`内の`trie`とインデックス`i`、および現在の`level`を返します。

コピー関数`copyf`が指定されている場合は、新しい永続ツリーに対して、その戻り値`top`を使用します。
