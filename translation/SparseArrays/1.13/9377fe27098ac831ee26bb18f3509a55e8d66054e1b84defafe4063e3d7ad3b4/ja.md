```julia
sparse!(I::AbstractVector{Ti}, J::AbstractVector{Ti}, V::AbstractVector{Tv},
        m::Integer, n::Integer, combine, klasttouch::Vector{Ti},
        csrrowptr::Vector{Ti}, csrcolval::Vector{Ti}, csrnzval::Vector{Tv},
        [csccolptr::Vector{Ti}], [cscrowval::Vector{Ti}, cscnzval::Vector{Tv}] ) where {Tv,Ti<:Integer}
```

[`sparse`](@ref)の親メソッドであり、効率的な利用のためのドライバーです。基本的な使い方については[`sparse`](@ref)を参照してください。このメソッドでは、以下で説明するように、`sparse`の中間オブジェクトと結果を格納するための領域を、あらかじめユーザーが確保して渡せます。この機能により、座標表現から[`SparseMatrixCSC`](@ref)を連続して構築する際の効率が向上します。また、追加コストなしで、結果の転置を列が未整列の表現として取り出せます。

このメソッドは、次の3つの主要なステップで構成されます。(1) 与えられた座標表現を計数ソートし、重複エントリを含む行が未整列のCSR形式に変換します。(2) CSR形式を走査しながら、目的のCSC形式の列ポインタ配列を計算し、重複エントリを検出するとともに、重複エントリを統合してCSR形式を再構成します。この段階で、重複エントリのない、行が未整列のCSR形式が得られます。(3) 先ほどのCSR形式を計数ソートし、重複エントリのない、完全に整列されたCSC形式に変換します。

入力配列`csrrowptr`、`csrcolval`、`csrnzval`は、中間CSR形式を格納するためのもので、`length(csrrowptr) >= m + 1`、`length(csrcolval) >= length(I)`、`length(csrnzval >= length(I))`が必要です。第2段階の作業領域となる入力配列`klasttouch`には、`length(klasttouch) >= n`が必要です。省略可能な入力配列`csccolptr`、`cscrowval`、`cscnzval`は、返されるCSC形式`S`を格納するためのものです。必要に応じて、これらの配列は`length(csccolptr) = n + 1`、`length(cscrowval) = nnz(S)`、`length(cscnzval) = nnz(S)`を満たすよう自動的にサイズ変更されます。そのため、`nnz(S)`が事前にわからない場合は、適切な型の空ベクトル（それぞれ`Vector{Ti}()`および`Vector{Tv}()`）を渡せば十分です。または、`cscrowval`と`cscnzval`を省略して、`sparse!`メソッドを呼び出すこともできます。

戻り値として、`csrrowptr`、`csrcolval`、`csrnzval`には、結果の転置を列が未整列の形式で表したものが格納されます。

入力配列の領域（`I`、`J`、`V`）は、出力配列（`csccolptr`、`cscrowval`、`cscnzval`）に再利用できます。たとえば、`sparse!(I, J, V, csrrowptr, csrcolval, csrnzval, I, J, V)`を呼び出せます。上記の条件を満たすよう、これらの配列はサイズ変更されることに注意してください。

効率を優先し、このメソッドでは`1 <= I[k] <= m`と`1 <= J[k] <= n`以外の引数チェックは行いません。注意して使用してください。`--check-bounds=yes`でテストしておくとよいでしょう。

このメソッドの実行時間は`O(m, n, length(I))`です。計数ソートを2回行うこのメソッドの方式は、F. Gustavsonの論文「Two fast algorithms for sparse matrices: multiplication and permuted transposition」（ACM TOMS 4(3), 250–269, 1978）で説明されているHALFPERMアルゴリズムに着想を得ています。
