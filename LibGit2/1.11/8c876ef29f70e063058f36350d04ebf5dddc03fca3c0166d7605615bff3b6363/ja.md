```
GitShortHash(hash::GitHash, len::Integer)
```

短縮されたgitオブジェクト識別子で、ユニークなgitオブジェクトを識別するために使用できます。これは、`hash`の最初の`len`の16進数の桁で構成されており（残りの桁は無視されます）。
