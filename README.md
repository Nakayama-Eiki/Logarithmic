# Logarithmic



![test](https://github.com/Nakayama-Eiki/Logarithmic/actions/workflows/test.yml/badge.svg)

標準入力から対数同士の四則演算が可能です．

## *使い方例*
```
$git clone git@github.com:Nakayama-Eiki/Logarithmic.git

$chmod +x logarithmic_calculation

$echo -e "演算子,真数,底\n演算子,真数,底\n..." | ./log_calc -p 桁数

$echo -e "=,3.2,6.7\n*,58,36\n-,7.53,e" | ./log_calc -p 4

-1.3260
```
## *使用の際の注意点*
- 入力する真数と底の中に演算子は入れないでください
- デフォルトで出力される桁数は小数第6位までです． 
- 最初の演算子は必ず"="にしてください．

## *必要なソフトウェア*
- Python
  - テスト済みバージョン: 3.7〜3.10

## *テスト環境*
- Ubuntu 24.04 LTS

このソフトウェアパッケージは，GPL3.0にコピーの下，再頒布および使用が許可されます．
- このパッケージは，Ryuichi Uedaのスライド由来のコード（© 2025 Ryuichi Ueda）を利用しています．
- このパッケージのコードは，下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを，本人の許可を得て，そしてコマンドはAI使用のもと作成し，24C1130 山下正悟に不具合を伝え助言をもらいながら自身の著作としたものです。
    - [ryuichiueda/my_slides robosys_2025](https://github.com/ryuichiueda/slides_marp/tree/master/robosys2025)
- © 2025 Eiki Nakayama:
