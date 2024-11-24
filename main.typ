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

#let box = $square.stroked$
#let dia = $diamond.stroked$

#let FrameClass = $bb("F")$
#let HilbertSystem = $frak("H")$
#let Thm = $upright("Thm")$

#let vdash = $tack.r$
#let nvdash = $tack.r.not$

#let Bew = $bold(upright("Pr"))$
#let Con = $bold(upright("Con"))$

#let ulcorner = $⌈$
#let urcorner = $⌉$
#let GoedelNum(x) = $lr(ulcorner #x urcorner)$

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
#let AxiomDot2 = $Axiom(".2")$
#let AxiomDot3 = $Axiom(".3")$

#let Rule(R) = $upright("(" #R ")")$
#let RuleMP = $Rule("MP")$
#let RuleNec = $Rule("Nec")$
#let RuleLoeb = $Rule("Löb")$
#let RuleHenkin = $Rule("Henkin")$

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

#let Arith(A) = $bold(upright(#A))$
#let PA = $Arith("PA")$

#let And = $class("relation", \&)$

#show link: set text(blue)

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [標準的な様相論理のLeanでの形式化について],
    authors: [野口 真柊],
    date: datetime.today(),
    institution: [神戸大学システム情報学研究科 研究生],
  ),
)
#set text(font: "Shippori Antique B1", size: 16pt)
#show raw: set text(font: "JuliaMono")

#set heading(numbering: numbly("{1}.", default: "1.1"))
#set cite(form: "prose", style: "institute-of-electrical-and-electronics-engineers")

#show link: underline

#title-slide()

このスライドは #link("https://sno2wman.github.io/slides-for-tpp2024/main.pdf") で閲覧出来ます．

= 様相論理について

== 様相論理

#definition[
  古典的な命題論理に1項の様相演算子 $box, dia$ を加えて拡張した論理体系一般を，*標準的な様相論理*という．
]

#example[
  $box p$ を「$p$は必然的に起こる」と解釈する．
  $dia$ を $box$ の双対として定義すると（$dia p :equiv not box not p$）
  「$p$ が起こらないことは必然的でない」すなわち「$p$ が起こる可能性がある」と解釈できる．
]

#example[
  $box p$ をどのような様相として解釈するかで，様々な様相論理が定義できる．
  - 義務「$p$ は義務である」．
    - $box p -> dia p$「$p$ でなければならないなら，$p$ でもよい」
  - 知識「$p$ を知っている」．
    - $box p -> box box p$「$p$ を知っているなら，$p$ を知っていることも知っている」
    - $box p -> p$「$p$ を知っているなら $p$ は正しい．」
  - (形式的)証明可能性「$p$ は証明可能である」
]

#pagebreak()

#definition([Kripke意味論])[
  - 世界の非空集合 $W$ と $W$ 上の2項関係 $R colon W times W$ の組 $angle.l W, R angle.r$ を*Kripkeフレーム*という．
  - フレーム $angle.l W,R angle.r$ とその上の付値関数 $V colon upright("Var") times W -> 2$ の組 $angle.l W, R, V angle.r$ を*Kripkeモデル*という．
  - 論理式の充足関係は世界に依存して決まる．$M = angle.l W,R,V angle.r$ と $x in W$ に対して，
    - $M, x vDash p <==> V(x,p) = 1$ 「$x$ 上で $p$ が真である」
    - $M, x vDash box phi <==> forall y, x R y ==> V(w,p) = 1$ 「$x$ から行ける全ての世界で $phi$ は真」
  - モデル $M$ に対し，全ての世界で $phi$ が充足されるなら，*$M vDash phi$ 「$phi$ はモデル $M$ で妥当」*という．
  - フレーム $F$ 上の任意のモデルで $phi$ が妥当であるなら，*$F vDash phi$ 「$phi$ はフレーム $F$ で妥当」*という．
]

= 様相論理のLeanでの形式化

== Formalized Formal Logic

#image("./images/FFL.png", height: 4em)
#text(size: 2em)[Formalized Formal Logic
]
https://github.com/FormalizedFormalLogic

数理論理学の様々な事実や定理をLean4で形式化するプロジェクト．自分と齋藤氏が中心となって進めている．

#pagebreak()

齋藤氏によってこれまで形式化された事実．#footnote[自動証明とカット除去定理と発表時では一旦書き直しのため破棄されている．]

- 古典命題論理
  - 健全性と完全性
  - 自動証明
- 古典1階述語論理と算術
  - 健全性と完全性
  - カット除去定理
  - Gödelの不完全性定理
    - 明日の齋藤氏の発表で詳しく説明される．

#pagebreak()

自分がこれまでに形式化した事実

- 直観主義命題論理
  - Kripke意味論
  - 選言特性
  - Gödel-McKensey-Tarskiの定理
- 標準的な様相論理
  - Kripke意味論と，いくつかの論理に対しての完全性
    - *Geach論理*
    - *証明可能性論理 $LogicGL$*
  - 濾過法

今回の発表では強調した箇所について手短に説明する．

== 様相論理

#definition[
  - 以下の公理と推論規則を持つHilbert流証明体系で証明可能な論理式の集合を論理 $LogicK$ とする．
    - 古典命題論理のトートロジー
    - 公理 $AxiomK : box (phi -> psi) -> box phi -> box psi$
    - モーダスポネンス $RuleMP &: phi -> psi, phi | psi$
    - ネセシテーション $RuleNec &: phi | box phi$
]

#pagebreak()

#definition[
  以下は $LogicK$ では証明できず，公理と呼ばれる．
  $
    AxiomT &: box phi -> phi & AxiomD &: box phi -> dia phi \
    AxiomB &: phi -> dia box phi & Axiom4 &: box phi -> box box phi \
    Axiom5 &: dia phi -> box dia phi & AxiomDot2 &: dia box phi -> box dia phi \
    AxiomL &: box (box phi -> phi) -> box phi
  $
]

#definition[
  公理 $AxiomK$ に加えて更に公理を加えて拡張することで得られる論理を挙げる．
  $
    LogicKT &= AxiomK + AxiomT \
    LogicS4 &= AxiomK + AxiomT + Axiom4 & LogicS5 &= AxiomK + AxiomT + Axiom5 \
    LogicKT4B &= AxiomK + AxiomT + Axiom4 + AxiomB \
    LogicGL &= AxiomK + AxiomL
  $
]<def:modal_logics>


== Geach論理

#let AxiomGeach = $Axiom("ga")$
#let LogicGeach = $Logic("Ge")$

#definition[
  2項関係 $R$ に対し $angle.l i,j,m,n angle.r in NN^4$ として以下が成り立つなら $angle.l i,j,m,n angle.r$-合流的であるという．
  $
    forall x, y, z. [x R^i y and x R^j z ==> exists u. [y R^m u and z R^n u]]
  $

  ただし2項関係の $n$ 回合成 $R^n$ は以下のように定める．
  - $x R^0 y <==> x = y$．
  - $x R^(n + 1) y <==> exists z, x R^n z And z R y$
]

#example[
  2項関係のいくつかの性質は $angle.l i,j,m,n angle.r$-合流性で一般化できる．
  - 反射性 $x R y ==> y R x$ は $angle.l 0,0,1,0 angle.r$-合流性
  - 推移性 $x R y And y R z ==> x R z$ は $angle.l 0,2,1,0 angle.r$-合流性
]

#pagebreak()

#definition[
  $angle.l i,j,m,n angle.r$ に対して以下をGeach公理 $AxiomGeach_(i,j,m,n)$ という．
  $
    AxiomGeach_(i,j,m,n) equiv dia^i box^m phi -> box^j dia^n phi
  $
]

#definition[
  $LogicK$ に いくつかのGeach公理 $AxiomGeach_(i_1,j_1,m_1,n_1),...,AxiomGeach_(i_k,j_k,m_k,n_k)$ 入れて拡張した論理を
  Geach論理 $LogicGeach(angle.l i_1,j_1,m_1,n_1 angle.r,...,angle.l i_k,j_k,m_k,n_k angle.r)$ と書く．
]

#example[
  公理 $AxiomT, AxiomD, AxiomB, Axiom4, Axiom5, AxiomDot2$ はGeach公理であり，$LogicK$ 及び #ref(<def:modal_logics>) のいくつかの論理はGeach論理である．
  $
    LogicK &= LogicGeach() \
    LogicKT &= LogicGeach(angle.l 0,0,1,0 angle.r) \
    LogicS4 &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 0,2,1,0 angle.r) \
    LogicS5 &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 1,1,0,1 angle.r) \
    LogicKT4B &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 0,2,1,0 angle.r,angle.l 0,1,0,1 angle.r) \
    LogicS4Dot2 &= LogicGeach(angle.l 0,0,1,0 angle.r,angle.l 0,2,1,0 angle.r,angle.l 1,1,1,1 angle.r) \
  $
]

#pagebreak()

#theorem([Geach論理のKripke完全性])[
  $LogicGeach(t_1,...t_k)$ は $t_1$-合流性,...,$t_k$-合流性を満たすフレームのクラスに対して健全かつ完全である．
  すなわち，次は同値である．
  1. $LogicGeach(t_1,...t_k)$ で $phi$ が証明可能: $LogicGeach(t_1,...,t_k) vdash phi$
  2. $t_1$-合流性,...,$t_k$-合流性を満たす全てのフレーム $F$ で $phi$ は妥当: $F vDash phi$
]

#corollary[
  $LogicK$ に 公理 $AxiomT, AxiomD, AxiomB, Axiom4, Axiom5, AxiomDot2$ を適当に付け加えた論理たちは全て対応するフレームクラスに対して完全である．
  例えば次のことが成り立つ．
  - $LogicS4$ は 反射的/推移的，すなわち前順序のフレームのクラスについて完全である．
  - $LogicKT4B$ は 反射的/推移的/対称的，すなわち同値関係のフレームのクラスについて完全である．
  - $LogicS5$ は 反射的/推移的/Euclid的なフレームのクラスについて完全である．
]

```lean
instance S4.Kripke.complete : Complete (Hilbert.S4 ℕ) ReflexiveTransitiveFrameClass

instance S5.Kripke.complete : Complete (Hilbert.S5 ℕ) ReflexiveEuclideanFrameClass
```

#pagebreak()

#corollary[
  - 同値関係なフレームは反射的/推移的/Euclid的であり，逆も成り立つ．そのため，$LogicKT4B$ と $LogicS5$ は証明能力が等しい．
  - 前順序だが同値関係ではないフレームが存在するため，$LogicKT4B$ は $LogicS4$ より真に強い．

  $
    LogicS4 subset.neq LogicKT4B = LogicS5
  $
]

```lean
theorem S4_strictlyWeakerThan_S5 : (Hilbert.S4 ℕ) <ₛ (Hilbert.S5 ℕ)

theorem equiv_S5_KT4B : (Hilbert.S5 ℕ) =ₛ (Hilbert.KT4B ℕ)
```

== $LogicGL$

様相論理 $LogicGL$ は不完全性定理で言及される証明可能性を分析するための様相論理：*証明可能性論理*として盛んに研究が行われている．
まず，Kripke意味論に対して以下の性質が成り立つ #footnote[この事実は @maggesi_mechanising_2023 によってHOL Lightで既に形式化が成されている．]．

#theorem[
  $LogicGL$ は 推移的かつ非反射的な有限なフレームのクラスに対して健全かつ完全，すなわち有限フレーム性を持つ．
  #footnote[なお，有限性を要請せず単に非反射的なフレームのクラスに対して完全な様相論理は存在しない．この事実も形式化されている．]
]

```lean
instance : Kripke.FiniteFrameProperty (Hilbert.GL ℕ) TransitiveIrreflexiveFiniteFrameClass
```


#pagebreak()

更に強い事実が成り立つ．

#theorem[
  次は同値．
  1. $LogicGL vdash phi$
  2. 任意の推移的な木構造を持つ有限フレーム上のモデル $M$ と，その根 $r$ で $M, r vDash phi$
]

```lean
theorem provable_iff_satisfies_at_root_on_FiniteTransitiveTree
  : (Hilbert.GL ℕ) ⊢! φ ↔ (∀ M : FiniteTransitiveTreeModel, Satisfies M.toModel M.root φ) :
```

#pagebreak()

ここから更に次の系が導ける．

#corollary[
  $LogicGL$ ではデネセシテーションは許容規則．すなわち，
  $
    LogicGL vdash box phi ==> LogicGL vdash phi
  $
]

```lean
theorem GL_unnecessitation!  : (Hilbert.GL ℕ) ⊢! □φ → (Hilbert.GL ℕ) ⊢! φ
```

#corollary[
  $LogicGL$ は様相選言特性を持つ．すなわち，
  $
    LogicGL vdash box phi or box psi ==> LogicGL vdash phi || LogicGL vdash psi
  $
]

```lean
theorem GL_MDP (h : (Hilbert.GL ℕ) ⊢! □φ₁ ⋎ □φ₂) : (Hilbert.GL ℕ) ⊢! φ₁ ∨ (Hilbert.GL ℕ) ⊢! φ₂
```

#pagebreak()

#theorem([第2不完全性定理])[
  $T$ を $PA$ の無矛盾な再帰的可算な拡大理論とする．
  このとき，次を満たす証明可能性述語 $Bew_T$ を構成できる．

  $T$ の無矛盾性を表す文 $Con_T :equiv Bew_T (GoedelNum(bot))$ は $T$ で証明できない．
  すなわち $T nvdash Con_T$．
]<thm:goedel2>

```lean
abbrev bewₐ (σ : Sentence ℒₒᵣ) : Sentence ℒₒᵣ := U.provableₐ/[⌜σ⌝]

abbrev consistentₐ : Sentence ℒₒᵣ := ∼U.bewₐ ⊥

theorem goedel_second_incompleteness [System.Consistent T] : T ⊬ T.consistentₐ
```

不完全性定理と $LogicGL$ の形式化は成されている．よって，証明可能性論理の礎となる算術的完全性という定理も形式化したい．

#definition[
  - 様相論理の命題変数を1階述語論理上の算術の文へと写す写像
    $* colon upright("Ver")_(cal("L")_upright("M")) -> upright("Sent")_(cal("L")_upright("A"))$
    を解釈と呼ぶ．
  - $box$ を証明可能性述語 $Bew_T$ として見るように解釈 $*$ を様相論理式へと拡張した写像 $*_(Bew_T) colon upright("Form")_(cal("L")_upright("M")) -> upright("Sent")_(cal("L")_upright("A"))$ を $Bew_T$-翻訳と呼ぶ．すなわち次を満たす．
    $
      p^(*_(Bew_T)) &|-> p^* \
      attach(bot, tr: *_(Bew_T)) &|-> bot \
      (phi -> psi)^(*_(Bew_T)) &|-> phi^(*_(Bew_T)) -> psi^(*_(Bew_T)) \
      (box phi)^(*_(Bew_T)) &|-> Bew_T (ulcorner phi^(*_(Bew_T)) urcorner)
    $
]

#pagebreak()

#theorem([$LogicGL$ の算術的完全性定理])[
  $Bew_T$ は #ref(<thm:goedel2>) で構成できる証明可能性述語であるとする．このとき次は同値である．
  1. $LogicGL vdash phi$
  2. 任意の解釈 $*$ に対して $T vdash phi^(*_Bew_T)$．
]

1.から2.は帰納法を回せば良いだけなので簡単．

```lean
lemma arithmetical_soundness_GL [𝔅.HBL] (h : 𝐆𝐋 ⊢! p) : ∀ {f : Realization α L}, U ⊢!. (f.interpret 𝔅 p)
```

2.から1.は難しく，*形式化出来ていない*．
道具立て（多変数版の対角化補題，$LogicGL$ の木フレームに対する完全性，etc.）自体は既に済んでいるので，あとは地道にやるだけだとは思うが難航している．

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
- $LogicGL, LogicGrz$ の Boxdot Companion#footnote[$LogicGL$ で証明できる論理式の $box$ の出現を全て $boxdot$ （ただし $boxdot phi :equiv phi and box phi$）に置き換えた論理式は $LogicGrz$ で証明できる．]
- Pure Logic of Necessitation $LogicN$ の意味論とその完全性

== 今後の展望

まだまだ多くのことが残されている！

- 強完全性
- $LogicGL$ の算術的完全性
- $LogicGL$ の不動点定理
- *様相論理の種々の計算体系および自動証明*
- *様相論理の代数的意味論*
- Modal Companion
- Kripke不完全な様相論理
- その他多くの様相論理の事実
  - Makinsonの定理
  - Boxdot Companion
- 補間定理
- *その他の論理体系: Hybrid Logic, 様相 $mu$ 計算など*

== 今後の展望: 様相論理の種々の計算体系の形式化および自動証明

$LogicGL$ の普通のシークエント計算は論理式の集合を多重集合にするか集合にするかで議論の微細な違いが生じ，
その他にも複雑な帰納法を回すため，証明が正確に行われているのか議論の余地があった#cite(<valentini_modal_1983>, form:"normal"), #cite(<gore_valentinis_2012>, form:  "normal")．

近年 #cite(<das_cut-elimination_2021>)らによって$LogicGL$ のシークエント計算の形式化がCoqでなされた．まずはこれをLeanで再実装してみたい．

その他にも様相論理にはいくつかの計算体系：シークエント計算の拡張，あるいはタブロー計算がある．
拡張されたシークエント計算の形式化は知る限りほぼ見たことがなく，紙とペンの証明では上手く証明が回っていないことがある（らしい）ので
そういったところを形式化することで厳密に詰めてみたい．

#text(size: 12pt)[
  余談: なお近年 Coq による証明可能性論理（特に直観主義証明可能性論理 $Logic("iGL"), Logic("iSL")$ など）に関連する証明論の形式化が近年盛んに行われている．
]

== 今後の展望: 様相論理の代数的意味論 / Modal Companion

Boolean代数に適当な $box$ 演算を入れて拡張した代数を考えることで様相論理に代数的による意味論を与えられる．
この代数を定理証明支援系で形式化するモチベーションはいくつかある．

1. Kripkeフレームをコードで扱うのはやや面倒．
  - 逆に代数的な操作は形式化の上では扱いやすいという話がある#footnote[実際にそうなのかは不明]．
2. より一般的に中間論理と様相論理のModal Companionを考えるときにほぼ必須の知識．
3. その他にもGoldblatt-Thomasonの定理やSahlqvistの定理なども形式化するなら避けられないと思われる．

== 今後の展望: 様々な論理体系の形式化

今 Formalized Formal Logicで扱っているのは
- 古典命題論理，直観主義命題論理
- 古典1階述語論理とその算術
- 標準的な $box, dia$ の様相論理

もっと様々な論理体系を形式化してみたい#footnote[様々な定理証明支援系でいくつかの実装がある．https://formalizedformallogic.github.io/Book/references.html 参照．] ．
- 様相 $mu$-計算
- Hybrid Logic
- Lax Logic
- (多エージェント)認識論理
- 動的論理
- 線形論理

特にLeanはプログラミング言語としても扱える（ことになっている）ので，
これらの論理体系を形式化して応用的なソフトウェアなどを作ることも可能かもしれない．

= 参考文献

#pagebreak()

#bibliography(title: none, "references.bib")
