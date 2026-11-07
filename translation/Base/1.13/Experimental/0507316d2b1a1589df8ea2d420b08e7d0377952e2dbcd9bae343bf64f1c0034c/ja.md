```julia
Experimental.@compiler_options optimize={0,1,2,3} compile={yes,no,all,min} infer={true,false} max_methods={default,1,2,3,4}
```

このモジュール内のコードに対するコンパイラーオプションを設定します。該当する場合、各オプションは同名のコマンドラインオプションに直接対応します。現在、次のオプションがサポートされています。

  * `optimize`: 最適化レベルを設定します。
  * `compile`: ネイティブコードのコンパイルを切り替えます。現在サポートされているのは `min` のみで、コンパイル量を可能な限り最小限に抑えるよう指定します。
  * `infer`: 型推論を有効または無効にします。無効にすると、[`@nospecialize`](@ref) が暗黙的に指定されます。
  * `max_methods`: 型推論の実行時に考慮する、条件に一致するメソッドの最大数です。
