```
sparse!(I::AbstractVector{Ti}, J::AbstractVector{Ti}, V::AbstractVector{Tv},
        m::Integer, n::Integer, combine, klasttouch::Vector{Ti},
        csrrowptr::Vector{Ti}, csrcolval::Vector{Ti}, csrnzval::Vector{Tv},
        [csccolptr::Vector{Ti}], [cscrowval::Vector{Ti}, cscnzval::Vector{Tv}] ) where {Tv,Ti<:Integer}
```

[`sparse`](@ref)の親および専門的なドライバー; 基本的な使用法については[`sparse`](@ref)を参照してください。このメソッドは、ユーザーが`sparse`の中間オブジェクトと結果のために事前に割り当てられたストレージを提供できるようにします。これにより、座標表現からの[`SparseMatrixCSC`](@ref)の効率的な連続構築が可能になり、結果の転置の非ソート列表現を追加コストなしで抽出することも可能になります。

このメソッドは、主に3つのステップで構成されています: (1) 提供された座標表現を、重複エントリを含む非ソート行CSR形式にカウントソートします。 (2) CSR形式をスイープしながら、目的のCSC形式の列ポインタ配列を同時に計算し、重複エントリを検出し、重複エントリを結合してCSR形式を再パッキングします。この段階では、重複エントリのない非ソート行CSR形式が得られます。 (3) 前のCSR形式を、重複エントリのない完全にソートされたCSC形式にカウントソートします。

入力配列`csrrowptr`、`csrcolval`、および`csrnzval`は、中間CSR形式のストレージを構成し、`length(csrrowptr) >= m + 1`、`length(csrcolval) >= length(I)`、および`length(csrnzval >= length(I))`を必要とします。入力配列`klasttouch`は、第二段階の作業領域であり、`length(klasttouch) >= n`を必要とします。オプションの入力配列`csccolptr`、`cscrowval`、および`cscnzval`は、返されるCSC形式`S`のストレージを構成します。必要に応じて、これらは自動的にサイズ変更され、`length(csccolptr) = n + 1`、`length(cscrowval) = nnz(S)`、および`length(cscnzval) = nnz(S)`を満たします。したがって、`nnz(S)`が最初から不明な場合は、適切な型の空のベクター（`Vector{Ti}()`および`Vector{Tv}()`）を渡すか、`cscrowval`および`cscnzval`を無視して`sparse!`メソッドを呼び出すだけで済みます。

戻り値として、`csrrowptr`、`csrcolval`、および`csrnzval`は、結果の転置の非ソート列表現を含みます。

入力配列のストレージ（`I`、`J`、`V`）を出力配列（`csccolptr`、`cscrowval`、`cscnzval`）に再利用することができます。たとえば、`sparse!(I, J, V, csrrowptr, csrcolval, csrnzval, I, J, V)`と呼び出すことができます。これらは上記の条件を満たすようにサイズ変更されます。

効率のために、このメソッドは`1 <= I[k] <= m`および`1 <= J[k] <= n`を超える引数チェックを行いません。注意して使用してください。`--check-bounds=yes`でのテストは賢明です。

このメソッドは`O(m, n, length(I))`の時間で実行されます。F. Gustavsonによって記述されたHALFPERMアルゴリズム、「スパース行列のための2つの高速アルゴリズム：乗算と順序付けられた転置」、ACM TOMS 4(3)、250-269 (1978)が、このメソッドのカウントソートのペアの使用にインスピレーションを与えました。
