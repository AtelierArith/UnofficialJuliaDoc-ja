`Broadcast.AbstractArrayStyle{N} <: BroadcastStyle` は、`AbstractArray` 型に関連付けられた任意のスタイルの抽象スーパタイプです。`N` パラメータは次元数であり、特定の次元数のみをサポートする AbstractArray 型に便利です：

```
struct SparseMatrixStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatrixStyle()
```

任意の次元数をサポートする `AbstractArray` 型の場合、`N` は `Any` に設定できます：

```
struct MyArrayStyle <: Broadcast.AbstractArrayStyle{Any} end
Base.BroadcastStyle(::Type{<:MyArray}) = MyArrayStyle()
```

複数の `AbstractArrayStyle` を混ぜて次元数を追跡したい場合、スタイルは [`Val`](@ref) コンストラクタをサポートする必要があります：

```
struct MyArrayStyleDim{N} <: Broadcast.AbstractArrayStyle{N} end
(::Type{<:MyArrayStyleDim})(::Val{N}) where N = MyArrayStyleDim{N}()
```

2つ以上の `AbstractArrayStyle` サブタイプが競合する場合、ブロードキャスト機構は `Array` を生成することにフォールバックします。これが望ましくない場合は、出力型を制御するためにバイナリ [`BroadcastStyle`](@ref) ルールを定義する必要があります。

さらに [`Broadcast.DefaultArrayStyle`](@ref) も参照してください。
