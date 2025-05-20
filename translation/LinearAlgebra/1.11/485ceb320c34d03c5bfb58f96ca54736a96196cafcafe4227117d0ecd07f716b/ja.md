```
copymutable_oftype(A, T)
```

`A`を`similar(A, T)`に基づいて、eltype `T`を持つ可変配列にコピーします。

結果として得られる行列は、通常`A`と似た代数構造を持ちます。例えば、三重対角行列を供給すると、別の三重対角行列が得られます。一般に、出力の型は`similar(A, T)`の型に対応します。

LinearAlgebraでは、可変コピー（希望するeltypeのもの）が作成され、インプレースアルゴリズム（`ldiv!`、`rdiv!`、`lu!`など）に渡されます。特定のアルゴリズムが代数構造を保持することが知られている場合は、`copymutable_oftype`を使用します。アルゴリズムが密行列（または密行列に基づく何らかのラッパー）を返すことが知られている場合は、`copy_similar`を使用します。

関連情報: `Base.copymutable`、`copy_similar`。
