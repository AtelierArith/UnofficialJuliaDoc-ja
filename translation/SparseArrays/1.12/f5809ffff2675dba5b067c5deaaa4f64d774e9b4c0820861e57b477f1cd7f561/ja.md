```julia
spzeros!(::Type{Tv}, I::AbstractVector{Ti}, J::AbstractVector{Ti}, m::Integer, n::Integer,
         klasttouch::Vector{Ti}, csrrowptr::Vector{Ti}, csrcolval::Vector{Ti},
         [csccolptr::Vector{Ti}], [cscrowval::Vector{Ti}, cscnzval::Vector{Tv}]) where {Tv,Ti<:Integer}
```

`spzeros(I, J)`の親および専門的なドライバーであり、ユーザーが中間オブジェクトのための事前に割り当てられたストレージを提供できるようにします。このメソッドは、`spzeros`に対して`SparseArrays.sparse!`が`sparse`に対して持つのと同じ関係です。詳細および必要なバッファの長さについては、`SparseArrays.sparse!`のドキュメントを参照してください。

!!! compat "Julia 1.10"
    このメソッドは、Juliaバージョン1.10以降を必要とします。

