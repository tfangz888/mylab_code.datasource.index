path:`$":/home/toby/data/datasource/baostock/daily"
files:key path / 所有文件

/ returnday:([date:`date$(); sym:`symbol$()];open:`float$();high:`float$();low:`float$();close:`float$();preclose:`float$(); volume:`long$();amount:`float$()) 
/ loadFile: {[path;file]d:("DSFFFFFJF";enlist ",") 0: ` sv path,file;t:select date, sym:code, open, high, low, close, preclose, volume, amount from d}
returnday:([date:`date$(); sym:`symbol$()];return:`float$(); amount:`float$()) 
loadFile: {[path;file]d:("DSFFFFFJF";enlist ",") 0: ` sv path,file;t:select date, sym:code, return:100* log close % preclose, amount from d}

`returnday upsert raze loadFile[path] each files

codes: `#exec distinct sym from returnday / 从table中取得所有的symbol

/ 先排序，然后去掉开始上市10天的log returns
t:([date:`date$(); sym:`g#`symbol$()];return:`float$(); amount:`float$()) 
f:{[code]a:10_ select [<date] date, sym, return, amount from returnday where sym=code; a}
`t upsert raze f each codes


/ 去掉一天中涨幅头5%，尾5%，均权log return百分比
/ f: {removecount:`int$0.05*count x; list:(0-removecount) _ removecount _ asc x; avg list}
/ 成交量取平均后变为浮点数
/ 传进来的参数是个dict。先转成table, 再按收益率排序。返回收益率及成交金额的平均值
f: {t:flip x; removecount:`int$0.05*count x; t: flip (0-removecount) _ removecount _  `return xasc t; select avg return, avg amount from t}
/ t2: `date xasc f each select sym, return, amount by date from t
t2: `date xasc f each select return, amount by date from t

`:/home/toby/data/index/avgA_baostock.csv 0: csv 0: t2 / 存入CSV文件

\\


