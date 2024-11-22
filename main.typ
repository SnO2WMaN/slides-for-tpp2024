#import "@preview/touying:0.5.3": *
#import themes.stargazer: *
#import "@preview/ctheorems:1.1.3": *
#show: thmrules

#import "@preview/numbly:0.1.0": numbly

#let theorem = thmbox("theorem", "定理", fill: rgb("#e0fdfc"))
#let lemma = thmbox("theorem", "補題", fill: rgb("#eceff7"))
#let definition = thmbox("theorem", "定義", fill: rgb("#eeeeff"))
#let corollary = thmbox("theorem", "系", inset: (x: 1.2em, top: 0em, bottom: 0em))
#let example = thmbox("example", "例").with(numbering: none)
#let fact = thmbox("fact", "事実", fill: rgb("#ffebeb"))
#let proof = thmproof("proof", "証明")

#let Pred = $serif("Pred")$
#let Sent = $serif("Sent")$
#let Pow(s) = $cal("P")(#s)$
#let True = $serif("True")$
#let False = $serif("False")$
#let setminus = $backslash$
#let vDash = $tack.r.double$
#let nvDash = $tack.r.double.not$

#show link: set text(blue)

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [定理証明支援系Leanによる論理学の形式化について],
    authors: [野口 真柊],
    date: datetime.today(),
    institution: [神戸大学システム情報学研究科 研究生],
  ),
)
#set text(font: "Noto Sans CJK JP", size: 16pt)
#show raw: set text(font: "JuliaMono")

#set heading(numbering: numbly("{1}.", default: "1.1"))
#set cite(form: "prose", style: "institute-of-electrical-and-electronics-engineers")

#title-slide()

= 現状の論理学の形式化について

== Formalized Formal Logic

*Formalized Formal Logic*: https://github.com/FormalizedFormalLogic

元々 iehality 氏の論理学をLeanで形式化していたプロジェクトに，私が様相論理に関する諸々を追加して現在に至る．

一応，企業から金銭をもらうという形でサポートは受けている．

#pagebreak()

これまでに形式化された事実 (iehality氏による)

- 1階古典命題論理
  - 健全性と完全性
  - 自動証明
- 1階述語論理と算術
  - 健全性と完全性
  - カット除去定理(Gentzen's Hauptsatz)#footnote[ただし，大幅な書き換えによって現状では一旦放棄されている．]
  - Gödelの不完全性定理

#pagebreak()

これまでに形式化された事実 (私による)
- 標準的な様相論理
  - Kripke意味論といくつかの完全性
  - 濾過法
- 直観主義命題論理
  - Kripke意味論
  - 選言特性
  - Gödel-McKensey-Tarskiの定理

== 不完全性定理の形式化の歴史

歴史的にはいくつかの形式化がある#footnote[ちゃんと調べた訳では無い．]．

1. 1980年代の @shankar_proof-checking_1986 で初めてG1が形式化された．
2. @oconnor_essential_2006 によるCoqでのG1とG2の形式化．
  ただしG2において導出可能性条件D2とD3は仮定している（形式化できていない）．
3. @paulson_mechanised_2015 によるIsabelle/HOLでのG1とG2の形式化．この証明は @swierczkowski_finite_2003 による遺伝的有限集合上の証明を元にしている#footnote[iehality氏によるとこれは $bold("PA")$ 上で形式化したことと同値らしい．]．

#let vdash = $tack.r$
#let nvdash = $tack.r.not$

== 第1不完全性定理の形式化

#lemma("Representation Theorem")[
  $S$ がr.e.集合なら，任意の $n in omega$ に対し $n in S <==> T vdash phi_S (accent(n, macron))$ となる $phi_S$ が存在する．
]<lem:re_complete>

```lean
lemma re_complete
  {T : Theory ℒₒᵣ} [𝐑₀ ≼ T] [Sigma1Sound T] {p : ℕ → Prop} (hp : RePred p) {n : ℕ}
  : p n ↔ T ⊢! ↑((codeOfRePred p)/[‘↑n’]
```

#pagebreak()

#let ArithR = $upright(bold(R))$
#let ArithR0 = $upright(bold(R_0))$

#theorem("Gödel's 1st Incompleteness Theorem")[
  $Sigma_1$-健全かつ $Delta_1$-定義可能な $ArithR0$ #footnote[Tarski-Mostowski-Robinsonの理論 $ArithR$ よりも更に弱い算術．本質的に決定不能であり，更に公理を抜いた理論は本質的に決定不能ではない．] の拡大理論 $T$ は完全ではない：すなわち，決定不能命題 $G$ が存在して，$T nvdash G$ かつ $T nvdash not G$ ．
]

#let ulcorner = $⸢$
#let urcorner = $⸣$
#let GoedelNum(x) = $lr(⸢#x⸣)$

#proof[
  $D := {phi | T vdash not phi (ulcorner phi urcorner)}$ はr.e.集合である．
  #ref(<lem:re_complete>)より $rho$ が存在して，$T vdash rho (ulcorner phi urcorner) <==> T vdash not phi (ulcorner phi urcorner)$．
  今 $G := rho(ulcorner rho urcorner)$ とすれば $T vdash G <==> T vdash not G$ が成り立つ．
  $T$ は無矛盾なので，$G$ は決定不能命題である．
]

```lean
theorem goedel_first_incompleteness {T : Theory ℒₒᵣ} [Sigma1Sound T] [T.Delta1Definable] [𝐑₀ ≼ T]
  : ¬System.Complete T
```

== 第2不完全性定理の形式化

#let ArithPA = $bold("PA")$
#let ArithPAMinus = $bold("PA"^-)$
#let ArithISigma1 = $bold("IΣ₁")$

#definition[
  - $ArithPAMinus$ は $ArithPA$ の有限公理化可能な部分理論とする．
  - $ArithISigma1$ は $ArithPAMinus$ に $Sigma_1$ 論理式に関する帰納法を追加した理論とする．
]

#let Bew = $upright("Pr")$

#lemma[
  $T$ は $ArithISigma1$ の拡大理論とし，$U$ は $Delta_1$ 定義可能な理論とする．
  次の性質を満たす可証性述語 $Bew_U (x)$ が構成できる．
  - $upright("D1") colon U vdash sigma <==> T vdash Bew_U (ulcorner sigma urcorner)$
  - $upright("D2") colon T vdash Bew_U (ulcorner sigma -> pi urcorner) -> Bew_U (ulcorner sigma urcorner) -> Bew_U (
        ulcorner pi urcorner
      )$
  - $upright(Sigma_1 C) colon T vdash sigma -> Bew_U (ulcorner sigma urcorner)$ ただし $sigma$ は $Sigma_1$文
  - $upright("D3") colon T vdash Bew_U (ulcorner sigma urcorner) -> Bew_U (
        ulcorner Bew_U (ulcorner sigma urcorner) urcorner
      )$
]<lem:provable_a>


#pagebreak()

```lean
variable {T U : Theory ℒₒᵣ} [𝐈𝚺₁ ≼ T] [U.Delta1Definable]
         {σ π : Sentence ℒₒᵣ}

theorem provableₐ_D1 : U ⊢!. σ → T ⊢!. U.bewₐ σ

theorem provableₐ_D2 : T ⊢!. U.bewₐ (σ ➝ π) ➝ U.bewₐ σ ➝ U.bewₐ π

lemma provableₐ_sigma₁_complete (hσ : Hierarchy 𝚺 1 σ) : T ⊢!. σ ➝ U.bewₐ σ

theorem provableₐ_D3 : T ⊢!. U.bewₐ σ ➝ U.bewₐ (U.bewₐ σ)
```

#pagebreak()

#let fixpoint = $upright("fixpoint")$

#theorem("Diagonalize Lemma")[
  $T$ は $ArithISigma1$ の拡大理論とする．任意の述語 $theta(x)$ に対し，次の文 $fixpoint_theta$ が存在する．
  $
    T vdash fixpoint_theta <-> theta(ulcorner fixpoint_theta urcorner)
  $
]

```lean
theorem diagonal [𝐈𝚺₁ ≼ T] (θ : Semisentence ℒₒᵣ 1) : T ⊢!. fixpoint θ ⭤ θ/[⌜fixpoint θ⌝]
```

#pagebreak()

#let Con = $upright("Con")$

#definition[
  $T$ を $ArithISigma1$-拡大かつ$Delta_1$-定義可能な理論とする．
  - $T$のGödel文を $G_T equiv fixpoint_(not Bew_T)$ とする．
  - $T$の無矛盾性を表す文を $Con_T equiv not Bew_T (ulcorner bot urcorner)$ とする．
]

#lemma("Gödel's 1st Incompleteness")[
  - $T$ が無矛盾なら $T nvdash G_T$
  - $NN vDash T$ なら $G_T$ は決定不能命題: $T nvdash not G_T$
]

#lemma[
  $T vdash Con_T <-> G_T$
]

#pagebreak()

#theorem("Gödel's 2nd Incompleteness Theorem")[
  $T$ は自己の無矛盾性を証明できない．すなわち
  - $T$ が無矛盾なら $T nvdash Con_T$
  - $NN vDash T$ なら $Con_T$ は決定不能命題: $T nvdash not Con_T$
]

#pagebreak()

```lean
variable (T : Theory ℒₒᵣ) [𝐈𝚺₁ ≼ T] [T.Delta1Definable]


lemma goedel_unprovable [System.Consistent T] : T ⊬ ↑𝗚

lemma not_goedel_unprovable [ℕ ⊧ₘ* T] : T ⊬ ∼↑𝗚


lemma consistent_iff_goedel : T ⊢! ↑𝗖𝗼𝗻 ⭤ ↑𝗚


theorem goedel_second_incompleteness [System.Consistent T] : T ⊬ ↑𝗖𝗼𝗻

theorem inconsistent_undecidable [ℕ ⊧ₘ* T] : System.Undecidable T ↑𝗖𝗼𝗻
```

== 導出可能性条件ベースの証明

以上の議論は，導出可能性条件という形で抽象的に形式化することが出来る．

#definition[
  - 理論 $T,U$ に対し，次の性質を満たす述語を $T,U$-可証性述語 $Bew_(T,U) (x)$と呼ぶ．
    $
      upright("HBL1") colon U vdash sigma ==> T vdash Bew_(T,U) (ulcorner sigma urcorner)
    $
  - 理論 $T$ が対角化可能とは，任意の述語 $theta$ に対して次を満たす文を返す関数 $fixpoint$ が存在することとする．
    $
      U vdash fixpoint(theta) <--> theta(ulcorner fixpoint(theta) urcorner)
    $
]

以下，$U$ は $T$ の拡大理論とする．

#definition[
  $T,U$-可証性述語 $Bew_(T,U)$ に対して次の条件を定める．
  - $upright("HBL2") colon T vdash Bew_(T,U) (ulcorner sigma -> pi urcorner) -> Bew_(T,U) (
        ulcorner sigma urcorner
      ) -> Bew_(T,U) (ulcorner pi urcorner)$
  - $upright("HBL3") colon T vdash Bew_(T,U) (ulcorner sigma urcorner) -> Bew_(T,U) (
        ulcorner Bew_(T,U) (ulcorner sigma urcorner) urcorner
      )$
  - $upright("Löb") colon U vdash Bew_(T,U) (ulcorner sigma urcorner) -> sigma => U vdash sigma$
  - $upright("F-Löb") colon T vdash Bew_(T,U) (
        ulcorner Bew_(T,U) (ulcorner sigma urcorner) -> sigma urcorner
      ) -> Bew_(T,U) (ulcorner sigma urcorner)$
  - $upright("Rosser") colon U vdash not sigma => T vdash not Bew_(T,U) (ulcorner sigma urcorner)$
]

#definition[
  $T$ は対角化可能として，$T,U$-Gödel文 $G_(T,U)$ を $fixpoint(not Bew_(T,U))$ で定める．
]

#definition[
  $Bew_(T,U)$ がGödel健全 #footnote[これは$Sigma_1$-健全性をGödel文に対してのみ要請するものである．]とは
  $U vdash Bew_(T,U)(ulcorner G_(T,U) urcorner) => U vdash G_(T,U)$ を満たすこととする．
]

#theorem("G1")[
  - $T$ が無矛盾なら，$T nvdash G_(T,U)$
  - 更に $Bew_(T,U)$ がGödel健全なら，$T nvdash not G_(T,U)$
]

```lean
variable [System.Consistent T]

theorem unprovable_goedel : T ⊬. γ

theorem unrefutable_goedel [𝔅.GoedelSound] : T ⊬. ∼γ
```

#pagebreak()

#definition[
  無矛盾性 $Con_(T,U) equiv not Bew_(T,U) (ulcorner bot urcorner)$ とする．
]

#lemma("Formalized G1")[
  $Bew_(T,U)$ が $upright("HBL")$ を満たすとき，$U vdash Con_(T,U) -> not Bew_(T,U) (ulcorner G_(T,U) urcorner)$
]

#lemma[
  $Bew_(T,U)$ が $upright("HBL")$ を満たすとき，$U vdash G_(T,U) <-> Con_(T,U)$
]

#pagebreak()

#theorem("G2")[
  $Bew_(T,U)$ が $upright("HBL")$ を満たすとする．
  - $T$ が無矛盾なら，$T nvdash Con_(T,U)$
  - 更に $Bew_(T,U)$ がGödel健全なら，$T nvdash not Con_(T,U)$
]

```lean
lemma formalized_unprovable_goedel : T ⊢!. 𝔅.con ➝ ∼𝔅 γ

lemma iff_goedel_consistency : T ⊢!. γ ⭤ 𝔅.con

theorem unprovable_consistency [System.Consistent T] : T ⊬. 𝔅.con

theorem unrefutable_consistency [System.Consistent T] [𝔅.GoedelSound] : T ⊬. ∼𝔅.con
```

#pagebreak()

#theorem("Löb's Theorem")[
  $Bew_(T,U)$ が $upright("HBL")$ を満たすなら，
  $U vdash Bew_(T,U) (ulcorner sigma urcorner) -> sigma ==> U vdash sigma$
]

#theorem("Formalized Löb's Theorem")[
  $Bew_(T,U)$ が $upright("HBL")$ を満たすなら，
  $
    U vdash Bew_(T,U) (ulcorner Bew_(T,U) (ulcorner sigma urcorner) -> sigma urcorner) -> Bew_(T,U) (
      ulcorner Bew_(T,U) urcorner
    )
  $
]<thm:formalized_loeb>

#corollary[
  $upright("HBL") => upright("Löb"), upright("F-Löb")$
]

```lean
theorem loeb_theorm [𝔅.HBL] (H : T ⊢!. (𝔅 σ) ➝ σ) : T ⊢!. σ

theorem formalized_loeb_theorem [𝔅.HBL] : T₀ ⊢!. 𝔅 ((𝔅 σ) ➝ σ) ➝ (𝔅 σ)
```

#pagebreak()

#theorem("G2 via Löb")[
  $Bew_(T,U)$ が $upright("Löb")$ を満たし，$T$ が無矛盾なら $T nvdash Con_(T,U)$
]
#proof[
  仮に $U vdash Con_(T,U) <==> U vdash not Bew_(T,U) (ulcorner bot urcorner)$ としたら $U vdash Bew_(T,U) (ulcorner bot urcorner) -> bot ==> U vdash bot$ より $U vdash bot$ が言えておかしい．
]

```lean
lemma unprovable_consistency_via_loeb [System.Consistent T] [𝔅.Loeb] : T ⊬. 𝔅.con
```

#pagebreak()

#lemma[
  $T$ は $ArithISigma1$-拡大理論とし，$U$ は $Delta_1$-定義可能，$ArithR0$-拡大理論，$NN vDash U$ とする．
  - $T$ は対角化可能である．
  - #ref(<lem:provable_a>)の $Bew_U$ は $(T,U)$-可証性述語であり，$upright("HBL")$，Gödel健全性を満たす．
]

#corollary[
  $T, U$ でG1,G2,Löb's Theoremが成り立つ．
]

#pagebreak()

#theorem("Gödel-Rosser's Incompleteness Theorem")[
  $Bew_(T,U)$ が $upright("Rosser")$ を満たし，$T$ が無矛盾なら $T nvdash G_(T,U)$ かつ $T nvdash not G_(T,U)$
]

#theorem("Kriesel's Remark")[
  $Bew_(T,U)$ が $upright("Rosser")$ を満たすなら，$U vdash Con_(T,U)$
]

```lean
variable [𝔅.Rosser]

theorem unprovable_rosser [System.Consistent T] : T ⊬. ρ

theorem unrefutable_rosser [System.Consistent T] : T ⊬. ∼ρ

theorem kriesel_remark : T ⊢!. 𝔅.con
```

== 様相論理

#let box = $square.stroked$
#let dia = $diamond.stroked$
#let FrameClass = $bb("F")$
#let HilbertSystem = $frak("H")$
#let Thm = $upright("Thm")$

#let Axiom(A) = $sans(upright(#A))$
#let AxiomK = $Axiom("K")$
#let AxiomT = $Axiom("T")$
#let Axiom4 = $Axiom("4")$
#let Axiom5 = $Axiom("5")$
#let AxiomB = $Axiom("B")$
#let AxiomD = $Axiom("D")$
#let AxiomP = $Axiom("P")$
#let AxiomL = $Axiom("L")$
#let AxiomM = $Axiom("M")$
#let AxiomDot3 = $Axiom("Dot3")$

#definition[
  - 様相論理の公理図式を，公理のインスタンスの集合として同一視する．
]

#definition("公理図式の例")[
  $
    AxiomK &: box (Phi -> Psi) -> box Phi -> box Psi \
    AxiomT &: box Phi -> Phi \
    AxiomD &: box Phi -> dia Phi \
    AxiomB &: Phi -> dia box Phi \
    Axiom4 &: box Phi -> box box Phi \
    Axiom5 &: dia Phi -> box dia Phi \
    AxiomL &: box (box Phi ➝ Phi) -> box Phi
  $
]

#definition[
  - 推論規則のインスタンスとは前提 $[phi_1,...,phi_n]$ と結論 $psi$ の組 $angle.l [phi_1,...,phi_n], psi angle.r$ とする．
  - 公理図式のように，推論規則の図式 $Phi_1,...,Phi_n | Psi$ で表し，これを推論規則のインスタンスの集合と同一視する．
]

#let Rule(R) = $upright("(" #R ")")$
#let RuleMP = $Rule("MP")$
#let RuleNec = $Rule("Nec")$
#let RuleLoeb = $Rule("Löb")$
#let RuleHenkin = $Rule("Henkin")$

#definition("推論図式の例")[
  $
    RuleMP &: Phi -> Psi, Phi | Psi \
    RuleNec &: Phi | box Phi \
    RuleLoeb &: box Phi -> Psi | Psi \
    RuleHenkin &: box Phi <-> Psi | Psi
  $
]

#definition[
  - 様相論理 $Lambda$ のHilbert流証明体系 $HilbertSystem_Lambda$ とは，（非古典命題論理/様相論理の）公理のインスタンスの集合 $upright("Ax")_Lambda$ と 推論規則のインスタンスの集合 $upright("Rl")_Lambda$ の組 $angle.l upright("Ax")_Lambda, upright("Rl")_Lambda angle.r$ の組とする．ただし必ず $RuleMP subset.eq upright("Rl")$ として省略する．
  - $HilbertSystem_Lambda = angle.l upright("Ax")_Lambda, upright("Rl")_Lambda angle.r$ として $HilbertSystem_Lambda vdash phi$ とは次のように帰納的に定義する．
    1. $phi$ が古典命題論理で証明可能なら，$HilbertSystem_Lambda vdash phi$．
    2. $phi in upright("Ax")_Lambda$ なら，$HilbertSystem_Lambda vdash phi$．
    3. $r in upright("Rl")$ の前提 $phi_1,...,phi_n$ が $HilbertSystem_Lambda vdash phi_1,...,HilbertSystem_Lambda vdash phi_n$ なら，$r$ の結論 $psi$ も $HilbertSystem_Lambda vdash psi$．

  - 煩雑さを避けるため，Hilbert流証明体系 $HilbertSystem_Lambda$ を単に論理 $Lambda$ として書く．
  - $Thm(Lambda) := { phi | Lambda vdash phi }$ とする．
]

#pagebreak()

```lean
structure Hilbert (α : Type*) where
  axioms : Formula α
  rules : Set (InferenceRule α)

inductive Deduction (Λ : Hilbert α) : (Formula α) → Type _
  | maxm {p}     : p ∈ Λ.axioms → Deduction Λ p
  | rule {rl}    : rl ∈ Λ.rules → (∀ {p}, p ∈ rl.antecedents → Deduction Λ p) → Deduction Λ rl.consequence
  | mdp {p q}    : Deduction Λ (p ➝ q) → Deduction Λ p → Deduction Λ q
  | imply₁ p q   : Deduction Λ $ Axioms.Imply₁ p q
  | imply₂ p q r : Deduction Λ $ Axioms.Imply₂ p q r
  | ec p q       : Deduction Λ $ Axioms.ElimContra p q
```

#pagebreak()

#let Logic(L) = $bold(upright(#L))$
#let LogicK = $Logic("K")$
#let LogicKT = $Logic("KT")$
#let LogicS4 = $Logic("S4")$
#let LogicS4Dot2 = $Logic("S4.2")$
#let LogicS5 = $Logic("S5")$
#let LogicGL = $Logic("GL")$
#let LogicS = $Logic("S")$
#let LogicN = $Logic("N")$
#let LogicKT4B = $Logic("KT4B")$
#let LogicTriv = $Logic("Triv")$
#let LogicVer = $Logic("Ver")$
#let LogicGrz = $Logic("Grz")$

#definition[
  代表的な論理体系を挙げる#footnote[$LogicS$ はSolovayの証明可能性論理，$LogicN$ はPure Logic of Necessitation．]．
  $
    LogicK &= angle.l AxiomK, RuleNec angle.r \
    LogicS4 &= angle.l AxiomK union AxiomT union Axiom4, RuleNec angle.r \
    LogicGL &= angle.l AxiomK union AxiomL, RuleNec angle.r \
    LogicS &= angle.l Thm(LogicGL) union AxiomL, emptyset angle.r \
    LogicN &= angle.l emptyset, RuleNec angle.r
  $
]

== Kripke意味論

#definition[
  - $FrameClass_Lambda vDash Thm(Lambda)$ となる $FrameClass_Lambda$ を $Lambda$-フレームクラスとする．
  - $FrameClass_Lambda = FrameClass$ となる非空な $FrameClass$ が存在するとき，$Lambda$-フレームクラスは $FrameClass$ によって定義されるという．
]

#pagebreak()

#theorem("Kripke Soundness")[
  1. $Lambda vdash phi ==> FrameClass_Lambda vDash phi$
  2. $FrameClass_Lambda$ がなんらかの $FrameClass$ で定義されるとき#footnote[実は $FrameClass_Lambda subset.eq FrameClass$ で十分．]，$Lambda vdash phi ==> FrameClass vDash phi$．
]

#lemma[
  $LogicK$-フレームクラスは全てのKripkeフレームのクラス $FrameClass_text("all")$ によって定義される．
]

#corollary[
  $LogicK vdash phi ==> FrameClass_text("all") vDash phi$
]

#pagebreak()

```lean
variable {Λ : Hilbert α} {p : Formula α}

lemma sound : Λ ⊢! p → 𝔽(Λ) ⊧ p

lemma sound_of_characterizability {𝔽 : FrameClass} [char : 𝔽(Λ).Characteraizable 𝔽]
  : Λ ⊢! p → 𝔽#α ⊧ p
```

#pagebreak()

#theorem("Kripke Completeness of " + LogicK)[
  $
    FrameClass_text("all") vDash phi ==> LogicK vdash phi
  $
]

#proof[
  いつものように，$Lambda$-極大無矛盾集合を作ってカノニカルモデルを構成し，真理補題を示して完全性を示す．
]

```lean
instance K_complete : Complete 𝐊 (AllFrameClass.{u}#α)
-- i.e. AllFrameClass.{u}#α ⊧ p → 𝐊 ⊢! p
```

== Geach論理

#definition[
  2項関係 $R$ と非負整数の4つ組 $angle.l i,j,m,n angle.r$ に対し，次を
  $angle.l i,j,m,n angle.r$-合流性という．
  $
    forall x, y, z. [x R^i y and x R^j z => exists u. [y R^m u and z R^n u]]
  $
]

#let AxiomGeach = $Axiom("ga")$

#definition[
  $angle.l i,j,m,n angle.r$ に対して以下の公理図式を $AxiomGeach_(i,j,m,n)$ という．
  $
    AxiomGeach_(i,j,m,n) equiv dia^i box^m Phi -> box^j dia^n Phi
  $
]

#let LogicGeach = $Logic("Ge")$

#definition[
  $LogicK$ に いくつかの $AxiomGeach_(i_1,j_1,m_1,n_1),...,AxiomGeach_(i_k,j_k,m_k,n_k)$ 入れて拡張した論理を
  $LogicGeach(angle.l i_1,j_1,m_1,n_1 angle.r,...,angle.l i_k,j_k,m_k,n_k angle.r)$ と書き，Geach論理という．
]

#example[
  2項関係のいくつかの性質は $angle.l i,j,m,n angle.r$-合流性で一般化できる．
  例えば，反射性は $angle.l 0,0,1,0 angle.r$-合流性であり，推移性は $angle.l 0,2,1,0 angle.r$-合流性である．
]

#example[
  定義上，いくつかの論理はGeach論理である．
  $
    LogicKT &= LogicGeach(angle.l 0,0,1,0 angle.r) \
    LogicS4 &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 0,2,1,0 angle.r) \
    LogicS4Dot2 &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 0,2,1,0 angle.r,angle.l 1,1,1,1 angle.r) \
    LogicS5 &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 1,1,0,1 angle.r) \
    LogicKT4B &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 0,2,1,0 angle.r,angle.l 0,1,0,1 angle.r)
  $
]

#pagebreak()

#theorem[
  $LogicGeach(t_1,...t_k)$-フレームクラスは $t_1$-合流性,...,$t_k$-合流性を満たすフレームのクラス
  $FrameClass_text(t_1"-confluent,...,"t_k"-confluent")$ によって定義される．
]

#theorem[
  $LogicGeach(t_1,...t_k)$ は $t_1$-合流性,...,$t_k$-合流性を満たすフレームのクラス
  $FrameClass_text(t_1"-confluent,...,"t_k"-confluent")$ に対して完全である．
]

#pagebreak()

#corollary[
  - $LogicS4$ は 反射的かつ推移的，すなわち前順序のフレームクラス $FrameClass_text("preorder")$ について完全である．
  - $LogicKT4B$ は 反射的かつ推移的かつ対称的，すなわち同値関係のフレームクラス $FrameClass_text("equiv")$ について完全である．
  - $LogicS5$ は 反射的かつ推移的かつEuclid的なフレームクラス $FrameClass_text("refl,trans,eucl")$ について完全である．
]

#corollary[
  - $FrameClass_text("preorder") subset.neq FrameClass_text("refl,trans,eucl")$ より，$LogicS4 < LogicS5$．
  - $FrameClass_text("equiv") = FrameClass_text("refl,trans,eucl")$ より，$LogicKT4B = LogicS5$．
]

#pagebreak()

```lean
lemma axiomMultiGeach_defines
  : ∀ {F : Kripke.Frame}, (F#α ⊧* 𝗚𝗲(ts) ↔ F ∈ (MultiGeachConfluentFrameClass ts))


instance S4_complete : Complete 𝐒𝟒 PreorderFrameClass.{u}#α

instance KT4B_complete : Complete 𝐊𝐓𝟒𝐁 EquivalenceFrameClass.{u}#α

instance S5_complete : Complete 𝐒𝟓 ReflexiveEuclideanFrameClass.{u}#α


theorem S4_strictlyWeakerThan_S5 : (𝐒𝟒 : Hilbert α) <ₛ 𝐒𝟓

theorem equiv_S5_KT4B : (𝐒𝟓 : Hilbert α) =ₛ 𝐊𝐓𝟒𝐁
```

== Kripkeフレームの定義不可能性

#theorem[
  $Lambda$-フレームクラスが非反射的なフレームクラス $FrameClass_text("irrefl")$ になる $Lambda$ は存在しない．
]

#proof[
  非反射的なフレーム $F := angle.l {0,1}, != angle.r$ と 反射的なフレーム $G := angle.l {0}, = angle.r$ に全射のp-morphism $f colon F attach(|->, br: upright(p)) G$ が構成出来ることから従う．
]


```lean
theorem undefinable_irreflexive : ¬∃ (Λ : Hilbert α), ∀ F, F ∈ 𝔽(Λ) ↔ F ∈ IrreflexiveFrameClass.{0}
```

ただし型宇宙がおかしいという問題がある．

== $LogicGL$ について

#theorem[
  $LogicGL$-フレームクラスは
  - 推移的かつ逆整礎的なフレームクラス $FrameClass_text("trans, cwf")$ で定義される．
  - *有限な* 非反射的なフレームクラス $FrameClass^text("fin")_text("irrefl")$ で定義される．
]

```lean
instance : Sound 𝐆𝐋 (TransitiveConverseWellFoundedFrameClass#α) := inferInstance

instance : Sound 𝐆𝐋 (TransitiveIrreflexiveFrameClassꟳ#α) := inferInstance
```

#theorem[
  $LogicGL$ は 推移的かつ逆整礎的なフレームクラスに対して完全．
]

```lean
instance : Complete (𝐆𝐋 : Hilbert α) TransitiveIrreflexiveFrameClass.{u}ꟳ#α
```

ここまでは @maggesi_mechanising_2023 がHOL Lightで形式化している．

#pagebreak()

自分は更に強い事実を形式化している．

#definition[
  - 推移的な木構造を持つ有限フレームを $LogicGL$-木フレームと呼ぶ．
  - $LogicGL$-木フレームを持つモデルを $LogicGL$-木モデルと呼ぶ．
]

#theorem[
  次は同値．
  1. $LogicGL vdash phi$
  2. 任意の $LogicGL$-木モデル $T$ と，その根 $r$ で $T, r vDash phi$
]

```lean
theorem iff_provable_GL_satisfies_at_root_on_FiniteTransitiveTree :
  𝐆𝐋 ⊢! p ↔ (∀ M : FiniteTransitiveTreeModel.{u, u} α, M.root ⊧ p)
```

#pagebreak()

ここから更に次の系が導ける#footnote[様相選言特性を持つならデネセシテーションが出てくるが，証明を点検したところ $LogicGL$ の様相選言特性の証明はデネセシテーションを持つことに依存していた． ]．

#corollary[
  $LogicGL$ ではデネセシテーションは許容規則．すなわち，
  $
    LogicGL vdash box phi ==> LogicGL vdash phi
  $
]

```lean
theorem GL_unnecessitation! : 𝐆𝐋 ⊢! □p → 𝐆𝐋 ⊢! p
```

#corollary[
  $LogicGL$ は様相選言特性を持つ．すなわち，
  $
    LogicGL vdash box phi or box psi ==> LogicGL vdash phi || LogicGL vdash psi
  $
]

```lean
theorem GL_MDP (h : 𝐆𝐋 ⊢! □p₁ ⋎ □p₂) : 𝐆𝐋 ⊢! p₁ ∨ 𝐆𝐋 ⊢! p₂
```

== 算術的完全性定理

不完全性定理と $LogicGL$ の形式化がなされている以上，算術的健全性と完全性も形式化したい#footnote[知る限り，この事実の形式化は存在しない．（そもそも第2定理の形式化すらないのだから…）]．

#definition[
  - 様相論理の命題変数を算術の文へと写す写像
    $* colon upright("Ver")_(cal("L")_upright("M")) -> upright("Sent")_(cal("L")_upright("A"))$
    を解釈と呼ぶ．
  - $box$ を可証性述語 $Bew_T$ のように見るように解釈 $*$ を様相論理式に拡張した写像 $*_(Bew_T) colon upright("Form")_(cal("L")_upright("M")) -> upright("Sent")_(cal("L")_upright("A"))$ を $Bew_T$-翻訳と呼ぶ．すなわち次を満たす．
    $
      p^(*_(Bew_T)) &|-> p^* \
      attach(bot, tr: *_(Bew_T)) &|-> bot \
      (phi -> psi)^(*_(Bew_T)) &|-> phi^(*_(Bew_T)) -> psi^(*_(Bew_T)) \
      (box phi)^(*_(Bew_T)) &|-> Bew_T (ulcorner phi^(*_(Bew_T)) urcorner)
    $
]

#pagebreak()

#theorem("Arithmetical Soundness")[
  $Bew_(T,U)$ は $T,U$-可証性述語とする．
  - $LogicN vdash phi$ ならば，任意の解釈 $*$ に対して $U vdash phi^(*_Bew_(T,U))$．
  - $Bew_(T,U)$ は $upright("HBL")$ を満たすとする．$LogicGL vdash phi$ ならば，任意の解釈 $*$ に対して $U vdash phi^(*_Bew_(T,U))$．
]
#proof[
  論理式 $phi$ の帰納法を回せばよい．$upright("HBL")$ を満たすなら形式化されたLöbの定理(#ref(<thm:formalized_loeb>))が成り立つことに注意する．
]

```lean
lemma arithmetical_soundness_N (h : 𝐍 ⊢! p) : ∀ {f : Realization α L}, U ⊢!. (f.interpret 𝔅 p)

lemma arithmetical_soundness_GL [𝔅.HBL] (h : 𝐆𝐋 ⊢! p) : ∀ {f : Realization α L}, U ⊢!. (f.interpret 𝔅 p)
```

#pagebreak()

逆も成り立つ．こちらは自明ではない．

#theorem("Arithmetical Completeness")[
  $Bew_(T,U)$ は $T,U$-可証性述語とする．
  - 任意の解釈 $*$ に対して $U vdash phi^(*_Bew_(T,U))$ ならば，$LogicN vdash phi$．
  - $Bew_(T,U)$ は $upright("HBL")$ を満たすとする．任意の解釈 $*$ に対して $U vdash phi^(*_Bew_(T,U))$ ならば $LogicGL vdash phi$．
]

*残念ながら形式化出来ていない．*

== 様相論理：その他

話せなかったが形式化が済んでいる内容

#let boxdot = $dot.square$

- 濾過法と有限フレーム性
  - ただし有限フレーム性が言えたからといって，Leanの中で決定可能性が形式化できそうかは不明（「形式化された決定可能性」のようなものを定義する必要がありそう）．
- 直観主義論理およびいくつかの中間論理のKripke完全性
  - その系として，排中律の非成立と選言特性
- 直観主義論理と様相論理の関連性
  - Gödel-McKensey-Tarskiの定理：$Logic("Int"), LogicS4$ のModal Companion．
- 規則 $RuleLoeb,RuleHenkin$ を用いた $LogicGL$ の別定義
- $LogicTriv$ と $LogicVer$ が古典命題論理に帰着できること
- $LogicGrz$ のKripke完全性
- $LogicGL, LogicGrz$ の Boxdot Companion#footnote[$LogicGL$ の定理で $box$ を $boxdot$ に置き換えると $LogicGrz$ の定理になる．]
- Pure Logic of Necessitation $LogicN$ の意味論とその完全性

== 今後の展望

まだまだ多くのことが残されている！

- 強完全性
- $LogicGL$ の算術的完全性
- $LogicGL$ の不動点定理
- 様相論理の種々の計算体系および自動証明
- 様相論理の代数的意味論
- Modal Companion
- Kripke不完全な様相論理
- その他の導出可能性条件の形式化
- その他多くの様相論理の事実
  - Makinsonの定理
  - Boxdot Companion
- 補間定理
- $upright("Rosser")$ を満たす可証性述語の構成
- その他の論理体系: Hybrid Logic, 様相 $mu$ 計算など

== 今後の展望: $LogicGL$ の算術的完全性

#theorem("Arithmetical Completeness", numbering: none)[
  $Bew_(T,U)$ は $T,U$-可証性述語で $upright("HBL")$ を満たすとする．任意の解釈 $*$ に対して $U vdash phi^(*_Bew_(T,U))$ ならば $LogicGL vdash phi$
]

道具立て（多変数版の対角化補題，$LogicGL$ の木フレームに対する完全性，etc.）自体はあるはずので，あとは地道にやるだけだとは思うが難航している．

- 多変数版の対角化補題から実際に Solovay論理式 $beta_i$ を構成する部分
- 「一般性を失わずにKripkeフレームのWorldを $omega$ 上のものとしてよい」の部分

== 今後の展望: 様相論理の種々の計算体系の形式化および自動証明

$LogicGL$ の普通のシークエント計算は論理式の集合を多重集合にするか集合にするかで微妙な違いが生じる．
その他にも複雑な帰納法(2重/3重帰納法)を回すため証明が正確に行われているのかで議論を複雑にしていた
#cite(<valentini_modal_1983>, form:"normal"), #cite(<gore_valentinis_2012>, form:  "normal")．
$LogicGL$ のシークエント計算は#cite(<das_cut-elimination_2021>)らによってCoqで形式化されており，まずはこれをLeanで再実装してみたい．

なおなぜか Coq による証明可能性論理（特に直観主義証明可能性論理 $Logic("iGL"), Logic("iSL")$ など）に関連する証明論の形式化が近年盛んに行われている．

#pagebreak()

その他にも様相論理にはいくつかの計算体系：シークエント計算の拡張，あるいはタブロー計算#footnote[単に計算するだけなら @wolfgang_tree_nodate というサイトがある．様相論理 $LogicK$ の $AxiomT, AxiomD, AxiomB, Axiom4, Axiom5$ 拡張に対応． ]がある．
拡張されたシークエント計算の形式化は知る限りほぼ見たことがない上に，紙とペンの証明では上手く証明が回っていないことがある（らしい）．
そういったところを厳密に詰めてみたい．

#pagebreak()

そもそも，現段階で命題論理, 様相論理の様々な定理をHilbert流で全部計算していて，あまりにもパズル的で面倒．

#pagebreak()

こんなのが2000行ぐらいある．

```lean
def demorgan₂ : 𝓢 ⊢ (∼p ⋏ ∼q) ➝ ∼(p ⋎ q) := by
  apply andImplyIffImplyImply'.mpr;
  apply deduct';
  apply deduct;
  apply neg_equiv'.mpr;
  apply deduct;
  exact or₃''' (neg_equiv'.mp FiniteContext.byAxm) (neg_equiv'.mp FiniteContext.byAxm) (FiniteContext.byAxm (p := p ⋎ q));

def diaOrInst₂ : 𝓢 ⊢ ◇q ➝ ◇(p ⋎ q) := by
  apply impTrans'' (and₁' diaDuality);
  apply impTrans'' ?h (and₂' diaDuality);
  apply contra₀';
  apply axiomK';
  apply nec;
  apply contra₀';
  exact or₂;
```

== 今後の展望: 様相論理の代数的意味論 / Modal Companion

モチベーション
1. Kripkeフレームをコードで扱うのはやや面倒
  - 特に型宇宙周りがめちゃくちゃになっている#footnote[今回の例で`{u}`などが頻出したが，普通出てこない]．
  - 逆に代数的な操作は形式化の上では扱いやすいという話がある#footnote[実際にそうなのかは不明]．
2. より一般的に中間論理と様相論理のModal Companionを考えるときにほぼ必須?
3. その他にもGoldblatt-Thomasonの定理やSahlqvistの定理なども形式化するなら避けられないと思われる．

== 今後の展望: 様々な論理体系の形式化

今 Formalized Formal Logicで扱っているのは
- 古典命題論理，直観主義命題論理
- 古典1階述語論理とその算術
- 標準的な $box, dia$ の様相論理

もっと様々な論理体系 #footnote[様々な定理証明支援系でいくつかの実装がある．https://formalizedformallogic.github.io/Book/references.html 参照．] を形式化してみたい．
- 様相 $mu$-計算
- Hybrid Logic
- (多エージェント)認識論理
- 動的論理
- 線形論理

特にLeanはプログラミング言語としても扱える（ことになっている）ので，
これらの論理体系を形式化して応用的なソフトウェアなどを作ることも可能かもしれない．

== 参考文献

#bibliography(title: none, "references.bib")
