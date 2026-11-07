```julia
PosDefException
```

入力行列が[positive definite](https://en.wikipedia.org/wiki/Definiteness_of_a_matrix)でない場合にスローされます。線形代数関数や行列分解の中には、正定値行列にのみ適用できるものがあります。`info`フィールドは、0以下の固有値の位置を示します。
