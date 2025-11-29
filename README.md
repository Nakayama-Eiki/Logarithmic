# Logarithmic



![test](https://github.com/Nakayama-Eiki/Logarithmic/actions/workflows/test.yml/badge.svg)

常用対数の範囲を指定して棒グラフとして出力するコマンドです．

## *使い方*
```
$git clone git@github.com:Nakayama-Eiki/Logarithmic.git

$chmod +x logarithmic_calculation

$seq 初めの数値 刻む大きさの数値 終わりの数値 | ./logarithmic_calculation

<例>

$seq 1 0.5 5 | ./logarithmic_calculation
   1.00 | 0.000000 |
   1.50 | 0.176091 | 000
   2.00 | 0.301030 | 000000
   2.50 | 0.397940 | 0000000
   3.00 | 0.477121 | 000000000
   3.50 | 0.544068 | 0000000000
   4.00 | 0.602060 | 000000000000
   4.50 | 0.653213 | 0000000000000
   5.00 | 0.698970 | 0000000000000
```
## *使用の際の注意点*

## *必要なソフトウェア*
- Python
  - テスト済みバージョン: 3.7〜3.10

## *テスト環境*
- Ubuntu 24.04 LTS

このソフトウェアパッケージは，GPL3.0にコピーの下，再頒布および使用が許可されます．
- このパッケージは，Ryuichi Uedaのスライド由来のコード（© 2025 Ryuichi Ueda）を利用しています．
- このパッケージのコードは，下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを，本人の許可を得て，24C1130 山下正悟に不具合を伝え助言をもらいながら自身の著作としたものです。
    - [ryuichiueda/my_slides robosys_2025](https://github.com/ryuichiueda/slides_marp/tree/master/robosys2025)
- © 2025 Eiki Nakayama:
