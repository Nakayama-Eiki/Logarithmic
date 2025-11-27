# Logarithmic



![test](https://github.com/Nakayama-Eiki/Logarithmic/actions/workflows/test.yml/badge.svg)

標準入力から対数同士の四則演算が可能です．

## 使い方例
$git clone git@github.com:Nakayama-Eiki/Logarithmic.git

$chmod +x logarithmic_calculation

$echo -e "演算子,真数,底\n演算子,真数,底\n..." | ./log_calc -p [桁数]

## 必要なソフトウェア
- Python
  - テスト済みバージョン: 3.7〜3.10

## テスト環境
- Ubuntu 24.04 LTS

このソフトウェアパッケージは，GPL3.0にコピーの下，再頒布および使用が許可されます．
- このパッケージは，Ryuichi Uedaのスライド由来のコード（© 2025 Ryuichi Ueda）を利用しています．
- このパッケージのコードは，下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを，本人の許可を得て
自身の著作としたものです．
    - [ryuichiueda/my_slides robosys_2025](https://github.com/ryuichiueda/slides_marp/tree/master/robosys2025)
- © 2025 Eiki Nakayama:
