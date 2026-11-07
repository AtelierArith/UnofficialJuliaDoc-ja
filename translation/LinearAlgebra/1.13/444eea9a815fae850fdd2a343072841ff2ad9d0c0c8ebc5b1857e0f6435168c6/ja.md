generic_bunchkaufman!(uplo, A, syhe, rook::Bool=false) -> LD<:AbstractMatrix, ipiv<:AbstractVector{Integer}, info::BlasInt

対称行列またはエルミート行列 `A`（サイズ `NxN`）の Bunch-Kaufman 分解を、`A` に格納されている三角部分に応じて、`P'*U*D*U'*P` または `P'*L*D*L'*P` として計算します。ここで、`U` と `L` はそれぞれ上三角行列と下三角行列、`P` は置換行列、`D` は 1×1 および 2×2 ブロックからなるブロック対角行列です。`A` が複素対称行列の場合、`U'` と `L'` は共役を取らない転置、すなわち `transpose(U)` と `transpose(L)` を表すことに注意してください。結果の `U` または `L` と `D` は、LAPACK 形式で `A` にインプレースで格納されます。`LD` は `A`（つまり `LD===A`）への参照にすぎません。`ipiv` には、アルゴリズムの置換情報が LAPACK 形式で格納されます。`info` は、`info==0` の場合に分解が成功し、特異でないことを示します。それ以外の場合、`info` は別の値を取ります。出力 `LD`、`ipiv`、`info` は、Bunch-Kaufman 分解を行う LAPACK 関数（`dsytrf`、`csytrf`、`chetrf` など）と同じ形式に従います。そのため、この関数は LAPACK の対応関数 `LAPACK.sytrf!`、`LAPACK.sytrf_rook!` などと（理想的には）相互に置き換えて使用できます。

`uplo` は文字で、`'U'` または `'L'` のいずれかです。行列を上三角部分（`uplo=='U'`）と下三角部分（`uplo=='L'`）のどちらに格納するかを指定します。

`syhe` は文字で、`'S'` または `'H'` のいずれかです。行列が実数または複素数の対称行列（`syhe=='S'`。この場合は対称 Bunch-Kaufman 分解を実行）か、複素エルミート行列（`syhe=='H'`。この場合はエルミート Bunch-Kaufman 分解を実行）かを指定します。

`rook` が `true` の場合、ルークピボット選択（有界 Bunch-Kaufman 分解とも呼ばれます）を使用します。`rook` が `false` の場合、ルークピボット選択は使用せず、標準の Bunch-Kaufman 分解を行います。ルークピボット選択では、標準の Bunch-Kaufman 分解で必要な `~N^3/3` 回の加算と `~N^3/3` 回の乗算に加えて、最大 `~N^3/6` 回の比較が必要になることがあります。一方、ルークピボット選択では、`U` または `L` の要素が有界であることが保証されます。

この関数は分解アルゴリズム全体をネイティブ Julia で実装しているため、実数または複素数を表す任意の数値型をサポートします。
