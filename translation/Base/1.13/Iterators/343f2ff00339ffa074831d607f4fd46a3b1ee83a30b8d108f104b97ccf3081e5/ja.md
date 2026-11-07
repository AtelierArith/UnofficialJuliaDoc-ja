```julia
Iterators.reverse(itr)
```

イテレータ `itr` が与えられたとき、`reverse(itr)` は同じコレクションを逆順にたどるイテレータです。このイテレータは、逆順にするためにコレクションのコピーを作成しない「遅延」型です。コピーを作成する実装については、[`Base.reverse`](@ref) を参照してください。

（デフォルトでは、`itr` をラップする `Iterators.Reverse` オブジェクトを返します。このオブジェクトは、対応する [`iterate`](@ref) メソッドが定義されていれば反復可能です。ただし、一部の `itr` 型では、より特化した `Iterators.reverse` の動作が実装されている場合があります。）

すべてのイテレータ型 `T` が逆順の反復をサポートしているわけではありません。`T` がサポートしていない場合、`Iterators.reverse(itr::T)` を反復しようとすると、`Iterators.Reverse{T}` 用の `iterate` メソッドがないため、[`MethodError`](@ref) がスローされます。（これらのメソッドを実装するには、`r::Iterators.Reverse{T}` オブジェクトから `r.itr` によって元のイテレータ `itr::T` を取得できます。より一般的には、`Iterators.reverse(r)` を使用できます。）

# Examples

```jldoctest
julia> foreach(println, Iterators.reverse(1:5))
5
4
3
2
1
```
