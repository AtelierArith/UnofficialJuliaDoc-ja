bk*rowcol*swap!(A, k, kp, kstep, upper, herm) -> did_swap::Bool

Bunch-Kaufman 分解における行と列の入れ替えを行います。`upper==true` の場合、`A[1:k,1:k]` の行と列 `kp` を、`kstep==1` か `kstep==2` かに応じて、`A[1:k,1:k]` の行と列 `k` または `k-1` と入れ替えます。`upper==false` の場合、`A[k:N,k:N]` の行と列 `kp-k+1` を、`kstep==1` か `kstep==2` かに応じて、`A[k:N,k:N]` の行と列 `1` または `2` と入れ替えます。`herm=true` の場合は、`A` がエルミート行列であると仮定し、入れ替えた行と列の該当する要素に共役を適用します。`herm=false` の場合は、共役を行いません。

これは、Bunch-Kaufman 分解のメイン関数 `generic_bunchkaufman!` で使われる内部ヘルパー関数です。そのため、入力値の妥当性は検証されません。
