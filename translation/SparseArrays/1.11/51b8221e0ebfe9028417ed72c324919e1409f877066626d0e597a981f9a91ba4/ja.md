`halfperm!`のためのヘルパーメソッド。`transpose(A[:,q])`の列ポインタを計算し、`getcolptr(X)`に1つ前方にシフトして格納します。`_distributevals_halfperm!`がこのシフトを修正します。
