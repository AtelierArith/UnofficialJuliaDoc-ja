`BroadcastStyle`は、ブロードキャスト時のオブジェクトの動作を決定するために使用される抽象型およびトレイト関数です。`BroadcastStyle(typeof(x))`は、`x`に関連付けられたスタイルを返します。型のブロードキャスト動作をカスタマイズするには、型/メソッドペアを定義することでスタイルを宣言できます。

```
struct MyContainerStyle <: BroadcastStyle end
Base.BroadcastStyle(::Type{<:MyContainer}) = MyContainerStyle()
```

次に、`Broadcasted{MyContainerStyle}`に対して動作するメソッド（少なくとも[`similar`](@ref)）を書く必要があります。また、利用できるいくつかの事前定義された`BroadcastStyle`のサブタイプもあります。詳細については、[Interfaces chapter](@ref man-interfaces-broadcasting)を参照してください。
