{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}
Program Mars (input , output);
Const  Inputname           = 'Mars.dat';{输入文件名}
       Outputname          = 'Mars.out';{输出文件名}
       maxsize             = 128;{地图尺寸}
       maxleft             = 30;{对于用网络流处理的最大规模即剩余的2号顶点数}
       maxnode             = maxleft * 2 + 3;{网络图结点数上限}

Type   maptype             = Array[1 .. maxsize , 1 .. maxsize] of byte;
                           {地图类型}
       Gtype               = array[1 .. maxnode , 1 .. maxnode] of integer;
                           {图类型}
       Direct              = (None , Pod , South , East);{方向枚举烈性}
       FromType            = Array[1 .. maxsize , 1 .. maxsize] of Direct;
                           {路径记录类型}
Var    map                 : Maptype;{地图}
       n , p , q           : integer;{N--路径数,(P,Q)--地图尺寸}

Procedure Initalize;{初始化过程}
Var    fp                  : text;{文件指针}
       i , j               : integer;{辅助变量}
Begin
  {清零}
  fillchar (map , sizeof(map) , 0);
  {读入数据}
  assign (fp  , Inputname);
  reset (fp);
  readln (fp , n);
  readln (fp , p); readln (fp , q);
  for i :=1 to q do
    begin
      for j :=1 to p do
          read (fp , map[i , j]);
      readln (fp);
    end;
  close (fp);
  {动态规划将MAP中不可达(p,q)的点都设为1}
  for i :=q downto 1 do
    for j :=p downto 1 do
      begin
        if (i = q) and (j = p)
          then
          else begin
                 if (i < q) and (map[i + 1 , j] <> 1)
                   then
                   else if (j < p) and (map[i , j + 1] <> 1)
                          then
                          else map[i , j] :=1;
               end;
      end;
end; {initalize}

Procedure Solve;{求解过程}
Var    i , j               : integer;{辅助变量}
       fp                  : text;{文件指针}
       Dist                : Maptype;{各点可达矩阵:从起点出发经过的最多岩石数}
       From                : Fromtype;{各点在路径中行走方向}
       testp               : integer;{辅助变量}
       left                : integer;{剩余未决策的2号顶点数}

Procedure GetFrom;
{动态规划决定可达矩阵:起点到各点经过最多岩石数,并贪心选择当前路径}
Var    i , j , k           : integer;{辅助变量}
Begin
  {清零}
  left :=0;
  fillchar (from , sizeof(from) , 0);
  fillchar (dist , sizeof(dist) , 0);
  {动态规划,从(1,1)出发}
  for i :=1 to q do
    for j :=1 to p do
      begin
        if (i = 1) and (j = 1)
          then begin{边界情况}
                 if map[i , j] <> 1
                   then begin {起点没有障碍}
                          from[i , j] :=Pod;
                          dist[i , j] :=0;
                        end
                   else from[i , j] :=None;{无路径}
               end
          else begin
                 if (i > 1) and (from[i - 1 , j] <> None)
                   and (map[i , j] <> 1)
                 then begin{可以通过朝南到达,规划}
                        from[i , j] :=South;
                        if map[i , j] = 2{当前点有岩石}
                          then dist[i , j] :=dist[i - 1 , j] + 1{岩石数+1}
                          else dist[i , j] :=dist[i - 1 , j];
                      end
                 else from[i , j] :=None;{无路径}
                 if (j > 1) and (from[i , j - 1] <> None)
                    and (map[i , j] <> 1)
                    and ((from[i , j] = None)
                        or (dist[i , j - 1] > dist[i - 1 , j]))
                    then begin{朝东可达,并且经过岩石更多}
                           from[i , j] :=East;
                           if map[i , j] = 2{当前点有岩石}
                             then dist[i , j] :=dist[i , j- 1] + 1{岩石数+1}
                             else dist[i , j] :=dist[i , j- 1];
                         end;
               end;
        if (map[i , j] = 2) and (from[i , j] <> NONE)
          then inc (left);{剩余岩石数}
      end;
end; {GetFrom}

Procedure Printway (ri , rj : integer);
{回溯递归输出(RI,RJ)出发的路径}
Begin
  Case from[ri , rj] of
    South : Begin{朝南}
              Printway (ri - 1 , rj);{递归}
              writeln (fp ,testp , ' ',  0);{输出当前点及方向}
            end;
    East : Begin{朝东}
             Printway (ri , rj - 1);
             writeln (fp , testp , ' ' , 1);{输出当前点及方向}
           end;
  end;
  map[ri , rj] :=0;
end; {Printway}

Procedure solve2;{网络流算法}
Var    Cont , Price , Ans  : ^Gtype;
       {CONT--容量上限;PRICE--流量单位费用;ANS--可行流}
       s , t               : integer;{S:超级源,T--始末点}
       midp                : integer;{辅助点}
       nodeset             : Array[1 .. maxleft , 1 .. 2] of byte;
                           {网络结点对应MAP中的位置}
       get           : Fromtype;{MAP中各点可达性矩阵:点在路径上的移动方向}

Procedure GetGet (si , sj : integer);
{返回从(SI,SJ)出发的各点可达性矩阵GET}
Var    i , j , k           : integer;{辅助变量}
Begin
  {清零}
  fillchar (get , sizeof(get) , NONE);
  {动态规划}
  for i :=si to q do
    for j :=sj to p do
      begin
        if map[i , j] = 1
          then begin{障碍物}
                 get[i , j] :=None;{无路径}
                 continue;
               end;
        if (i = si) and (j = sj)
          then get[i , j] :=Pod{起点}
          else begin
                 if (i > si) and (get[i - 1 , j] <> NONE)
                   then get[i , j] :=South{朝南可达}
                   else if (j > sj) and (get[i , j - 1] <> NONE)
                          then get[i , j] :=East;{朝东可达}
               end;
      end;
end; {GetGet}

Procedure MakeGraph;{构造问题对应网络}
Var    i , j , k           : integer;{辅助变量}
Begin
  {清零}
  fillchar (cont^ , sizeof(cont^) , 0);
  Fillchar (Price^ , sizeof(Price^) , 0);
  {获得NODESET,将网络中的结点与MAP中的可达的2号位置对应}
  k :=0;
  for i :=1 to q do
    for j :=1 to p do
      if (map[i , j] = 2) and (From[i , j] <> NONE)
        then begin{可达的2号位置}
               inc (k);
               nodeset[k , 1] :=i;
               nodeset[k , 2] :=j;
             end;
  {构造网络}
  s :=2 * left + 1;{超级源} midp :=2 * left + 2;{辅助点}
  t :=2 * left + 3;{汇点}
  {建立S-MIDP的边,控制容量即路径数}
  cont^[s , midp] :=n-testp+1; price^[s , midp] :=0;
  for i :=1 to left do
    begin
      GetGet (nodeset[i,1] , nodeset[i,2]);{获得当前位置出发的各点可达矩阵}
      {拆分两个点,控制点权,及记录次数}
      Cont^[i , Left + i] :=1; Price^[i , left + i] :=0;
      for j :=1 to left do
        if (i <> j) and (get[nodeset[j,1] , nodeset[j,2]] <> NONE) then
        begin{J点与I点可达,建立边,设定容量和权}
        {1.表示不采集岩石的边}
          Cont^[i , j] :=n-testp+1;
          price^[i , j] :=
            (nodeset[j,1]-nodeset[i,1])+(nodeset[j,2]-nodeset[i,2]);
        {2.表示采集岩石的边}
          Cont^[left + i , j] :=1;
          Price^[left + i , j] :=
            (nodeset[j,1]-nodeset[i,1])+(nodeset[j,2]-nodeset[i,2])-1;
        end;
      {与MIDP建立边}
      price^[midp , i] :=nodeset[i,1] + nodeset[i,2];
      cont^[midp , i] :=n-testp+1;
      {与汇建立边}
      {1.表示不采集的边}
      price^[i , t] :=q-nodeset[i , 1]+p-nodeset[i,2] + 1;
      cont^[i , t] :=n-testp+1;
      {2.表示采集的边}
      price^[left + i , t] :=q-nodeset[i , 1]+p-nodeset[i,2];
      cont^[left + i , t] :=1;
    end;
EnD; {makeGraph}

Procedure MinFlow;{求网络的最小费用最大流}
Var    i , j , k           : integer;{辅助变量}
       nd , np             : ^Gtype;{ND--最短路径距离信息;
                                     NP--最短路径前驱信息}
       delta               : integer;{网络流的改变量}

Procedure MakeW;{构造新图}
var    i , j , k           : integer;{辅助变量}

Begin
  {清零}
  fillchar (nd^ , sizeof(nd^) , 0);
  fillchar (np^ , sizeof(np^) , 0);
  for i :=1 to t do
    for j :=1 to t do
      begin
        if ans^[i , j] < cont^[i , j]
          then begin{流量<容量}
                 nd^[i , j] :=price^[i , j];{建立正向正边}
                 np^[i , j] :=i;
               end;
        if ans^[i , j] > 0
          then begin{流量>0}
                 nd^[j , i] :=-price^[i , j];{建立逆向负边}
                 np^[j , i] :=j;
               end;
      end;
end; {MakeW}

Procedure GetPath;{求最短路径}
Var    i , j , k           : integer;{辅助变量}
Begin
  {动态规划Floyd算法}
  for i :=1 to t do
    for j :=1 to t do
      for k :=1 to t do
        if (np^[j , i] > 0) and (np^[i , k] > 0) and
          ((np^[j ,k] =0) or (nd^[j , i] + nd^[i , k] < nd^[j , k]))
        then begin{规划}
               np^[j , k] :=np^[i , k];
               nd^[j , k] :=nd^[j , i] + nd^[i , k];
             end;
end; {Getpath}

Procedure GetDelta;{求流改变量}
Var    i , j               : integer;{辅助变量}
Begin
  {清零}
  delta :=0;
  {初值}
  j :=t;
  while j <> s do
    begin
      i :=np^[s , j];
      if (ans^[i , j] < cont^[i , j])
        and ((delta = 0) or (cont^[i , j] - ans^[i , j] < delta))
        then delta :=Cont^[i , j] - ans^[i , j];{正向边}
      if (ans^[j , i] > 0) and
        ((delta = 0) or (ans^[j , i] < delta))
      then delta :=ans^[j , i];{逆向边}
      j :=i;
    end;
end; {Getdelta}


Procedure ChangeAns;{改变流量}
var    i , j , k           : integer;{辅助变量}
Begin
  j :=t;
  while j <> s do
    begin
      i :=np^[s , j];
      if (ans^[i , j] < cont^[i , j])
        then ans^[i , j] :=ans^[i , j] + delta;{正向边}
      if (ans^[j , i] > 0)
      then ans^[j , i] :=ans^[j , i] - delta;{逆向边}
      j :=i;
    end;
end; {ChangeAns}

Begin
  {清零}
  fillchar (ans^ ,sizeof(ans^) , 0);
  new (np); new (nd);{审清空间}
  repeat
    MakeW;{构造新图}
    GetPath;{求最短路径}
    if np^[s , t] <> 0
      then begin{存在最短路径}
             GetDelta;{计算流量改变量}
             ChangeAns;{改变流量}
           end;
  Until np^[s,t] = 0;{直到不存在路径}
  dispose (np); dispose (nd);{释放空间}
end; {minFlow}

Procedure Print2;{根据流ANS输出方案}
Var    i , j , k           : integer;{辅助变量}
       runp                : integer;{输出路径数}

Procedure Printroute (ri , rj : integer);{递归输出路线}
Begin
  Case get[ri , rj] of
    South : Begin{朝南}
              Printroute (ri - 1 , rj);{递归}
              writeln (fp ,runp , ' ',  0);{输出当前位置和移动方向}
            end;
    East : Begin{朝东}
             PrintRoute (ri , rj - 1);{递归}
             writeln (fp , runp , ' ' , 1);{输出当前位置和移动方向}
           end;
  end;
end; {Printroute}


Procedure DFS (root : integer);
{递归修正流量,输出各段路径}
var    next                : integer;{辅助变量,下一次访问的点}

Begin
  if root = t
    then{到达终点}
    else begin{未到达终点}
           if root > left
             then GetGet (nodeset[root-left,1] ,nodeset[root-left,2])
                  {是拆分后点,求对应位置的可达信息}
             else GetGet (nodeset[root,1] ,nodeset[root,2]);
                  {是拆分前点,求对应位置的可达信息}
           for next :=1 to t do
            if ans^[root , next] > 0
               then begin{流量>0,选择下一个访问结点}
                      if next <= left
                        then{下一个前点,输出两点之间的路径}
                          printroute (nodeset[next , 1] , nodeset[next,2])
                        else begin{当前点的后点}
                               if next = t
                                 then{到达终点,输出到达终点的路径}
                                   printroute (q , p);
                             end;
                      DFS (next);{递归}
                      dec (ans^[root , next]);{减少路径上的边的流量}
                      exit;
                    end;
         end;
end; {DFS}

Begin
  runp :=testp-1;{已经完成的路径数}
  repeat
    {获得第一个与MIDP连接的流量不为零的边指向的点}
    i :=1;
    While (i <= left) and (ans^[midp , i] = 0) do
      inc (i);
    if i <= left
      then begin{存在这样的点}
             inc (runp);{路线数+1}
             GetGet (1 , 1);{获得起点到各点的路径信息}
             {输出起点到第一个岩石点路线}
             Printroute (nodeset[i,1] , nodeset[i,2]);
             DFS (i);{输出路径,修正路径对应流量}
             dec (ans^[midp , i]);{修正起点出发的流量}
           end;
  Until i > left;
end; {Print2}

Begin
  New (ans); new (cont); New (price);{审清空间}
  MakeGraph;{构造问题对应网络}
  MinFlow;{求对应网络的最小费用最大流}
  Print2;{输出LEFT条路}
  Dispose (ans); dispose (cont); dispose (price);{释放空间}
end; {Solve2}

Begin
  {设置输出文件}
  assign (fp , outputname);
  rewrite (fp);
  for testp :=1 to n do{决定N条路径}
    begin
      GetFrom;{动态规划得到各点可达信息,贪心选择含岩石最多的当前路径}
      if (left <= maxleft) and (left <> 0)
        then begin{如果规模<=MAXLEFT}
               Solve2;{网络流算法}
               break;{退出}
             end;
      Printway (q , p);{输出路径}
    end;
  close (fp);{关闭输出文件}
end; {Solve}

Begin
  Initalize;{初始化}
  Solve;{求解过程}
end. {main}