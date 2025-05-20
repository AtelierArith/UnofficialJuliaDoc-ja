```
copy_similar(A, T)
```

`A`を`similar(A, T, size(A))`に基づいて、eltype `T`を持つ可変配列にコピーします。

`copymutable_oftype`と比較して、結果はより柔軟です。一般に、出力の型は三引数メソッド`similar(A, T, size(A))`の型に対応します。

関連情報: `copymutable_oftype`。
