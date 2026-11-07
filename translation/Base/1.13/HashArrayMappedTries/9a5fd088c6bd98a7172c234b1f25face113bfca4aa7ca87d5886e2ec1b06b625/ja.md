```julia
path(trie, h, copyf)::(found, present, trie, i, top, level)
```

HAMTを走査して、ハッシュに対応するスロットを見つける内部関数です。値が`present`であるか、`found`であるかを返します。

`trie.data`内のインデックス`i`と、現在の`level`に加えて、`trie`を返します。

コピー関数`copyf`が指定されている場合は、新しい永続ツリーに`top`の戻り値を使用します。
