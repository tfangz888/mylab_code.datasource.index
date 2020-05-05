/ 沪综合指数的日log收益率

quoteday:([date:`date$(); sym:`g#`symbol$()];open:`float$();high:`float$();low:`float$();close:`float$();volume:`long$();turnover:`real$()) /定义表, turnover是成交金额，32位single单精度型

file:`:/home/toby/data/datasource/tdx/all_data/vipdoc/sh/lday/sh000001.day
d:("iiiiieii";4 4 4 4 4 4 4 4)1:file
t:([] date:"D"$string d[0]; sym:`sh.000001; open:d[1] % 100.0f;high:d[2] % 100.0f;low:d[3] % 100.0f;close:d[4] % 100.0f;volume:`long$d[6];turnover:`real$d[5])
`quoteday upsert t

file:`:/home/toby/data/datasource/tdx/data/vipdoc/sh/lday/sh000001.day
/ 如果文件存在，则读取
if[file~key file; d:("iiiiieii";4 4 4 4 4 4 4 4)1:file; t:([] date:"D"$string d[0]; sym:`sh.000001; open:d[1] % 100.0f;high:d[2] % 100.0f;low:d[3] % 100.0f;close:d[4] % 100.0f;volume:`long$d[6];turnover:`real$d[5]); `quoteday upsert t]

t: select [<date] date, close, volume from quoteday /按日期排序
t: 1_select date, rateofreturn: 100* deltas log close, volume from t /取log收益率的差值

`:/home/toby/data/index/AShanghaiIndex.csv 0: csv 0: t
\\
