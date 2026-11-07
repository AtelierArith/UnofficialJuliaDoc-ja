# [Arrays with custom indices](@id man-custom-indices)

Julia の配列は慣例として 1 からインデックスが始まります。一方、0 から番号を付ける言語もあれば、Fortran のように任意の開始インデックスを指定できる言語もあります。標準（Julia では 1）を定めることには大きな利点がありますが、`1:size(A,d)` の範囲外（`0:size(A,d)-1` だけではありません）をインデックスできると、大幅に簡潔になるアルゴリズムもあります。こうした計算を可能にするため、Julia は任意のインデックスを持つ配列をサポートしています。

このページでは、「自分のコードでこうした配列をサポートするには、何をすればよいか」という疑問に答えます。まず、最も簡単なケースから考えましょう。コードが慣例に沿わないインデックスの配列を扱う必要がないと分かっているなら、答えはおそらく「何もしない」です。Julia のエクスポートされたインターフェースを使っている限り、従来の配列を扱う既存のコードは、ほぼ変更せずに動作するはずです。ユーザーに 1 始まりの従来型配列だけを渡してもらうほうが都合がよければ、次のように記述できます。

```julia
Base.require_one_based_indexing(arrays...)
```

ここで `arrays...` は、1 始まりのインデックスに違反していないか確認する配列オブジェクトのリストです。

## Generalizing existing code

概要として、必要な手順は次のとおりです。

  * `size` の使用箇所の多くを `axes` に置き換える
  * `1:length(A)` を `eachindex(A)` に置き換える。場合によっては `LinearIndices(A)` を使う
  * `Array{Int}(undef, size(B))` のような明示的な割り当てを `similar(Array{Int}, axes(B))` に置き換える

以下で詳しく説明します。

### Things to watch out for

慣例に沿わないインデックスを使うと、すべての配列は 1 から始まるという前提が崩れるため、エラーが発生する可能性があります。特に厄介なのは、誤った結果やセグメンテーション違反（Julia の完全なクラッシュ）につながるバグです。たとえば、次の関数を考えてみましょう。

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

このコードは、ベクトルのインデックスが 1 から始まることを暗黙に前提としています。`dest` の開始インデックスが `src` と異なる場合、このコードでセグメンテーション違反が発生する可能性があります。（セグメンテーション違反が起きた場合は、原因を特定するために、julia をオプション `--check-bounds=yes` 付きで実行してみてください。）

### Using `axes` for bounds checks and loop iteration

`axes(A)`（`size(A)` を思わせる関数）は、`A` の各次元で有効なインデックス範囲を示す、`AbstractUnitRange{<:Integer}` オブジェクトのタプルを返します。`A` が慣例に沿わないインデックスを持つ場合、範囲の開始値は 1 とは限りません。特定の次元 `d` の範囲だけが必要なら、`axes(A, d)` を使えます。

Base には独自の範囲型 `OneTo` が実装されています。`OneTo(n)` は `1:n` と同じ意味ですが、型システムによって下限インデックスが 1 であることが保証されます。新しい [`AbstractArray`](@ref) 型では、`axes` がデフォルトでこの型を返します。これは、その配列型が「慣例どおり」の 1 始まりインデックスを使うことを示します。

境界チェックには、こうしたテストを簡潔にできる専用関数 `checkbounds` と `checkindex` があることにも注意してください。

### Linear indexing (`LinearIndices`)

配列が多次元の `A` であっても、単一の線形インデックス `A[i]` を使って記述するほうが便利、あるいは効率的なアルゴリズムもあります。配列本来のインデックスにかかわらず、線形インデックスの範囲は常に `1:length(A)` です。ただし、1 次元配列（別名 [`AbstractVector`](@ref)）では、曖昧さが生じます。`v[i]` は線形インデックスを意味するのでしょうか。それとも、配列本来のインデックスを使う直交インデックスを意味するのでしょうか。

そのため、最善の方法は `eachindex(A)` で配列を反復処理することかもしれません。インデックスに連続した整数が必要なら、`LinearIndices(A)` を呼び出してインデックス範囲を取得してください。A が AbstractVector の場合は `axes(A, 1)` が返され、それ以外の場合は `1:length(A)` に相当する値が返されます。

この定義では、1 次元配列は常に、配列本来のインデックスを使う直交インデックスを使用します。これを徹底するため、形状が慣例に沿わないインデックスを持つ 1 次元配列を示している場合（つまり、`OneTo` のタプルではなく `Tuple{UnitRange}` である場合）、インデックス変換関数はエラーをスローします。慣例どおりのインデックスを持つ配列では、これらの関数は従来どおり動作します。

`axes` と `LinearIndices` を使うと、`mycopy!` は次のように書き換えられます。

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

ストレージの確保には、`Array{Int}(undef, dims)` や `similar(A, args...)` がよく使われます。しかし、結果のインデックスを別の配列に合わせる必要がある場合、これだけでは不十分なことがあります。こうしたパターンを一般的に置き換えるには、`similar(storagetype, shape)` を使います。`storagetype` は、望ましい「慣例的な」動作の種類を示します。たとえば、`Array{Int}`、`BitArray`、あるいは全要素がゼロの配列を確保する `dims->zeros(Float32, dims)` などです。`shape` は、結果に使わせたいインデックスを指定する [`Integer`](@ref) または `AbstractUnitRange` のタプルです。A と同じインデックスを持つ全要素ゼロの配列を簡単に作るには、`zeros(A)` を使えます。

具体例をいくつか見てみましょう。まず、`A` が慣例どおりのインデックスを持つ場合、`similar(Array{Int}, axes(A))` は最終的に `Array{Int}(undef, size(A))` を呼び出し、配列を返します。`A` が慣例に沿わないインデックスを持つ `AbstractArray` 型の場合、`similar(Array{Int}, axes(A))` は `A` と同じ形状（インデックスを含む）を持ち、`Array{Int}` のように「振る舞う」ものを返す必要があります。（最も分かりやすい実装は、`Array{Int}(undef, size(A))` を確保し、インデックスをずらす型で「ラップ」する方法です。）

また、`similar(Array{Int}, (axes(A, 2),))` は、`A` の列のインデックスに合わせた `AbstractVector{Int}`（つまり 1 次元配列）を確保することにも注意してください。

## Writing custom array types with non-1 indexing

定義が必要となるメソッドの多くは、どの `AbstractArray` 型にも共通するものです。詳しくは [Abstract Arrays](@ref man-interface-array) を参照してください。このページでは、慣例に沿わないインデックスを定義するために必要な手順に焦点を当てます。

### Custom `AbstractUnitRange` types

1 始まりではないインデックスを持つ配列型を作成する場合は、`axes` を特殊化して `UnitRange` を返すようにします。あるいは、独自の `AbstractUnitRange` を返すようにするほうがよいかもしれません。独自の型を使う利点は、`similar` のような関数に、割り当てる型を「知らせる」ことができる点です。インデックスが 0 から始まる配列型を作るなら、まず新しい `AbstractUnitRange`、`ZeroRange` を作成するとよいでしょう。ここで `ZeroRange(n)` は `0:n-1` と同等です。

一般に、パッケージから `ZeroRange` をエクスポートするのは避けたほうがよいでしょう。他のパッケージが独自の `ZeroRange` を実装している可能性があるためです。異なる `ZeroRange` 型が複数存在することは、直感に反するかもしれませんが、むしろ利点になります。`ModuleA.ZeroRange` は、`similar` が `ModuleA.ZeroArray` を作成すべきことを示し、`ModuleB.ZeroRange` は `ModuleB.ZeroArray` 型を示します。この設計により、さまざまな独自配列型が互いに支障なく共存できます。

Julia パッケージ [CustomUnitRanges.jl](https://github.com/JuliaArrays/CustomUnitRanges.jl) を使えば、独自の `ZeroRange` 型を作成せずに済む場合もあります。

### Specializing `axes`

`AbstractUnitRange` 型を作成したら、`axes` を特殊化します。

```julia
Base.axes(A::ZeroArray) = map(n->ZeroRange(n), A.size)
```

ここでは、`ZeroArray` に `size` というフィールドがあるものとします（別の実装方法もあります）。

場合によっては、`axes(A, d)` のフォールバック定義が適切でないことがあります。

```julia
axes(A::AbstractArray{T,N}, d) where {T,N} = d <= N ? axes(A)[d] : OneTo(1)
```

`d > ndims(A)` の場合に `OneTo(1)` 以外を返すよう、特殊化が必要になることがあります。同様に、`Base` には、`axes(A, 1)` と同等でありながら、`ndims(A) > 0` かどうかを実行時に確認しない専用関数 `axes1` があります。（これは純粋な性能最適化です。）定義は次のとおりです。

```julia
axes1(A::AbstractArray{T,0}) where {T} = OneTo(1)
axes1(A::AbstractArray) = axes(A)[1]
```

このうち最初の定義（0 次元の場合）が独自配列型に適さない場合は、適切に特殊化してください。

### Specializing `similar`

独自の `ZeroRange` 型を用意したら、`similar` に対して次の 2 つの特殊化も追加してください。

```julia
function Base.similar(A::AbstractArray, T::Type, shape::Tuple{ZeroRange,Vararg{ZeroRange}})
    # body
end

function Base.similar(f::Union{Function,DataType}, shape::Tuple{ZeroRange,Vararg{ZeroRange}})
    # body
end
```

どちらも、独自の配列型を確保する必要があります。

### Specializing `reshape`

必要に応じて、次のメソッドを定義します。

```
Base.reshape(A::AbstractArray, shape::Tuple{ZeroRange,Vararg{ZeroRange}}) = ...
```

これを使って配列に `reshape` を適用すると、結果に独自のインデックスを持たせることができます。

### For objects that mimic AbstractArray but are not subtypes

`has_offset_axes` を使うには、対象のオブジェクトに対して `axes` が定義されている必要があります。何らかの理由でオブジェクトに `axes` メソッドを定義できない場合は、次のメソッドを定義することを検討してください。

```julia
Base.has_offset_axes(obj::MyNon1IndexedArraylikeObject) = true
```

これにより、1 始まりのインデックスを前提とするコードが問題を検出し、誤った結果を返したり julia がセグメンテーション違反を起こしたりする代わりに、役立つエラーをスローできます。

### Catching errors

新しい配列型を使ったときに他のコードでエラーが発生する場合、デバッグに役立つ方法の一つは、`getindex` と `setindex!` の実装で `@boundscheck` をコメントアウトすることです。これにより、要素へのアクセスごとに境界がチェックされます。または、julia を `--check-bounds=yes` 付きで再起動してください。

新しい配列型では、`size` と `length` を一時的に無効にすると役立つ場合もあります。誤った前提に基づくコードでは、これらの関数がよく使われるためです。
