# [Memory Management and Garbage Collection](@id man-memory-management)

Juliaは、組み込みのガベージコレクタ（GC）を通じて自動メモリ管理を使用します。このセクションでは、Juliaがメモリをどのように管理し、アプリケーションのメモリ使用をどのように構成および最適化できるかについての概要を提供します。

## [Garbage Collection Overview](@id man-gc-overview)

Juliaには以下の特徴を持つガベージコレクタがあります：

  * **非移動**: オブジェクトはガーベジコレクション中にメモリ内で再配置されません
  * **世代的**: 若いオブジェクトは古いものよりも頻繁に収集されます。
  * **並行および部分的に同時**: GCは複数のスレッドを使用し、あなたのプログラムと同時に実行することができます。
  * **ほぼ正確**: GCは純粋なJuliaコードのオブジェクト参照を正確に特定し、CからJuliaを呼び出すユーザーのために保守的なスキャンAPIを提供します。

ガーベジコレクタは、プログラムからもはや到達できないオブジェクトによって使用されているメモリを自動的に回収し、ほとんどの場合、手動でのメモリ管理から解放してくれます。

## [Memory Architecture](@id man-memory-architecture)

Juliaは二層の割り当て戦略を使用しています：

  * **小さなオブジェクト**（現在は≤ 2032バイトですが、変更される可能性があります）：スレッドごとの高速プールアロケータを使用して割り当てられます。
  * **大きなオブジェクト** : システムの `malloc` を通じて直接割り当てられます。

このハイブリッドアプローチは、割り当ての速度とメモリ効率の両方を最適化し、プールアロケータがJuliaプログラムに典型的な多くの小さなオブジェクトのために迅速な割り当てを提供します。

## [System Memory Requirements](@id man-system-memory)

### Swap Space

Juliaのガベージコレクタは、システムに十分なスワップスペースが設定されていることを前提に設計されています。GCは、必要に応じて物理RAMを超えてメモリを割り当てることができると仮定するヒューリスティックを使用しており、オペレーティングシステムの仮想メモリ管理に依存しています。

システムにスワップ領域が限られているか、全くない場合、ガーベジコレクション中にメモリ不足エラーが発生することがあります。そのような場合は、`--heap-size-hint`オプションを使用して、Juliaのメモリ使用量を制限できます。

### Memory Hints

Juliaに使用する最大メモリ量のヒントを提供できます:

```bash
julia --heap-size-hint=4G  # To set the hint to ~4GB
julia --heap-size-hint=50% # or to 50% of physical memory
```

`--heap-size-hint`オプションは、指定された制限に近づいたときにガベージコレクタにより積極的にコレクションをトリガーするよう指示します。これは特に以下の状況で役立ちます：

  * メモリ制限のあるコンテナ
  * スワップスペースのないシステム
  * Juliaのメモリ使用量を制限したい共有システム

この設定は `JULIA_HEAP_SIZE_HINT` 環境変数を介しても行うことができます：

```bash
export JULIA_HEAP_SIZE_HINT=2G
julia
```

## [Multithreaded Garbage Collection](@id man-gc-multithreading)

Juliaのガベージコレクタは、マルチコアシステムでのパフォーマンスを向上させるために複数のスレッドを活用できます。

### GC Thread Configuration

デフォルトでは、Juliaはガーベジコレクションに複数のスレッドを使用します：

  * **マークスレッド**: マークフェーズ中にオブジェクト参照を追跡するために使用されます（デフォルト: 1、計算スレッドが1つだけの場合は共有され、それ以外の場合は計算スレッドの数の半分）
  * **スイープスレッド**: 解放されたメモリの同時スイープに使用されます（デフォルト: 0、無効）

GCスレッドの設定は次のように行えます：

```bash
julia --gcthreads=4,1  # 4 mark threads, 1 sweep thread
julia --gcthreads=8    # 8 mark threads, 0 sweep threads
```

または環境変数を介して：

```bash
export JULIA_NUM_GC_THREADS=4,1
julia
```

### Recommendations

計算集約型ワークロードの場合：

  * 複数のマークスレッドを使用します（デフォルトの設定が通常は適切です）。
  * 割り当てが多いワークロードに対して、1つのスイープスレッドで同時スイープを有効にすることを検討してください。

メモリ集約型のワークロードの場合:

  * GCの中断を減らすために同時スイーピングを有効にします
  * `@time`を使用してGC時間を監視し、それに応じてスレッド数を調整します。

## [Monitoring and Debugging](@id man-gc-monitoring)

### Basic Memory Monitoring

`@time` マクロを使用して、メモリ割り当てとガベージコレクションのオーバーヘッドを確認します:

```julia
julia> @time some_computation()
  2.123456 seconds (1.50 M allocations: 58.725 MiB, 17.17% gc time)
```

### GC Logging

詳細なGCログを有効にして、コレクションパターンを理解します：

```julia
julia> GC.enable_logging(true)
julia> # Run your code
julia> GC.enable_logging(false)
```

このログは、各ガーベジコレクションイベントのタイミングとメモリ統計を記録します。

### Manual GC Control

一般的には推奨されませんが、手動でガーベジコレクションをトリガーすることができます：

```julia
GC.gc()          # Force a garbage collection
GC.enable(false) # Disable automatic GC (use with caution!)
GC.enable(true)  # Re-enable automatic GC
```

**警告**: GCを無効にすると、メモリが枯渇する可能性があります。特定のパフォーマンス測定やデバッグのためにのみ使用してください。

## [Performance Considerations](@id man-gc-performance)

### Reducing Allocations

GCの影響を最小限に抑える最良の方法は、不必要なアロケーションを減らすことです：

  * 可能な場合はインプレース操作を使用してください（例：`x .+= y` の代わりに `x = x + y`）
  * 配列を事前に割り当てて再利用する
  * タイトなループ内で一時オブジェクトを作成するのを避ける
  * 小さく固定サイズの配列には `StaticArrays.jl` の使用を検討してください。

### Memory-Efficient Patterns

  * グローバル変数が型を変更するのを避ける
  * グローバル定数には `const` を使用してください。

### Profiling Memory Usage

メモリ割り当てのプロファイリングとパフォーマンスボトルネックの特定に関する詳細なガイダンスについては、[Profiling](@ref man-profiling) セクションを参照してください。

## [Advanced Configuration](@id man-gc-advanced)

### Integration with System Memory Management

ジュリアは次のような場合に最適に機能します：

  * システムには十分なスワップスペースがあります（推奨：物理RAMの2倍）
  * 仮想メモリが正しく構成されています
  * 他のプロセスは十分なメモリを利用可能にします。
  * コンテナのメモリ制限は `--heap-size-hint` で適切に設定されています。

## [Troubleshooting Memory Issues](@id man-gc-troubleshooting)

### High GC Overhead

ガーベジコレクションに時間がかかりすぎている場合：

1. **割り当て率の削減**: アルゴリズムの改善に注力する
2. **GCスレッドの調整**: 異なる `--gcthreads` 設定で実験する
3. **同時スイーピングを使用する**: `--gcthreads=N,1` でバックグラウンドスイーピングを有効にします。
4. **プロファイルメモリパターン**: アロケーションホットスポットを特定し、最適化する

### Memory Leaks

JuliaのGCはほとんどのメモリリークを防ぎますが、問題が発生することもあります：

  * **グローバル参照**: 大きなオブジェクトへの参照をグローバル変数に保持することは避けてください
  * **クロージャ**: 大量のデータをキャプチャするクロージャには注意してください
  * **C相互運用**: Cライブラリとインターフェースを取る際の適切なクリーンアップを確保する

Juliaのガベージコレクタ内部に関する詳細情報については、開発者ドキュメントのガベージコレクションセクションを参照してください。
