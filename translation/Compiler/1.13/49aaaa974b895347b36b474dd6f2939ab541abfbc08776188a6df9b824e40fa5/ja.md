```julia
AbstractInterpreter
```

Juliaコードを実行するメソッドを多重ディスパッチで決定できる抽象基底クラスです。この抽象クラスの具象インスタンスである`NativeInterpreter`を使用すると、標準のJulia-LLVMパイプラインが有効になります。`AbstractInterpreter` APIに準拠していれば、ほかの実装に差し替えることもできます。

`interp::NewInterpreter`が`AbstractInterpreter`の場合、`AbstractInterpreter` APIの要件を満たすため、少なくとも次のメソッドを実装する必要があります。

  * `InferenceParams(interp::NewInterpreter)` — `InferenceParams`インスタンスを返す
  * `OptimizationParams(interp::NewInterpreter)` — `OptimizationParams`インスタンスを返す
  * `get_inference_world(interp::NewInterpreter)` — このインタープリターのワールドエイジを返す
  * `get_inference_cache(interp::NewInterpreter)` — ローカル推論キャッシュを返す
  * `cache_owner(interp::NewInterpreter)` — 新しいキャッシュエントリーの所有者を返す

`interp::NewInterpreter`を使ってコンパイルされた`CodeInstance`を`invoke`で実行する場合は、`codegen_cache(interp::NewInterpreter) -> IdDict{CodeInstance, CodeInfo}`メソッドを定義し、ソースモード`SOURCE_MODE_ABI`を指定して`typeinf_ext_toplevel`経由で推論を実行する必要があります。
