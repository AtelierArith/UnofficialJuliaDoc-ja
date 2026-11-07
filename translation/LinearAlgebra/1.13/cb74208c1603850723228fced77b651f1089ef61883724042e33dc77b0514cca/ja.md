```julia
svd(A, B) -> GeneralizedSVD
```

`A` と `B` の一般化特異値分解を計算し、次の条件を満たす `GeneralizedSVD` 分解オブジェクト `F` を返します。`[A;B] = [F.U * F.D1; F.V * F.D2] * F.R0 * F.Q'`

  * `U` は M×M の直交行列、
  * `V` は P×P の直交行列、
  * `Q` は N×N の直交行列、
  * `D1` は M×(K+L) の対角行列で、最初の K 個の対角成分は 1、
  * `D2` は P×(K+L) の行列で、右上の L×L ブロックは対角行列、
  * `R0` は (K+L)×N の行列で、右端の (K+L)×(K+L) ブロックは正則な上三角ブロック行列、

`K+L` は行列 `[A; B]` の実効数値ランクです。

この分解を反復すると、成分 `U`、`V`、`Q`、`D1`、`D2`、`R0` が得られます。

一般化特異値分解は、ヒトと酵母のゲノム、信号とノイズ、あるいはクラスター間とクラスター内のように、`A` に属する部分と `B` に属する部分の量を比較したい場合などに利用されます（詳しくは Edelman と Wang の議論を参照してください。https://arxiv.org/abs/1901.00485)

これは `[A; B]` を `[UC; VS]H` に分解します。ここで `[UC; VS]` は `[A; B]` の列空間に対する自然な直交基底であり、`H = RQ'` は `[A;B]` の行空間に対する自然な非直交基底です。その上側の行は `A` 行列に、下側の行は `B` 行列に最も強く対応します。多重余弦・正弦行列 `C` と `S` は、`A` と `B` の量を多重尺度で示し、`U` と `V` は、それらを測定する方向を示します。

# Examples

```jldoctest
julia> A = randn(3,2); B=randn(4,2);

julia> F = svd(A, B);

julia> U,V,Q,C,S,R = F;

julia> H = R*Q';

julia> [A; B] ≈ [U*C; V*S]*H
true

julia> [A; B] ≈ [F.U*F.D1; F.V*F.D2]*F.R0*F.Q'
true

julia> Uonly, = svd(A,B);

julia> U == Uonly
true
```
