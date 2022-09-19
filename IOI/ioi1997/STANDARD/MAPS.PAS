{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
Program Maps (input , output);
Const  Mapsize             = 1000;{地图尺寸}
       MaxN                = 1000;{城市总数上限}
       Inputname           = 'Maps.dat';{输入文件名}
       outputname          = 'Maps.out';{输出文件名}
       Outname1            = 'outa.txt';{针对最小覆盖集贪心算法}
       outname2            = 'outb.txt';{针对最大独立集贪心算法}

Type   Tpos                = record{坐标位置类型}
                               x , y : integer;{横纵坐标}
                             end;
       TRect               = record{可放置位置类型}
                               num : Integer;{位置属于的城市号}
                               lp , rp : TPos;{LP--左下端坐标;RP--右上端坐标}
                             end;
Var    RectSet             : Array[1 .. 4 * maxN] of Trect;{可放置标志位置表}
       Setlen              : Integer;{可放置位置总数}
       n                   : Integer;{城市数}

Procedure Initalize;{初始化过程}
Var    fp                  : text;{文件指针}
       i, j                : integer;{辅助变量}
       getx , gety ,
       getw , geth , getl  : integer;{读入变量与相关信息}
       namestr             : string;{城市名}
       center              : Array[1 .. maxn] of TPos;{城市中心位置表}

Function InMap (comlp , comrp : Tpos) : Boolean;
{判定Comlp-Comprp矩形位置是否在地图中}
Begin
  inmap :=(comlp.x >=0) and (comlp.y >= 0)
          and (comrp.x < Mapsize) and (comrp.y < Mapsize){判断}
end; {InMap}

Procedure InSet (InNum , Inlpx , inlpy , inrpx , inrpy : Integer);
{如果INNUM号城市的一个标签可放置位置(Inlpx,Inlpy)-(inrpx,inrpy)在地图中则
进入表RECSET中}
Var    nlp , nrp           : TPos;{辅助变量}
Begin
  {设定NLP,NRP}
  nlp.x :=inlpx; nlp.y :=inlpy;
  nrp.x :=inrpx; nrp.y :=inrpy;
  if InMap (nlp , nrp)
    then begin{判定是否在MAP中}
           {进入RECSET中}
           inc (setlen);
           With RectSet[setlen] do
             begin
               num :=InNum;
               lp :=nlp; rp :=nrp;
             end;
         end;
end; {InSet}

Procedure Swap (Var Rect1 ,Rect2 : TRect);{交换RECT1,RECT2}
Var    tmp                 : TRect;{辅助变量}
Begin
  tmp :=Rect1; Rect1 :=Rect2; Rect2 :=Tmp;{交换}
end; {Swap}

Function Contain (ComPos , comlp , comrp: TPos) : Boolean;
{判定点COMPOS是否在矩形位置COMLP-COMRP中}
begin
  contain :=(compos.x >=comlp.x) and (Compos.x <= comrp.x)
          and (compos.y >=comlp.y) and (Compos.y <= comrp.y);{判定}
end; {Contain}

Procedure Target (var oprstr : string);{将读入的OPRSTR中的空格去掉}
var    i                   : integer;{辅助变量}
begin
  {删去所有空格}
  i :=Pos(' ' , oprstr);
  while i <> 0 do
    begin
      delete (oprstr , i , 1);
      i :=Pos(' ' , oprstr);
    end;
end; {Target}

Begin
  {清零}
  Setlen :=0;
  Fillchar (RectSet , sizeof(RectSet) , 0);
  fillchar (center , sizeof(center) , 0);
  {读入文件}
  assign (fp , inputname);
  reset (fp);
  readln (fp , n);
  for i :=1 to n do
    begin
      readln (fp , getx , gety , getw , geth , namestr);{读入一个城市信息}
      target (namestr);{将NAMESTR中空格删除}
      getl :=length(namestr) + 1;{标签字符数为NAMESTR长度+1}
      {将当前城市周围四格可放置位置判定是否在MAP中,并将合理位置置入RECSET中}
      InSet (i , getx - getl*getw , gety + 1 , getx - 1 , gety + geth);
      InSet (i , getx - getl*getw , gety - geth , getx - 1 , gety - 1);
      InSet (i , getx + 1 , gety - geth , getx + getl*getw , gety - 1);
      InSet (i , getx + 1 , gety + 1 , getx + getl*getw , gety + geth);
      {记录城市中心位置}
      center[i].x :=getx; center[i].y :=gety;
    end;
  close (fp);
  {去掉所有覆盖城市中心位置的标签可放置位置}
  i :=1;
  While i <= Setlen do
    begin
      {对所有城市中心位置判定是否被当前矩形覆盖}
      j :=1;
      While (j <= n) and
        (not contain (center[j] , RectSet[i].lp , Rectset[i].rp))
      Do inc (j);
      if j <= n
        then begin{存在被覆盖的城市中心位置}
               {将当前位置在表中删除}
               Swap (rectSet[i] , Rectset[Setlen]);
               fillchar (rectset[setlen] ,sizeof(Rectset[setlen]) , 0);
               dec (Setlen);
             end
        else inc (i);{否则,考察下一个位置}
    end;
end; {initalize}

Procedure Solve;{解答过程}
Type   Arrtype = array[1 .. maxn * 4] of integer;{图顶点信息数组类型}
       AnsType = array[1 .. maxn * 4] of byte;{选择决策数组类型}
Var    deg                 : ArrType;{各顶点的度数}
       Ans1 , ans2         : anstype;{ANS1--针对最小覆盖集的决策;
                                      ANS2--针对最大独立集的决策;}
       selectn1 , selectn2 : integer;
       {SELECT1--针对最小覆盖集的决策求出的最多标记城市数;
        SELECT2--针对最大独立集的决策求出的最多标记城市数}

Function Min (com1 , com2 :integer) : integer;{MIN为COM1,COM2中较小者}
begin
  if com1 < com2
    then min :=com1
    else min :=com2;
end; {min}

Function max (com1 , com2 :integer) : integer;{MAX为COM1,COM2中较大者}
begin
  if com1 > com2
    then max :=com1
    else max :=com2;
end; {max}

Function Link (p1 , p2 : integer) : Boolean;
{判定第P1,P2号位置是否冲突,即在途中有无边相连}
Begin
  link :=(RectSet[p1].num = Rectset[p2].num){属于同一个城市} or
       ((max (RectSet[p1].lp.x , Rectset[p2].lp.x)
         <= min(Rectset[p1].rp.x , RectSet[p2].rp.x)) and
        (max (RectSet[p1].lp.y , Rectset[p2].lp.y)
         <= min(Rectset[p1].rp.y , RectSet[p2].rp.y)));{两个矩形相交}
end; {Link}

Procedure GetDeg;{计算顶点度数}
Var    i , j , k           : integer;{辅助变量}
Begin
  {清零}
  fillchar (Deg , sizeof(Deg) , 0);
  {计算度数}
  for i :=1 to Setlen do
    for j :=i + 1 to Setlen do
      if link (i , j){判定有无边}
      then
        begin{累积度数}
          inc (deg[i]);
          inc (deg[j]);
        end;
end; {Getdeg}

Procedure Greedy1 (indeg : Arrtype; var reans : AnsType; var ren : integer);
{对于度数INDEG,针对图的最小覆盖集得到选择标签的决策REANS,并返回由此得到的
最多标记城市数REN}
Var    root , nextr        : Integer;{ROOT--当前选择进入覆盖集的顶点;
                                      NEXTR-下一次选择的顶点}
       i , j , k           : integer;{辅助变量}
Begin
  {清零}
  ren :=0;
  fillchar (reans , sizeof(reans) , 0);
  root :=0;
  {选择度数最大的顶点作为第一个最小覆盖集元素}
  for i :=1 to setlen do
    if (root = 0) or (indeg[i] > indeg[root])
      then root :=i;
  While root <> 0 do{循环直到不存在度数大于0的点}
    begin
      {决策记录}
      inc (ren);
      reans[root] :=1;
      {去掉ROOT,改变图的度数,并选择下一次决策}
      nextr :=0;
      for i :=1 to setlen do
        if (reans[i] = 0) and (indeg[i] > 0)
          then begin{度数>0,并且没有被选择}
                 if link (i , root){判定是否与ROOT相连}
                    then dec (indeg[i]);{度数减1}
                 if (indeg[i] > 0) and ((nextr = 0)
                 or (indeg[i] >  indeg[nextr])){判定是否为最大度数}
                   then nextr :=i;{更替下一次决策}
               end;
      root :=nextr;{设定当前决策顶点}
    end;
  {最大独立集=最小覆盖集的补集}
  for i :=1 to setlen do
    begin
      reans[i] :=1 - reans[i];
    end;
  ren :=setlen - ren;
end; {Greedy1}

Procedure Printout (prans : Anstype; prn :integer;outname : string);
{输出决策PRANS中的位置,总共被决策的城市为PRN,输出文件名为OUTNAME}
Var    fp                  : text;{文件指针}
       i , j , k           : integer;{辅助变量}
       prpos               : Array[1 .. maxn] of TPos;
       {输出城市设定标签的左上端坐标}
Begin
  {将PRPOS的值都设为-1}
  fillchar (prpos , sizeof(prpos) , $FF);
  {由PRANS计算PRPOS}
  for i :=1 to setlen do
    if prans[i] = 1
      then begin{被决策}
             with RectSet[i] do
               begin{设定PRPOS}
                 prpos[num].x :=lp.x;
                 prpos[num].y :=rp.y;
               end;
           end;
  {输出}
  assign (fp , outname);
  rewrite (fp);
  for i :=1 to n do
    writeln (fp , prpos[i].x , ' ' ,prpos[i].y);{输出左上端位置}
  writeln ('Total number = ' , prn);{在屏幕中输出标签的城市总数}
  close (fp);
end; {Printout}

Procedure Greedy2 (indeg : Arrtype; var reans : AnsType; var ren : integer);
{对于度数INDEG,针对最大独立集的贪心算法,求得决策REANS,所得的总标签数为REN}
Var    root , nextr        : Integer;{ROOT--当前选择进入独立集的顶点;
                                      NEXTR-下一次选择的顶点}
       i , j , k           : integer;{辅助变量}
Begin
  {清零}
  ren :=0;
  fillchar (reans , sizeof(reans) , 0);
  {求得度数最小的顶点为第一个独立集元素}
  root :=0;
  for i :=1 to setlen do
    if (root = 0) or (indeg[i] < indeg[root])
      then root :=i;
  {贪心决策}
  While root <> 0 do{知道没有可选择的顶点}
    begin
      {记录决策信息}
      inc (ren);
      reans[root] :=1;
      {修正顶点信息}
      for i :=1 to setlen do
        if (reans[i] = 0) and (indeg[i] > 0)
          then begin{第I个顶点可以选择}
                 if link (i , root)
                    then Begin{与ROOT相连}
                           reans[i] :=2;{设定不可选择}
                           for j :=1 to setlen do
                             if (reans[j] = 0) and (indeg[j] > 0) and
                             link (i , j){与I相连}
                               then dec (indeg[j]);{减少度数}
                         end;
               end;
      {选择下一次决策}
      nextr :=0;
      for i :=1 to setlen do
        if (reans[i] = 0)
          and ((nextr = 0) or (indeg[i] < indeg[nextr]))
        then nextr :=i;{选取可选择的顶点中度数最小的顶点}
      root :=nextr;{确定当前决策}
    end;
end; {Greedy2}


Begin
  GetDeg;{计算度数}
(*  Greedy1 (deg , Ans1 , selectn1);*){针对最小覆盖集的贪心算法}
{  Printout (ans1 , selectn1 , outname1);}
   Greedy2 (deg , Ans2 , selectn2);{针对最大独立集的贪心算法}
{  Printout (ans2 , selectn2 , outname2);}
(* if selectn1 > selectn2{选择两个算法中的较优方案输出}
    then Printout (ans1 , selectn1 , outputname)
    else*) Printout (ans2 , selectn2 , outputname)
End; {Solve}

Begin
  Initalize;{初始化}
  Solve;{求解}
end. {main}