# [Arrays with custom indices](@id man-custom-indices)

従来、Juliaの配列は1からインデックスが始まりますが、他のいくつかの言語は0から番号を付け始め、さらに他の言語（例：Fortran）は任意の開始インデックスを指定することを許可しています。標準を選ぶことには多くの利点があります（つまり、Juliaの場合は1）。しかし、`1:size(A,d)`の範囲外でインデックスを付けることができると、かなり簡素化されるアルゴリズムもあります（`0:size(A,d)-1`だけではありません）。そのような計算を容易にするために、Juliaは任意のインデックスを持つ配列をサポートしています。

このページの目的は、「自分のコードでそのような配列をサポートするために何をしなければならないのか？」という質問に答えることです。まず、最も単純なケースに対処しましょう：もしあなたのコードが非慣習的なインデックスを持つ配列を扱う必要がないことが分かっているなら、答えは「何もしない」であることを願っています。従来の配列を使用している限り、古いコードは基本的に変更なしで機能するはずです。インデックスが1から始まる従来の配列をユーザーに強制する方が便利だと感じる場合は、次のように追加できます。

```julia
Base.require_one_based_indexing(arrays...)
```

`arrays...` は、1-based インデックスに違反するものがないか確認したい配列オブジェクトのリストです。

## Generalizing existing code

概要として、手順は次のとおりです：

  * `size`の多くの使用を`axes`に置き換えます。
  * `1:length(A)` を `eachindex(A)` に置き換えるか、場合によっては `LinearIndices(A)` に置き換えてください。
  * 明示的な割り当てを `Array{Int}(undef, size(B))` から `similar(Array{Int}, axes(B))` に置き換えます。

これらは以下でより詳細に説明されています。

### Things to watch out for

なぜ非標準のインデックス付けが多くの人々の「すべての配列は1からインデックスが始まる」という仮定を壊すのか、常にそのような配列を使用することでエラーが発生する可能性があります。最も厄介なバグは、不正確な結果やセグメンテーションフォルト（Juliaの完全なクラッシュ）です。例えば、次の関数を考えてみましょう：

```julia
function mycopy!(dest::AbstractVector, src::AbstractVector)
    length(dest) == length(src) || throw(DimensionMismatch("vectors must match"))
    # OK, now we're safe to use @inbounds, right? (not anymore!)
    for i = 1:length(src)
        @inbounds dest[i] = src[i]
    end
    dest
end
```

このコードは、ベクトルが1からインデックス付けされていることを暗黙的に前提としています。もし `dest` が `src` とは異なるインデックスから始まる場合、このコードがセグメンテーションフォルトを引き起こす可能性があります。（セグメンテーションフォルトが発生した場合、原因を特定するために `--check-bounds=yes` オプションを使ってジュリアを実行してみてください。）

### Using `axes` for bounds checks and loop iteration

`axes(A)`（`size(A)`を思い起こさせる）は、`A`の各次元に沿った有効なインデックスの範囲を指定する`AbstractUnitRange{<:Integer}`オブジェクトのタプルを返します。`A`が非標準のインデックスを持つ場合、範囲は1から始まらないことがあります。特定の次元`d`の範囲だけが必要な場合は、`axes(A, d)`があります。

Baseはカスタム範囲タイプ`OneTo`を実装しており、`OneTo(n)`は`1:n`と同じ意味ですが、タイプシステムによって下限インデックスが1であることが保証されています。新しい[`AbstractArray`](@ref)タイプに対して、これは`axes`によって返されるデフォルトであり、この配列タイプが「従来の」1ベースのインデックスを使用していることを示しています。

境界チェックのために、`checkbounds` と `checkindex` という専用の関数があり、これらは時々そのようなテストを簡素化することができます。

### Linear indexing (`LinearIndices`)

いくつかのアルゴリズムは、`A[i]`という単一の線形インデックスの観点から最も便利（または効率的）に記述されます。`A`が多次元であっても関係ありません。配列のネイティブインデックスに関係なく、線形インデックスは常に`1:length(A)`の範囲になります。しかし、これは一次元配列（別名、[`AbstractVector`](@ref)）に対して曖昧さを引き起こします：`v[i]`は線形インデックスを意味するのか、それとも配列のネイティブインデックスを用いたカーテシアンインデックスを意味するのか？

この理由から、最良の選択肢は `eachindex(A)` を使って配列を反復処理することか、またはインデックスを連続した整数にする必要がある場合は `LinearIndices(A)` を呼び出してインデックス範囲を取得することです。これにより、AがAbstractVectorである場合は `axes(A, 1)` が返され、それ以外の場合は `1:length(A)` の同等のものが返されます。

この定義によれば、1次元配列は常に配列のネイティブインデックスを使用したデカルトインデックスを使用します。これを強調するために、インデックス変換関数は、形状が非標準のインデックスを持つ1次元配列を示す場合（すなわち、`Tuple{UnitRange}`であり、`OneTo`のタプルではない場合）にエラーをスローすることに注意する価値があります。標準的なインデックスを持つ配列の場合、これらの関数は従来通りに機能し続けます。

`axes` と `LinearIndices` を使用して、`mycopy!` を次のように書き換えることができます：

```julia
function mycopy!(dest::AbstractVector, src::AbstractVector)
    axes(dest) == axes(src) || throw(DimensionMismatch("vectors must match"))
    for i in LinearIndices(src)
        @inbounds dest[i] = src[i]
    end
    dest
end
```

### Allocating storage using generalizations of `similar`

ストレージは通常、`Array{Int}(undef, dims)` または `similar(A, args...)` を使用して割り当てられます。結果が他の配列のインデックスと一致する必要がある場合、これだけでは不十分なことがあります。このようなパターンの一般的な置き換えは、`similar(storagetype, shape)` を使用することです。`storagetype` は、希望する基礎的な「従来の」動作の種類を示します。例えば、`Array{Int}` や `BitArray`、あるいは `dims->zeros(Float32, dims)`（これはすべてゼロの配列を割り当てます）などです。`shape` は、結果が使用するインデックスを指定する [`Integer`](@ref) または `AbstractUnitRange` の値のタプルです。Aのインデックスと一致するすべてゼロの配列を生成する便利な方法は、単に `zeros(A)` を使用することです。

いくつかの明示的な例を見ていきましょう。まず、`A`が従来のインデックスを持つ場合、`similar(Array{Int}, axes(A))`は`Array{Int}(undef, size(A))`を呼び出し、したがって配列を返します。`A`が非従来型のインデックスを持つ`AbstractArray`タイプである場合、`similar(Array{Int}, axes(A))`は`Array{Int}`のように「振る舞う」ものを返すべきですが、形状（インデックスを含む）が`A`に一致します。（最も明白な実装は、`Array{Int}(undef, size(A))`を割り当ててから、インデックスをシフトする型で「ラップ」することです。）

`similar(Array{Int}, (axes(A, 2),))`は、`A`の列のインデックスに一致する`AbstractVector{Int}`（すなわち1次元配列）を割り当てることにも注意してください。

## Writing custom array types with non-1 indexing

必要なメソッドのほとんどは、任意の `AbstractArray` タイプに対して標準的なものであり、[Abstract Arrays](@ref man-interface-array) を参照してください。このページでは、非従来型インデックスを定義するために必要な手順に焦点を当てています。

### Custom `AbstractUnitRange` types

非1インデックス配列タイプを作成している場合、`axes`を特化させて`UnitRange`を返すようにするか、（おそらくより良い方法として）カスタムの`AbstractUnitRange`を返すようにしたいでしょう。カスタムタイプの利点は、`similar`のような関数に対するアロケーションタイプを「シグナル」することです。インデックスが0から始まる配列タイプを作成している場合、`AbstractUnitRange`の新しい`ZeroRange`を作成することから始めるのが望ましいでしょう。ここで、`ZeroRange(n)`は`0:n-1`に相当します。

一般的に、あなたのパッケージから `ZeroRange` をエクスポートしない方が良いでしょう。他のパッケージが独自の `ZeroRange` を実装している可能性があり、異なる `ZeroRange` タイプが複数存在することは（直感に反して）利点です：`ModuleA.ZeroRange` は `similar` が `ModuleA.ZeroArray` を作成すべきであることを示し、`ModuleB.ZeroRange` は `ModuleB.ZeroArray` タイプを示します。この設計により、多くの異なるカスタム配列タイプが平和的に共存できるようになります。

注意してください。Juliaパッケージ [CustomUnitRanges.jl](https://github.com/JuliaArrays/CustomUnitRanges.jl) は、独自の `ZeroRange` タイプを書く必要を回避するために時々使用できます。

### Specializing `axes`

`AbstractUnitRange`型を取得したら、次に`axes`を特化させます:

```julia
Base.axes(A::ZeroArray) = map(n->ZeroRange(n), A.size)
```

ここでは、`ZeroArray` に `size` というフィールドがあると想定しています（これを実装する他の方法もあります）。

`axes(A, d)`のフォールバック定義は、いくつかのケースで次のようになります：

```julia
axes(A::AbstractArray{T,N}, d) where {T,N} = d <= N ? axes(A)[d] : OneTo(1)
```

あなたが望んでいるものではないかもしれません：`d > ndims(A)` の場合に `OneTo(1)` 以外のものを返すように特化する必要があるかもしれません。同様に、`Base` には `axes1` という専用の関数があり、これは `axes(A, 1)` と同等ですが、`ndims(A) > 0` かどうかを（実行時に）チェックすることを避けます。（これは純粋にパフォーマンスの最適化です。）これは次のように定義されています：

```julia
axes1(A::AbstractArray{T,0}) where {T} = OneTo(1)
axes1(A::AbstractArray) = axes(A)[1]
```

もしこれらの最初のもの（ゼロ次元の場合）があなたのカスタム配列タイプにとって問題がある場合は、適切に特化させることを忘れないでください。

### Specializing `similar`

カスタム `ZeroRange` 型を考慮すると、次の2つの特別化を `similar` に追加する必要があります:

```julia
function Base.similar(A::AbstractArray, T::Type, shape::Tuple{ZeroRange,Vararg{ZeroRange}})
    # body
end

function Base.similar(f::Union{Function,DataType}, shape::Tuple{ZeroRange,Vararg{ZeroRange}})
    # body
end
```

どちらもカスタム配列タイプを割り当てる必要があります。

### Specializing `reshape`

オプションで、メソッドを定義します

```
Base.reshape(A::AbstractArray, shape::Tuple{ZeroRange,Vararg{ZeroRange}}) = ...
```

配列を`reshape`することで、結果にカスタムインデックスを持たせることができます。

### For objects that mimic AbstractArray but are not subtypes

`has_offset_axes` は、呼び出すオブジェクトに `axes` が定義されていることに依存します。オブジェクトに `axes` メソッドが定義されていない理由がある場合は、メソッドを定義することを検討してください。

```julia
Base.has_offset_axes(obj::MyNon1IndexedArraylikeObject) = true
```

これにより、1ベースのインデックスを前提とするコードが問題を検出し、有用なエラーをスローすることができるようになります。これにより、不正確な結果を返したり、セグメンテーションフォルトを引き起こしたりすることがなくなります。

### Catching errors

新しい配列タイプが他のコードでエラーを引き起こす場合、役立つデバッグ手順の一つは、`getindex` と `setindex!` の実装で `@boundscheck` をコメントアウトすることです。これにより、すべての要素アクセスが境界をチェックします。または、`--check-bounds=yes` で Julia を再起動します。

場合によっては、新しい配列タイプの `size` と `length` を一時的に無効にすることが役立つことがあります。なぜなら、誤った仮定をするコードがこれらの関数を頻繁に使用するからです。
