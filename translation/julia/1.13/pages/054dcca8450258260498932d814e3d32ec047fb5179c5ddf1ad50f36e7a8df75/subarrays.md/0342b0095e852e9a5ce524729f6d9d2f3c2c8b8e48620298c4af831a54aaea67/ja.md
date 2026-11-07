# SubArrays

Julia の `SubArray` 型は、親 [`AbstractArray`](@ref) の「ビュー」を表すコンテナです。このページでは、`SubArray` の設計原則と実装について説明します。

設計上の大きな目標の一つは、[`IndexLinear`](@ref) 配列と [`IndexCartesian`](@ref) 配列のどちらについても、ビューの性能を高く保つことです。さらに、可能な限り、`IndexLinear` 配列のビュー自体も `IndexLinear` であるべきです。

## Index replacement

3 次元配列から 2 次元スライスを作る場合を考えてみましょう。

```@meta
DocTestSetup = :(import Random; Random.seed!(1234))
```

```jldoctest subarray
julia> A = rand(2,3,4);

julia> S1 = view(A, :, 1, 2:3)
2×2 view(::Array{Float64, 3}, :, 1, 2:3) with eltype Float64:
 0.839622  0.711389
 0.967143  0.103929

julia> S2 = view(A, 1, :, 2:3)
3×2 view(::Array{Float64, 3}, 1, :, 2:3) with eltype Float64:
 0.839622  0.711389
 0.789764  0.806704
 0.566704  0.962715
```

```@meta
DocTestSetup = nothing
```

`view` は、「単一要素」の次元（`Int` で指定された次元）を取り除くため、`S1` と `S2` はどちらも 2 次元の `SubArray` になります。そのため、これらをインデックス指定する自然な方法は `S1[i,j]` です。親配列 `A` から値を取り出すには、`S1[i,j]` を `A[i,1,(2:3)[j]]` に、`S2[i,j]` を `A[1,i,(2:3)[j]]` に置き換えるのが自然です。

SubArrays の設計における重要な特徴は、このインデックスの置き換えを実行時のオーバーヘッドなしで行えることです。

## SubArray design

### Type parameters and fields

採用されている方針は、まず型の定義に表れています。

```julia
struct SubArray{T,N,P,I,L} <: AbstractArray{T,N}
    parent::P
    indices::I
    offset1::Int       # for linear indexing and pointer, only valid when L==true
    stride1::Int       # used only for linear indexing
    ...
end
```

`SubArray` は 5 つの型パラメーターを持ちます。最初の 2 つは、標準的な要素型と次元数です。次は親 `AbstractArray` の型です。最もよく使われるのは 4 番目のパラメーターで、各次元のインデックス型を並べた `Tuple` です。最後の `L` は、ディスパッチを簡便にするためだけに用意されています。高速な線形インデックス指定に対応するかどうかを表すブール値です。詳しくは後述します。

上の例で `A` が `Array{Float64, 3}` なら、先ほどの `S1` のケースは `SubArray{Float64,2,Array{Float64,3},Tuple{Base.Slice{Base.OneTo{Int64}},Int64,UnitRange{Int64}},false}` になります。特に、タプル型パラメーターには、`S1` の作成に使われたインデックスの型が格納されている点に注目してください。同様に、

```jldoctest subarray
julia> S1.indices
(Base.Slice(Base.OneTo(2)), 1, 2:3)
```

これらの値を格納しておくことでインデックスを置き換えられ、型をパラメーターとして符号化することで、効率的なアルゴリズムへのディスパッチが可能になります。

### Index translation

インデックス変換では、具体的な `SubArray` の型ごとに異なる処理が必要です。たとえば `S1` では、`i,j` インデックスを親配列の第 1 次元と第 3 次元に適用する必要があります。一方、`S2` では、第 2 次元と第 3 次元に適用します。インデックス指定の最も単純な方法は、実行時に型を解析することです。

```julia
parentindices = Vector{Any}()
for thisindex in S.indices
    ...
    if isa(thisindex, Int)
        # Don't consume one of the input indices
        push!(parentindices, thisindex)
    elseif isa(thisindex, AbstractVector)
        # Consume an input index
        push!(parentindices, thisindex[inputindex[j]])
        j += 1
    elseif isa(thisindex, AbstractMatrix)
        # Consume two input indices
        push!(parentindices, thisindex[inputindex[j], inputindex[j+1]])
        j += 2
    elseif ...
end
S.parent[parentindices...]
```

しかし、これは性能にとって致命的です。要素にアクセスするたびにメモリ割り当てが発生し、型付けの不十分なコードが大量に実行されることになります。

よりよい方法は、格納されたインデックスの型ごとに専用のメソッドへディスパッチすることです。`reindex` はこの方法を採用しています。最初に格納されたインデックスの型に基づいてディスパッチし、適切な数の入力インデックスを消費した後、残りのインデックスについて再帰的に処理します。`S1` の場合、これは次のように展開されます。

```julia
Base.reindex(S1, S1.indices, (i, j)) == (i, S1.indices[2], S1.indices[3][j])
```

ただし、インデックスの組 `(i,j)` がどのようなものであっても（[`CartesianIndex`](@ref) とその配列は除きます。後述）、この形になります。

これが `SubArray` の中核です。インデックス指定メソッドは、このインデックス変換を `reindex` に任せます。ただし、間接参照を避けて、さらに高速化できる場合もあります。

### Linear indexing

配列全体で、あるオフセットから始まる要素間のストライドが一定なら、線形インデックス指定を効率的に実装できます。つまり、これらの値を事前に計算しておけば、線形インデックス指定を加算と乗算だけで表現できます。これにより、`reindex` の間接参照を避けられます。また、より重要な点として、デカルト座標の計算そのものを省けます。

`SubArray` 型では、高速な線形インデックス指定が可能かどうかはインデックスの型だけで決まり、親配列のサイズなどの値には依存しません。指定したインデックスの組が高速な線形インデックス指定に対応するかどうかは、内部関数 `Base.viewindexing` で確認できます。

```jldoctest subarray
julia> Base.viewindexing(S1.indices)
IndexCartesian()

julia> Base.viewindexing(S2.indices)
IndexLinear()
```

この判定は `SubArray` の構築時に行われ、高速な線形インデックス指定に対応するかどうかを表すブール値として、`L` の型パラメーターに格納されます。必須ではありませんが、これにより中間処理を挟まず、`SubArray{T,N,A,I,true}` に直接ディスパッチできます。

この判定は実行時の値に依存しないため、ストライドがたまたま一定になるケースを見逃すことがあります。

```jldoctest
julia> A = reshape(1:4*2, 4, 2)
4×2 reshape(::UnitRange{Int64}, 4, 2) with eltype Int64:
 1  5
 2  6
 3  7
 4  8

julia> diff(A[2:2:4,:][:])
3-element Vector{Int64}:
 2
 2
 2
```

`view(A, 2:2:4, :)` として構築されたビューは、たまたまストライドが一定なので、線形インデックス指定を効率的に行えます。しかし、このケースでうまくいくかどうかは配列のサイズに依存します。たとえば、第 1 次元のサイズが奇数なら、

```jldoctest
julia> A = reshape(1:5*2, 5, 2)
5×2 reshape(::UnitRange{Int64}, 5, 2) with eltype Int64:
 1   6
 2   7
 3   8
 4   9
 5  10

julia> diff(A[2:2:4,:][:])
3-element Vector{Int64}:
 2
 3
 2
```

`A[2:2:4,:]` のストライドは一定ではなくなるため、効率的な線形インデックス指定を保証できません。この判定は `SubArray` のパラメーターに符号化された型だけに基づいて行う必要があるため、`S = view(A, 2:2:4, :)` では効率的な線形インデックス指定を実装できません。

### A few details

  * `Base.reindex` 関数は、入力インデックスの型に依存しません。格納されたインデックスをどのように、どこで再インデックスするかを決めるだけです。整数インデックスだけでなく、非スカラーのインデックスにも対応しています。そのため、ビューのビューであっても、2 段階の間接参照は不要で、元の親配列に対するインデックスを再計算するだけで済みます。
  * ここまで読めば、スライスに対応する場合、パラメーター `N` で表される次元数は、親配列の次元数や `indices` タプルの長さと必ずしも一致しないことが分かるでしょう。また、ユーザーが指定したインデックスが `indices` タプルの要素と必ずしも対応するわけではありません（たとえば、ユーザーが指定した 2 番目のインデックスが親配列の第 3 次元に対応し、`indices` タプルの 3 番目の要素に対応する場合があります）。

    それほど明らかではない点として、格納された親配列の次元数は、`indices` タプル内の有効なインデックスの数と等しくなければなりません。例をいくつか示します。

    ```julia
    A = reshape(1:35, 5, 7) # A 2d parent Array
    S = view(A, 2:7)         # A 1d view created by linear indexing
    S = view(A, :, :, 1:1)   # Appending extra indices is supported
    ```

    単純に `S.parent = A` と `S.indices = (:,:,1:1)` を設定すればよいと思うかもしれません。しかし、これに対応すると再インデックス処理が大幅に複雑になり、特にビューのビューで問題になります。格納されたインデックスの型に基づいてディスパッチするだけでなく、各インデックスが最後のものかどうかを調べ、残りの格納インデックスをまとめる必要があります。これは容易ではありません。さらに、線形インデックス指定に暗黙的に依存するため、処理も遅くなります。

    幸い、まさにこの計算を `ReshapedArray` が行い、可能な場合は線形時間で処理します。そのため、`view` は必要に応じて親配列を再形成し、指定されたインデックスに適した次元数にします。内部の `SubArray` コンストラクターは、この不変条件が満たされることを保証します。
  * [`CartesianIndex`](@ref) とその配列は、`reindex` の仕組みに厄介な問題を持ち込みます。`reindex` は、格納されたインデックスの型に基づいてディスパッチし、渡されたインデックスをいくつ使い、どこに適用するかを決めるだけです。しかし、`CartesianIndex` では、渡された引数の数と、それらがインデックス指定する次元数が一対一に対応しなくなります。先ほどの `Base.reindex(S1, S1.indices, (i, j))` の例に戻ると、`i, j = CartesianIndex(), CartesianIndex(2,1)` では展開が正しくないことが分かります。`CartesianIndex()` を完全に*飛ばして*、次のように返すべきです。

    ```julia
    (CartesianIndex(2,1)[1], S1.indices[2], S1.indices[3][CartesianIndex(2,1)[2]])
    ```

    ところが、実際には次のようになります。

    ```julia
    (CartesianIndex(), S1.indices[2], S1.indices[3][CartesianIndex(2,1)])
    ```

    これを正しく処理するには、扱いきれないほど多くの次元数の組み合わせについて、格納されたインデックスと渡されたインデックスの両方に基づく*複合ディスパッチ*が必要になります。そのため、`reindex` を `CartesianIndex` インデックスとともに呼び出してはいけません。幸い、スカラーの場合は、まず `CartesianIndex` 引数を通常の整数に平坦化すれば簡単に処理できます。一方、`CartesianIndex` の配列は、直交する部分に簡単に分割できません。`reindex` を使う前に、`view` は引数リストに `CartesianIndex` の配列が含まれていないことを確認する必要があります。含まれている場合は、`reindex` の計算を完全に避け、間接参照が 2 段階になるネストした `SubArray` を構築すればよいのです。
