```julia
copy_similar(A, T)
```

`similar(A, T, size(A))`に基づいて、`A`を要素型`T`の可変配列にコピーします。

`copymutable_oftype`と比べて、結果はより柔軟なものになります。一般に、出力の型は3引数メソッド`similar(A, T, size(A))`の型に対応します。

関連項目: `copymutable_oftype`。
