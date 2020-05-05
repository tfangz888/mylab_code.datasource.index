to_sym:{[str] `$str}
codesBlock: codes inter to_sym each stks


/ 先排序，然后去掉开始上市10天的log returns
t:([date:`date$(); sym:`g#`symbol$()];return:`float$(); amount:`float$())
f:{[code]a:10_ select [<date] date, sym, return, amount from returnday where sym=code; a}
`t upsert raze f each codesBlock

/ 去掉一天中涨幅大于20%，小于-25%，均权log return百分比
/ 成交量取平均后变为浮点数
/ 传进来的参数是个dict。先转成table, 再按收益率排序。返回收益率及成交金额的平均值
f: {t:flip x; t: flip `return xasc t; select avg return, avg amount from t}
/ t2: `date xasc f each select sym, return, amount by date from t
t2: `date xasc f each select return, amount by date from t where return>-23.6 and return<19.1

file:`$":/home/toby/data/index/", oneBlockFile, ".csv"
file 0: csv 0: t2 / 存入CSV文件

