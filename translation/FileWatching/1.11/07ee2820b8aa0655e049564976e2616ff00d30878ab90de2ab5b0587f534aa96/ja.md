```julia
watch_file(path::AbstractString, timeout_s::Real=-1)
```

ファイルまたはディレクトリ `path` を監視し、変更が発生するか、`timeout_s` 秒が経過するまで待機します。この関数はファイルシステムをポーリングするのではなく、OSから通知を受け取るためのプラットフォーム固有の機能（Linuxのinotifyなど）を使用します。詳しくは、以下にリンクされているNodeJSのドキュメントを参照してください。

戻り値は、ファイルの監視結果を示すブール値フィールド `renamed`、`changed`、`timedout` を持つオブジェクトです。

この関数の動作は、プラットフォームによって若干異なります。詳しくは ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'#': ASCII/Unicode U+0023 (category Po: Punctuation, other)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'_': ASCII/Unicode U+005F (category Pc: Punctuation, connector)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'v': ASCII/Unicode U+0076 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)](https://nodejs.org/api/fs.html#fs_caveats) を参照してください。

この関数は、[`FileMonitor`](@ref) 上で `wait` を呼び出す薄いラッパーです。連続して `watch_file` を呼び出す間には小さな競合ウィンドウがあり、その間にファイルが変更されても検出されない可能性があります。この競合を避けるには、次を直接使用してください。

```julia
fm = FileMonitor(path)
wait(fm)
```

同じ `fm` を再利用しながら、毎回 `wait` を実行してください。
