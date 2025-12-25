# Logarithmic



![test](https://github.com/Nakayama-Eiki/Logarithmic/actions/workflows/test.yml/badge.svg)

## *説明*

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

## *必要なソフトウェア*
- Python
  - テスト済みバージョン: 3.7〜3.10

## *テスト環境*
- Ubuntu 22.04.5  LTS (GitHub Actions / Remote Environment)

## *著作権*
- このソフトウェアパッケージは，GNU General Public License v3.0 (GPL-3.0) のもとで公開されています。
- このパッケージのコードは，24C1130 山下正悟に不具合を伝え助言をもらいながら自身の著作としたものです。
- © 2025 Eiki Nakayama
