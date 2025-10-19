# SubArrays

Juliaの`SubArray`型は、親[`AbstractArray`](@ref)の「ビュー」をエンコードするコンテナです。このページでは、`SubArray`の設計原則と実装のいくつかを文書化しています。

主要なデザイン目標の1つは、[`IndexLinear`](@ref) および [`IndexCartesian`](@ref) 配列のビューに対して高いパフォーマンスを確保することです。さらに、`IndexLinear` 配列のビューは、可能な限り `IndexLinear` であるべきです。

## Index replacement

3D配列の2Dスライスを作成することを考えてみましょう：

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

`view` は「シングルトン」次元（`Int` で指定されたもの）を削除するため、`S1` と `S2` はどちらも二次元の `SubArray` です。したがって、これらをインデックス付けする自然な方法は `S1[i,j]` です。親配列 `A` から値を抽出するための自然なアプローチは、`S1[i,j]` を `A[i,1,(2:3)[j]]` に置き換え、`S2[i,j]` を `A[1,i,(2:3)[j]]` に置き換えることです。

SubArraysのデザインの重要な特徴は、このインデックスの置き換えがランタイムオーバーヘッドなしで実行できることです。

## SubArray design

### Type parameters and fields

採用された戦略は、まず第一にタイプの定義に表現されています：

```julia
struct SubArray{T,N,P,I,L} <: AbstractArray{T,N}
    parent::P
    indices::I
    offset1::Int       # for linear indexing and pointer, only valid when L==true
    stride1::Int       # used only for linear indexing
    ...
end
```

`SubArray` には 5 つの型パラメータがあります。最初の 2 つは標準の要素型と次元数です。次は親 `AbstractArray` の型です。最も頻繁に使用されるのは 4 番目のパラメータで、各次元のインデックスの型の `Tuple` です。最後の `L` は、ディスパッチの便宜のためにのみ提供されます。これは、インデックス型が高速な線形インデックスをサポートしているかどうかを表すブール値です。詳細は後で説明します。

もし上記の例で `A` が `Array{Float64, 3}` の場合、上記の `S1` のケースは `SubArray{Float64,2,Array{Float64,3},Tuple{Base.Slice{Base.OneTo{Int64}},Int64,UnitRange{Int64}},false}` になります。特に、`S1` を作成するために使用されるインデックスの型を格納するタプルパラメータに注意してください。同様に、

```jldoctest subarray
julia> S1.indices
(Base.Slice(Base.OneTo(2)), 1, 2:3)
```

これらの値を保存することでインデックスの置き換えが可能になり、型をパラメータとしてエンコードすることで効率的なアルゴリズムにディスパッチすることができます。

### Index translation

インデックス変換を行うには、異なる具体的な `SubArray` タイプに対して異なる処理を行う必要があります。例えば、`S1` の場合、`i,j` インデックスを親配列の最初と第三の次元に適用する必要がありますが、`S2` の場合はそれらを第二と第三の次元に適用する必要があります。インデックス付けの最も簡単なアプローチは、ランタイムで型分析を行うことです：

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

残念ながら、これはパフォーマンスの面で壊滅的な結果をもたらすでしょう：各要素へのアクセスはメモリを割り当て、型が不適切なコードが多く実行されることになります。

より良いアプローチは、各タイプの保存されたインデックスを処理するために特定のメソッドにディスパッチすることです。これが `reindex` の役割です：最初の保存されたインデックスのタイプに基づいてディスパッチし、適切な数の入力インデックスを消費し、その後、残りのインデックスに対して再帰します。`S1` の場合、これは次のように展開されます。

```julia
Base.reindex(S1, S1.indices, (i, j)) == (i, S1.indices[2], S1.indices[3][j])
```

任意のインデックスのペア `(i,j)` に対して（[`CartesianIndex`](@ref) とその配列を除く、下記参照）。

これは `SubArray` のコアであり、インデックス付けメソッドはこのインデックス変換を行うために `reindex` に依存しています。しかし、時には間接参照を避けて、さらに高速化することができます。

### Linear indexing

線形インデックスは、配列全体が連続する要素を分ける単一のストライドを持ち、あるオフセットから始まる場合に効率的に実装できます。これは、これらの値を事前に計算し、線形インデックスを単純に加算と乗算として表現できることを意味し、`reindex`の間接参照や（より重要なことに）デカルト座標の遅い計算を完全に回避します。

`SubArray` 型の効率的な線形インデックスの利用可能性は、インデックスの型のみに基づいており、親配列のサイズのような値には依存しません。特定のインデックスのセットが高速な線形インデックスをサポートしているかどうかは、内部の `Base.viewindexing` 関数を使用して確認できます。

```jldoctest subarray
julia> Base.viewindexing(S1.indices)
IndexCartesian()

julia> Base.viewindexing(S2.indices)
IndexLinear()
```

これは`SubArray`の構築中に計算され、迅速な線形インデックスサポートをエンコードするブール値として`L`型パラメータに格納されます。厳密には必要ではありませんが、これにより`SubArray{T,N,A,I,true}`に直接ディスパッチを定義できるようになります。

この計算はランタイム値に依存しないため、ストライドが均一である場合にいくつかのケースを見逃す可能性があります：

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

`view(A, 2:2:4, :)`として構築されたビューは均一なストライドを持ち、そのため線形インデックスが効率的に実行される可能性があります。しかし、この場合の成功は配列のサイズに依存します：もし最初の次元が奇数であった場合、

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

そのため、`A[2:2:4,:]`は均一なストライドを持たないため、効率的な線形インデックスを保証することはできません。この決定は`SubArray`のパラメータにエンコードされた型のみに基づいているため、`S = view(A, 2:2:4, :)`は効率的な線形インデックスを実装することができません。

### A few details

  * `Base.reindex` 関数は、入力インデックスのタイプに依存しません。これは、保存されたインデックスをどのように、どこで再インデックス化するかを単に決定します。整数インデックスだけでなく、非スカラーインデックスもサポートしています。これは、ビューのビューが二重の間接参照を必要とせず、元の親配列へのインデックスを単に再計算できることを意味します！
  * おそらく今や、スライスをサポートすることは、パラメータ `N` によって与えられる次元数が親配列の次元数や `indices` タプルの長さと必ずしも等しくないことを意味することがかなり明確になっているでしょう。また、ユーザーが提供したインデックスが必ずしも `indices` タプルのエントリと一致するわけではありません（例えば、2番目のユーザー提供インデックスは親配列の3番目の次元に対応し、`indices` タプルの3番目の要素に対応するかもしれません）。

    あまり明らかではないかもしれませんが、保存された親配列の次元は、`indices` タプル内の有効なインデックスの数と等しくなければなりません。いくつかの例:

    ```julia
    A = reshape(1:35, 5, 7) # A 2d parent Array
    S = view(A, 2:7)         # A 1d view created by linear indexing
    S = view(A, :, :, 1:1)   # Appending extra indices is supported
    ```

    素朴に考えると、`S.parent = A` と `S.indices = (:,:,1:1)` を設定するだけで済むと思うかもしれませんが、これをサポートすることは再インデックス処理を劇的に複雑にします。特にビューのビューの場合はそうです。保存されたインデックスの型に基づいてディスパッチする必要があるだけでなく、特定のインデックスが最終のものであるかどうかを調べ、残りの保存されたインデックスを「マージ」する必要があります。これは簡単な作業ではなく、さらに悪いことに、線形インデックスに暗黙的に依存しているため遅くなります。

    幸いなことに、これはまさに `ReshapedArray` が行う計算であり、可能であれば線形に行います。その結果、`view` は、必要に応じて親配列を与えられたインデックスに対して適切な次元に再形成することによって、親配列が適切な次元であることを保証します。内部の `SubArray` コンストラクタは、この不変条件が満たされることを保証します。
  * [`CartesianIndex`](@ref) とその配列は `reindex` スキームに厄介な問題を引き起こします。`reindex` は、格納されたインデックスの型に基づいて、どれだけの引数が渡されるべきか、そしてそれらがどこに配置されるべきかを決定します。しかし、`CartesianIndex` では、渡された引数の数と、それらがインデックスを付ける次元の数との間に一対一の対応がなくなります。上記の例 `Base.reindex(S1, S1.indices, (i, j))` に戻ると、`i, j = CartesianIndex(), CartesianIndex(2,1)` の場合、展開が不正であることがわかります。`CartesianIndex()` を完全に *スキップ* し、次のように返すべきです:

    ```julia
    (CartesianIndex(2,1)[1], S1.indices[2], S1.indices[3][CartesianIndex(2,1)[2]])
    ```

    その代わりに、私たちは次のようになります：

    ```julia
    (CartesianIndex(), S1.indices[2], S1.indices[3][CartesianIndex(2,1)])
    ```

    これを正しく行うには、すべての次元の組み合わせにわたって保存されたインデックスと渡されたインデックスの*組み合わせ*ディスパッチが必要です。そのため、`reindex`は`CartesianIndex`インデックスで呼び出されるべきではありません。幸いなことに、スカラーケースは`CartesianIndex`引数を単純な整数にフラット化することで簡単に処理できます。しかし、`CartesianIndex`の配列は、簡単に直交する部分に分割することはできません。`reindex`を使用しようとする前に、`view`は引数リストに`CartesianIndex`の配列が含まれていないことを確認する必要があります。もし含まれている場合は、`reindex`計算を完全に回避して、2レベルの間接参照を持つネストされた`SubArray`を構築することで「パント」することができます。
