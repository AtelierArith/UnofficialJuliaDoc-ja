generic_mvpv!(trans, alpha, A, x, beta, y) -> nothing

`generic_mvpv!` は次の行列-ベクトル演算を実行します：

`y[1:K] = alpha*A'*x[1:L] + beta*y[1:K]`

インプレースで、ここで `alpha` と `beta` はスカラー、`x` は少なくとも L 要素を持つベクトル、`y` は少なくとも K 要素を持つベクトル、`A` は `NxM` 行列です。`A'` は転置を示すことができ、すなわち `transpose(A)` または共役転置、すなわち `adjoint(A)` であり、その場合 `M==K && N==L` です。`A'` は全く隣接しないことを示すこともでき、すなわち `A'==A` であり、その場合 `N==K && M==L` です。

`trans` は文字で、`'T'`、`'C'` または `'N'` のいずれかで、`A'=transpose(A)`、`A'=adjoint(A)` または `A'=A` を示します。
