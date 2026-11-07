# External Profiler Support

Julia は、一部の外部トレースプロファイラーを明示的にサポートしており、ランタイムの実行動作を高いレベルから把握できます。

現在サポートされているプロファイラーは次のとおりです。

  * [Tracy](https://github.com/wolfpld/tracy)
  * [Intel VTune (ITTAPI)](https://github.com/intel/ittapi)
  * [NVIDIA Nsight Systems (NVTX)](#NVIDIA-Nsight-Systems-(NVTX))

### Adding New Zones

#### From C/C++ code

ゾーンを追加するには、`JL_TIMING` マクロを使用します。コードベース内で `JL_TIMING` を検索すると、多数の使用例が見つかります。新しい種類のゾーンを追加するには、`JL_TIMING_OWNERS`（必要に応じて `JL_TIMING_EVENTS` も）に追加します。

#### From Julia code

`Compiler.@zone` マクロを使うと、Julia コードからゾーンを追加できます。次のように使用します。

```julia
Compiler.@zone "ZONE NAME" begin
    ...
end
```

### Dynamically Enabling and Disabling Zones

[`JULIA_TIMING_SUBSYSTEMS`](@ref JULIA_TIMING_SUBSYSTEMS) 環境変数を使うと、特定の Julia 実行におけるゾーンの有効・無効を切り替えられます。たとえば、この変数に `+GC,-INFERENCE` を設定すると、`GC` ゾーンが有効になり、`INFERENCE` ゾーンが無効になります。

## Tracy Profiler

[Tracy](https://github.com/wolfpld/tracy) は、Julia にオプションで統合できる柔軟なプロファイラーです。

Tracy の一般的なセッションは、次のようになります。

![Tracy の一般的な使用例](tracy.png)

### Building Julia with Tracy

Tracy との統合を有効にするには、`Make.user` ファイルで追加オプション `WITH_TRACY=1` を指定して Julia をビルドします。

### Installing the Tracy Profile Viewer

プロファイルビューアーを入手する最も簡単な方法は、`TracyProfiler_jll` パッケージを追加し、次のコマンドでプロファイラーを起動することです。

```julia
run(TracyProfiler_jll.tracy())
```

!!! note
    macOS では、プロファイラーの UI 要素が大きく表示されすぎる場合、`TRACY_DPI_SCALE` 環境変数に `1.0` を設定するとよいでしょう。


トレースをディスクに保存する「ヘッドレス」インスタンスを実行するには、代わりに次を使用します。

```julia
run(`$(TracyProfiler_jll.capture()) -o mytracefile.tracy`)
```

Tracy UI の使い方については、Tracy のマニュアルを参照してください。

### Profiling Julia with Tracy

Tracy を使って Julia をプロファイリングする一般的な手順では、次のコマンドで Julia を起動します。

```julia
JULIA_WAIT_FOR_TRACY=1 ./julia -e '...'
```

この環境変数を設定すると、Tracy プロファイラーへの接続が成功するまで Julia は実行を待機します。その後、Tracy プロファイラーの UI で `Connect` をクリックすると、Julia の実行が再開し、プロファイリングが始まります。

### Profiling package precompilation with Tracy

パッケージのプリコンパイル処理をプロファイリングするには、プリコンパイルしたいパッケージを指定して `Base.compilecache` を明示的に呼び出すのが最も簡単です。

```julia
pkg = Base.identify_package("SparseArrays")
withenv("JULIA_WAIT_FOR_TRACY" => 1, "TRACY_PORT" => 9001) do
    Base.compilecache(pkg)
end
```

ここでは Tracy にカスタムポートを指定しています。これにより、Tracy UI で接続先のクライアントを見つけやすくなります。

### Adding metadata to zones

各種 `jl_timing_show_*` 関数と `jl_timing_printf` 関数を使うと、ゾーンに文字列（複数可）を付加できます。たとえば、推論のトレースゾーンには、推論中のメソッドインスタンスが表示されます。

`TracyCZoneColor` 関数を使うと、特定のゾーンの色を設定できます。使い方はコードベース内を検索してください。

### Viewing Tracy files in your browser

Tracy のトレースを表示する（実験的な）Web ビューアーについては、https://topolarity.github.io/trace-viewer/ をご覧ください。

ローカルの `.tracy` ファイルを開くか、Web 上の URL（GitHub リポジトリ内のファイルなど）を指定できます。Web 上のトレースファイルを読み込んだ場合は、ページの URL を他の人と直接共有して、同じトレースを見てもらうこともできます。

### Enabling stack trace samples

Tracy でコールスタックのサンプリングを有効にするには、`Make.user` ファイルで次のオプションを指定して Julia をビルドします。

```
WITH_TRACY := 1
WITH_TRACY_CALLSTACKS := 1
USE_BINARYBUILDER_LIBTRACYCLIENT := 0
```

Tracy を強制的に再ビルドするために、`make -C deps clean-libtracyclient` の実行も必要になる場合があります。

この機能を有効にすると、トレースのサイズとプロファイリングのオーバーヘッドが大幅に増加します。そのため、可能な限りコールスタックのサンプリングは無効にしておくことをおすすめします。特に、トレースファイルをオンラインで共有する場合は注意してください。

Julia の JIT ランタイムは、Tracy のシンボル解決にまだ対応していません。そのため、スタックトレースでは通常、Julia の関数は不明として表示されます。

## Intel VTune (ITTAPI) Profiler

*このセクションはまだ執筆されていません。*

## NVIDIA Nsight Systems (NVTX)

[NVTX](https://github.com/NVIDIA/NVTX) は、イベント、コード範囲、リソースに注釈を付け、NVIDIA のプロファイリングツールで可視化できるようにする、NVIDIA の軽量なインストルメンテーション API です。Julia は、Tracy および ITTAPI で使用されるものと同じ `JL_TIMING` ゾーンを NVTX の範囲として出力します。これらはサブシステムごとにグループ化・色分けされ、[NVIDIA Nsight Systems](https://developer.nvidia.com/nsight-systems) で表示できます。

NVTX はヘッダーのみで構成されており、ツールが接続してキャプチャしている場合を除き、呼び出しは低コストの no-op です。そのため、NVTX サポートを有効にしてビルドしても CUDA ツールキットのインストールは不要で、プロファイラーが接続されていない場合のオーバーヘッドも最小限です。

### Building Julia with NVTX support

Julia ランタイムの NVTX インストルメンテーションを有効にするには、`Make.user` ファイルで追加オプション `WITH_NVTX := 1` を指定して Julia をビルドするか、コマンドラインから `make ... WITH_NVTX=1` を指定します。

### Profiling Julia with Nsight Systems

[Nsight Systems](https://developer.nvidia.com/nsight-systems) をインストールすると、コマンドラインから `nsys` を使ってトレースを記録できます。

```
nsys profile -o my_julia_trace ./julia -e '...'
```

生成された `my_julia_trace.nsys-rep` ファイルを Nsight Systems UI で開くと、タイムラインの NVTX 行に Julia のタイミングゾーンが表示されます。ゾーンは Tracy の場合と同様に、サブシステムごとにグループ化・色分けされます。

### Instrumenting arbitrary Julia code

Julia コードにカスタムマーカーも追加したい場合は、[`NVTX.jl`](https://github.com/JuliaGPU/NVTX.jl) を参照してください。これは `WITH_NVTX=1` ビルドオプションとは独立して動作します。前述のとおり、Nsight Systems プロファイラーも引き続き使用できます。
