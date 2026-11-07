`BroadcastStyle`は、ブロードキャスト時のオブジェクトの振る舞いを決定するために使われる抽象型およびトレイト関数です。`BroadcastStyle(typeof(x))`は、`x`に対応するスタイルを返します。型のブロードキャスト時の振る舞いをカスタマイズするには、型とメソッドの組を定義してスタイルを宣言します。

```julia
struct MyContainerStyle <: BroadcastStyle end
Base.BroadcastStyle(::Type{<:MyContainer}) = MyContainerStyle()
```

次に、`Broadcasted{MyContainerStyle}`を対象とするメソッド（少なくとも[`similar`](@ref)）を記述します。また、活用できる可能性のある、あらかじめ定義された`BroadcastStyle`のサブタイプもいくつかあります。詳しくは[Interfaces chapter](@ref man-interfaces-broadcasting)を参照してください。
