```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Artifacts/docs/src/index.md"
```

# Artifacts

```@meta
DocTestSetup = :(using Artifacts)
```

Julia 1.6以降、アーティファクトのサポートは`Pkg.jl`からJulia本体に移行しました。ここに適切なドキュメントが追加されるまでは、アーティファクトについて`Pkg.jl`マニュアルの['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'P': ASCII/Unicode U+0050 (category Lu: Letter, uppercase)'k': ASCII/Unicode U+006B (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'v': ASCII/Unicode U+0076 (category Ll: Letter, lowercase)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)](https://julialang.github.io/Pkg.jl/v1/artifacts/)で詳しく確認できます。

!!! compat "Julia 1.6"
    JuliaのアーティファクトAPIを利用するには、Julia 1.6以降が必要です。Julia 1.3〜1.5では、代わりに`Pkg.Artifacts`を使用できます。


```@docs
Artifacts.artifact_meta
Artifacts.artifact_hash
Artifacts.find_artifacts_toml
Artifacts.@artifact_str
Artifacts.artifact_exists
Artifacts.artifact_path
Artifacts.select_downloadable_artifacts
```
