{$A-,B-,D+,E-,F-,G-,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X-,Y-}
{$M 65520,0,655360}
Program Image (input , output);
Const  Inputname           = 'Image.dat';{输入待识别文件的文件名}
       Fontname            = 'Font.dat';{输入模式文件的文件名}
       Outputname          = 'Image.out';{输出文件名}
       maxln               = 1200;{最大行数}
       size                = 20;{字符标准尺寸}
       sn                  = 27;{模式字符个数}
       samplestr{模式字符} : string[sn] = ' abcdefghijklmnopqrstuvwxyz';

Type   Strtype             = string[size];{一行字符01信息类型}
       FontType            = array[1 .. size] of strtype;{一标准字符信息类型}
Var    Font                : Array[1 .. sn] of FontType;{标准字符信息}
       cost , from         : Array[0 .. maxln] of Integer;
                           {COST[P]表示前P行识别失真次数;
                            FROM[P]表示决策的前一阶段位置}
       ans                 : Array[1 .. maxln] of char;{识别结果}
       ln                  : integer;{识别总字符数}

Procedure Initalize;{初始化过程}
Var    fp                  : text;{输入文件指针}
       i , j               : integer;{辅助变量}
Begin
  {清零}
  Fillchar (ans , sizeof(ans) , 0);
  fillchar (cost , sizeof(cost) , 0);
  fillchar (from , sizeof(from) , 0);
  fillchar (font , sizeof(font) , 0);
  {读入标准字符}
  assign (fp , Fontname);
  reset (fp);
  readln (fp);
  for i :=1 to sn do
    begin
      for j :=1 to size do
        begin
          readln (fp , font[i][j]);
        end;
    end;
  close (fp);
end; {Initalize}

Procedure Solve;{求解过程}
Type   ResType{20*20识别信息}= array[1 .. sn , 0 .. size] of integer;
                       {RESTYPE[K,J]表示第K个字符识别前J行的总失真数}
Var    fp                  : text;{文件指针}
       Rescost             : Array[-1 .. 1] of Restype;
                             {当前阶段为第I行,则
                       RESCOST[-1]表示第I-1行前的20行与各标准字符识别的结果;
                       RESCOST[0 ]表示第I  行前的20行与各标准字符识别的结果;
                       RESCOST[1 ]表示第I+1行前的20行与各标准字符识别的结果}
       i , j , k , p , q   : integer;{辅助变量}
       oneImage            : FontType;{当前20行图象}
       oneline             : StrType;{当前行}

Procedure GetDist (rp , sp , comsize: integer);
{计算RESCOST[RP,SP,1..COMSIZE]的结果}
Var    i , j , k           : integer;{辅助变量}
Begin
  {清零}
  fillchar (rescost[rp , sp] , sizeof(rescost[rp , sp]) , 0);
  for i :=1 to comsize do{计算}
    begin
      rescost[rp,sp , i+size-comsize] :=rescost[rp,sp,i+size-comsize-1];
      for j :=1 to size do
      if oneimage[i , j] <> font[sp , i + size - comsize, j]{失真}
      then inc (rescost[rp , sp , i+size-comsize]);{累计}
    end;
end; {Getdist}

Begin
  {清零}
  Fillchar (ResCost , sizeof(ResCost) , 0);
  {读入待识别文件}
  assign (fp , inputname);
  reset (fp);
  readln (fp , ln);
  for i :=0 to ln do
    begin
      if i > 0 then cost[i] :=maxint{初值}
               else cost[i] :=0;{边界}
      Rescost[-1] :=Rescost[0]; Rescost[0] :=Rescost[1];{RESCOST转移}
      if i + 1 > size then{若当前行>=标准字符行数}
            begin
              for j :=2 to size do{当前图像转移}
                oneimage[j - 1] :=oneimage[j];
              if i + 1 <= ln
                then readln (fp , oneimage[size]){当前行不是最末行,则读入一行}
                else oneimage[size] :=oneimage[size - 1];{否则,最末为0行}
              for j :=1 to sn do{对所有样板识别统计}
                begin
                  Getdist (1 , j , size);
                end;
            end
          else begin{当前行<标准字符行数}
                 if i + 1 <= ln
                   then {当前行不是最末行,则读入一行}
                     readln (fp , oneimage[i + 1])
                   else {否则,最末为前一行的复制}
                     oneimage[i + 1] :=oneimage[i];

                 for j :=1 to sn do{对所有样本识别统计}
                   begin
                     Getdist (1 , j , i + 1);
                   end;
               end;
      if i < size -1  then continue;{边界情况}
      {动态规划状态转移}
      for j :=1 to sn do
        Begin
          if (i >= size - 1)
            and (cost[i - (size-1)] < cost[i])
            then begin{当前字符假定行数为(SIZE-1=19)}
                   for k :=1 to size do{选择策略}
                     if cost[i-(size-1)]+Rescost[1,j,k-1]
                                        +Rescost[0,j,size]
                                        -Rescost[0,j,k] < cost[i] then
                     begin{可改进}
                       cost[i] :=cost[i-(size-1)]+Rescost[1,j,k-1]
                                                 +Rescost[0,j,size]
                                                 -Rescost[0,j,k];{替换}
                       from[i] :=i - (size - 1);{决策记录}
                       ans[i] :=samplestr[j];{识别结果记录}
                     end;
                 end;
          if (i >= size) and (cost[i - size] < cost[i])
            then begin{当前字符假定行数为SIZE=20}
                   if (cost[i - size] + resCost[0 , j , size] < cost[i])
                     then begin{可改进}
                            {替换}
                            cost[i] :=cost[i - size] + rescost[0 , j , size];
                            from[i] :=i - size;{决策记录}
                            ans[i] :=samplestr[j];{识别结果记录}
                          end;
                 end;
          if (i >= size + 1) and (cost[i - (size + 1)] < cost[i])
            then begin{当前字符假定行数为SIZE=20}
                   for k :=2 to size + 1 do
                     if cost[i-(size+1)]+ResCost[-1,j,k-1]
                                        +ResCost[0,j,size]
                                        -ResCost[0,j,k-1] < cost[i]
                       then begin{可改进}
                              cost[i] :=Cost[i-(size+1)]
                                        + resCost[-1,j,k-1]
                                        + ResCost[0,j,size]
                                        - resCost[0,j,k-1];{替换}
                              from[i] :=i - (size + 1);{决策记录}
                              ans[i] :=samplestr[j];{识别结果记录}
                            end;
                 end;
        end;
    end;
  close (fp);{关闭文件}
end; {Solve}

Procedure Printout;{输出过程}
Var    fp                  : text;{输出文件指针}
       i , j               : integer;{辅助变量}
       result              : string;
Begin
  i :=ln;   result :='';{初始赋值}
  While i <> 0 do
    begin{记录结果}
      result :=ans[i] + result;
      i :=from[i];
    end;
  {文件输出}
  assign (fp , outputname);
  rewrite (fp);
  writeln (fp , result);
  close (fp);
  writeln ('Cost = ' , cost[ln]);{屏幕打印失真总数}
end; {Printout}

Begin
  Initalize;{初始化}
  Solve;{求解过程}
  Printout;{输出结果}
end. {main}