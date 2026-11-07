```julia
bind_artifact!(artifacts_toml::String, name::String, hash::SHA1;
                platform::Union{AbstractPlatform,Nothing} = nothing,
                download_info::Union{Vector{Tuple},Nothing} = nothing,
                lazy::Bool = false,
                force::Bool = false)
```

指定された`(Julia)Artifacts.toml`ファイル内に、`name`から`hash`へのマッピングを書き込みます。`platform`が`nothing`でない場合、このアーティファクトはプラットフォーム固有としてマークされ、複数のマッピングを持つことになります。同じ名前で、`platform`と`hash`が異なるアーティファクトを、同じ`artifacts_toml`内で複数バインドすることは有効です。`force`が`true`に設定されている場合、既存のマッピングは上書きされます。そうでない場合はエラーが発生します。

`download_info`は、URLとハッシュのタプルを格納する省略可能なベクトルです。これらのURLは、このアーティファクトの取得先候補として一覧表示されます。`lazy`が`true`に設定されている場合、ダウンロード情報があっても、`artifact"name"`構文を使ってアクセスするか、`ensure_artifact_installed()`を呼び出すまで、このアーティファクトはダウンロードされません。
