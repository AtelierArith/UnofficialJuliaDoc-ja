```julia
AbstractPipe
```

`AbstractPipe` は、他の IO オブジェクトのパススルーラッパーを作成するための便利さのために存在する抽象スーパタイプであり、あなたの型に関連する追加のメソッドを実装するだけで済みます。サブタイプは、次のメソッドのいずれか一方または両方を実装する必要があります：

```julia
struct P <: AbstractPipe; ...; end
pipe_reader(io::P) = io.out
pipe_writer(io::P) = io.in
```

`pipe isa AbstractPipe` の場合、次のインターフェースに従う必要があります：

  * `pipe.in` または `pipe.in_stream` が存在する場合、`IO` 型でなければならず、パイプへの入力を提供するために使用されます
  * `pipe.out` または `pipe.out_stream` が存在する場合、`IO` 型でなければならず、パイプからの出力に使用されます
  * `pipe.err` または `pipe.err_stream` が存在する場合、`IO` 型でなければならず、パイプからのエラーを書き込むために使用されます
