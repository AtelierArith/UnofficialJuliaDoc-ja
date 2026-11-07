```julia
AbstractPipe
```

`AbstractPipe`は、他のIOオブジェクトを透過的にラップするラッパーを作成しやすくするための抽象スーパータイプです。そのため、型に関係する追加のメソッドだけを実装すれば済みます。サブタイプで実装が必要なのは、次のメソッドの一方または両方だけです。

```julia
struct P <: AbstractPipe; ...; end
pipe_reader(io::P) = io.out
pipe_writer(io::P) = io.in
```

`pipe isa AbstractPipe`の場合、次のインターフェースに従う必要があります。

  * `pipe.in`または`pipe.in_stream`が存在する場合、その型は`IO`でなければならず、パイプへの入力に使用されます。
  * `pipe.out`または`pipe.out_stream`が存在する場合、その型は`IO`でなければならず、パイプからの出力に使用されます。
  * `pipe.err`または`pipe.err_stream`が存在する場合、その型は`IO`でなければならず、パイプからのエラーの書き込みに使用されます。
