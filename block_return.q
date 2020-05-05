pathBlockGn:`$":/home/toby/data/datasource/pytdx/block/block_gn"
blockGnFiles: key pathBlockGn

oneBlockFile:""
stks:()

calculteBlockReturn:{[oneBlock] stks:: read0 (` sv pathBlockGn,oneBlock); oneBlockFile::string oneBlock; system "l /home/toby/mylab/index
/one_block_return.q";}

////////////////////////////////////////////////////////////////////////////////
system "l /home/toby/mylab/datasource/baostock/load_return_all.q" /装入全部数据

////////////////////////////////////////////////////////////////////////////////
calculteBlockReturn each blockGnFiles /计算板块数据并存成csv文件


