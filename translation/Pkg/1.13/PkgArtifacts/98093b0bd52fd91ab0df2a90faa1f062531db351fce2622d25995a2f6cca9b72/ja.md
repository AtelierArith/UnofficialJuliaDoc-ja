```julia
download_artifact(tree_hash::SHA1, tarball_url::String, tarball_hash::String;
                    verbose::Bool = false, io::IO=stderr)
```

アーティファクトをダウンロードしてアーティファクトストアにインストールします。成功すると `true` を返し、失敗するとエラーオブジェクトを返します。

!!! compat "Julia 1.8"
    Julia 1.8 以降では、失敗時に `false` ではなくエラーオブジェクトを返します。

