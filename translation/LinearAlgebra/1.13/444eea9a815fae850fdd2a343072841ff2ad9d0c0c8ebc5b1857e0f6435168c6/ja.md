generic_bunchkaufman!(uplo, A, syhe, rook::Bool=false) -> LD<:AbstractMatrix, ipiv<:AbstractVector{Integer}, info::BlasInt

対称行列またはエルミート行列 `A`（サイズ `NxN`）の Bunch-Kaufman 分解を計算します。`A` のどちらの三角部分が格納されているかに応じて、`P'*U*D*U'*P` または `P'*L*D*L'*P` として分解します。ここで、`U` と `L` はそれぞれ上三角行列と下三角行列、`P` は置換行列、`D` は 1×1 および 2×2 ブロックからなるブロック対角行列です。`A` が複素対称行列の場合、`U'` と `L'` は共役を取らない転置を表し、すなわち `transpose(U)` と `transpose(L)` であることに注意してください。分解結果の `U` または `L` と `D` は、LAPACK 形式で `A` にインプレースで格納されます。`LD` は `A` への参照にすぎません（つまり、`LD===A`）。`ipiv` には、アルゴリズムの置換情報が LAPACK 形式で格納されます。`info` は、`info==0` の場合に分解が成功し、非特異であったかどうかを示します。それ以外の場合、`info` は別の値を取ります。出力 `LD`、`ipiv`、`info` は、Bunch-Kaufman 分解を行う LAPACK 関数（`dsytrf`、`csytrf`、`chetrf` など）と同じ形式に従います。そのため、この関数は LAPACK の対応関数 `LAPACK.sytrf!`、`LAPACK.sytrf_rook!` などと（理想的には）相互に置き換えて使用できます。

`uplo` は文字で、`'U'` または `'L'` を指定します。行列が上三角部分（`uplo=='U'`）と下三角部分（`uplo=='L'`）のどちらに格納されているかを示します。

`syhe` は文字で、`'S'` または `'H'` を指定します。行列が実数または複素数の対称行列（`syhe=='S'`。この場合は対称 Bunch-Kaufman 分解を実行）か、複素エルミート行列（`syhe=='H'`。この場合はエルミート Bunch-Kaufman 分解を実行）かを示します。

`rook` が `true` の場合、rook ピボット選択（bounded Bunch-Kaufman 分解とも呼ばれます）を使用します。`rook` が `false` の場合、rook ピボット選択は使用せず、標準の Bunch-Kaufman 分解を行います。rook ピボット選択では、標準の Bunch-Kaufman 分解に必要な `~N^3/3` 回の加算と `~N^3/3` 回の乗算に加えて、最大 `~N^3/6` 回の比較が必要になることがあります。一方、rook ピボット選択を使うと、`U` または `L` の要素が有界であることが保証されます。

この関数は分解アルゴリズム全体を Julia ネイティブで実装しているため、実数または複素数を表す任意の数値型をサポートします。
