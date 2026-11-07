```julia
spzeros!(::Type{Tv}, I::AbstractVector{Ti}, J::AbstractVector{Ti}, m::Integer, n::Integer,
         klasttouch::Vector{Ti}, csrrowptr::Vector{Ti}, csrcolval::Vector{Ti},
         [csccolptr::Vector{Ti}], [cscrowval::Vector{Ti}, cscnzval::Vector{Tv}]) where {Tv,Ti<:Integer}
```

`spzeros(I, J)` の親メソッドであり、内部オブジェクト用に事前確保したストレージをユーザーが指定できるようにする、専門的なドライバーメソッドです。このメソッドと `spzeros` の関係は、`SparseArrays.sparse!` と `sparse` の関係に相当します。詳細と必要なバッファー長については、`SparseArrays.sparse!` のドキュメントを参照してください。

!!! compat "Julia 1.10"
    このメソッドを使用するには、Julia 1.10 以降が必要です。

