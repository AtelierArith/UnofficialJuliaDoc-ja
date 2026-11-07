`Broadcast.AbstractArrayStyle{N} <: BroadcastStyle`は、`AbstractArray`型に関連付けられるあらゆるスタイルの抽象スーパータイプです。`N`パラメーターは次元数を表します。特定の次元数のみをサポートするAbstractArray型では、これが便利な場合があります。

```julia
struct SparseMatrixStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatrixStyle()
```

任意の次元数をサポートする`AbstractArray`型では、`N`を`Any`に設定できます。

```julia
struct MyArrayStyle <: Broadcast.AbstractArrayStyle{Any} end
Base.BroadcastStyle(::Type{<:MyArray}) = MyArrayStyle()
```

複数の`AbstractArrayStyle`を混在させ、次元数を追跡できるようにしたい場合は、スタイルで[`Val`](@ref)コンストラクターをサポートする必要があります。

```julia
struct MyArrayStyleDim{N} <: Broadcast.AbstractArrayStyle{N} end
(::Type{<:MyArrayStyleDim})(::Val{N}) where N = MyArrayStyleDim{N}()
```

2つ以上の`AbstractArrayStyle`サブタイプが競合すると、ブロードキャスト機構は`Array`を生成するようにフォールバックします。これが望ましくない場合は、出力型を制御するために、二項の[`BroadcastStyle`](@ref)ルールを定義する必要があるかもしれません。

[`Broadcast.DefaultArrayStyle`](@ref)も参照してください。
