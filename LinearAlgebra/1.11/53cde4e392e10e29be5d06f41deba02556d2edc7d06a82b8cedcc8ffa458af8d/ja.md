bk*rowcol*swap!(A, k, kp, kstep, upper, herm) -> did_swap::Bool

Bunch-Kaufman因子分解の行と列の入れ替えを実行します。`upper==true`の場合、`A[1:k,1:k]`の行と列`kp`は、`kstep==1`または`kstep==2`に応じて、`A[1:k,1:k]`の行と列`k`または`k-1`と入れ替えられます。`upper==false`の場合、`A[k:N,k:N]`の行と列`kp-k+1`は、`kstep==1`または`kstep==2`に応じて、`A[k:N,k:N]`の行と列`1`または`2`と入れ替えられます。`herm=true`の場合、`A`がエルミートであると仮定され、入れ替えられた行と列の適切なエントリに共役が適用されます。`herm=false`の場合、共役は行われません。

これは、主なBunch-Kaufman因子分解関数`generic_bunchkaufman!`の内部ヘルパー関数です。そのため、入力値の有効性は検証されません。
