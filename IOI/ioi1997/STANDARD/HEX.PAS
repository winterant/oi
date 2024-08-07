program Hex;
  {HGF 1998-4-4}
  {说明：由于我没有得到测试库程序，
           只好采用键盘输入的方式，
         初始状态由文件输入并输出到屏幕}
  uses Crt;
  const
    NameIn='HEX.DAT';                                 {初始状态文件名}
    Move:array[1..6,1..2]of ShortInt=                       {六个方向}
         ((1,0),(1,1),(0,-1),(0,1),(-1,-1),(-1,0));
    Strs:array[0..2]of Char=('�','x','o');              {屏幕上的显示}
    Max=20;                                                 {最大棋盘}
  var
    Data:array[1..Max,1..Max]of ShortInt;                   {棋盘状态}
    n,x,y:Integer;
  procedure DataIn;                                     {输入初始状态}
    var
      f:Text;
      i,j:Integer;
    begin
      Assign(f,NameIn);
      Reset(f);
      ReadLn(f,n);
      for i:=1 to n do
        begin
          for j:=1 to n do
            Read(f,Data[i,j]);
          ReadLn(f)
        end;
      Close(f)
    end; {of DataIn}
  procedure Print(x,y:Integer);                           {输出到屏幕}
    begin
      GotoXY((n-x)+y*2,x+2);
      Write(Strs[Data[x][y]],#8)
    end; {of Print}
  procedure PrintState;                                 {输出整个棋盘}
    var
      i,j:Integer;
    begin
      Clrscr;
      for i:=1 to n do
        for j:=1 to n do
          Print(i,j)
    end; {of PrintState}
  procedure CheckWinA;                                  {判断我方胜利}
    var
      Q:array[1..Max*Max,1..2]of Integer;                       {队列}
      b:array[1..Max,1..Max]of Boolean;                         {标记}
      Q1,Q2,Q3,i,j,xx,yy:Integer;
    begin
      FillChar(b,SizeOf(b),True);
      Q1:=1; Q2:=0;
      for i:=1 to n do
        if Data[1,i]=1 then
          begin
            Inc(Q2);
            Q[Q2][1]:=1;
            Q[Q2][2]:=i;
            b[1,i]:=False
          end;
      while Q1<=Q2 do                                       {宽度搜索}
        begin
          Q3:=Q2+1;
          for i:=Q1 to Q2 do
            for j:=1 to 6 do
              begin
                xx:=Q[i][1]+Move[j,1];
                yy:=Q[i][2]+Move[j,2];
                if (xx>=1) and (yy>=1) and (xx<=n) and (yy<=n) and
                   (Data[xx,yy]=1) and (b[xx,yy]) then
                  begin
                    Inc(Q2);
                    Q[Q2][1]:=xx;
                    Q[Q2][2]:=yy;
                    b[xx,yy]:=False;
                    if xx=n then                            {我方获胜}
                      begin
                        GotoXY(1,1);
                        WriteLn('I Win');
                        Halt
                      end
                  end
              end;
          Q1:=Q3
        end
    end; {of CheckWinA}
  procedure CheckWinB;                                  {判断对方获胜}
    var
      Q:array[1..Max*Max,1..2]of Integer;                       {队列}
      b:array[1..Max,1..Max]of Boolean;                         {标记}
      Q1,Q2,Q3,i,j,xx,yy:Integer;
    begin
      FillChar(b,SizeOf(b),True);
      Q1:=1; Q2:=0;
      for i:=1 to n do
        if Data[i,1]=2 then
          begin
            Inc(Q2);
            Q[Q2][1]:=i;
            Q[Q2][2]:=1;
            b[i,1]:=False
          end;
      while Q1<=Q2 do                                       {宽度搜索}
        begin
          Q3:=Q2+1;
          for i:=Q1 to Q2 do
            for j:=1 to 6 do
              begin
                xx:=Q[i][1]+Move[j,1];
                yy:=Q[i][2]+Move[j,2];
                if (xx>=1) and (yy>=1) and (xx<=n) and (yy<=n) and
                   (Data[xx,yy]=2) and (b[xx,yy]) then
                  begin
                    Inc(Q2);
                    Q[Q2][1]:=xx;
                    Q[Q2][2]:=yy;
                    b[xx,yy]:=False;
                    if yy=n then                            {对方获胜}
                      begin
                        GotoXY(1,1);
                        WriteLn('I Lost');
                        Halt
                      end
                  end
              end;
          Q1:=Q3
        end
    end; {of CheckWinB}
  procedure BGetXY(var x,y:Integer);                        {对方行动}
    {返回对方走子的位置(x,y)}
    var
      c:Char;
    begin
      repeat
        c:=ReadKey;
        if c=#0 then
          begin
            case ReadKey of
              'H':if x<>1 then Dec(x);
              'K':if y<>1 then Dec(y);
              'P':if x<>n then Inc(x);
              'M':if y<>n then Inc(y)
            end;
            GotoXY((n-x)+y*2,x+2);
          end;
        if c=#27 then Halt
      until (c=#13) and (Data[x,y]=0)
    end; {of BGetXY}
  procedure AGetXY(var x,y:Integer);                        {我方行动}
    {返回我方走子的位置(x,y)}
    var
      i,j,k,xx,yy:Integer;
      Temp:Longint;
      d:array[1..Max,1..Max]of Word;                    {动态规划数组}
      p:array[1..Max,1..Max,1..2]of Byte;               {记录路径父辈}
      v:array[1..100,1..2]of Byte;                  {下一步的可能位置}
      z:array[1..100]of Byte;                       {与敌方棋子的距离}
      pv:Byte;                                         {可能位置数目} 
      Poss:Longint;       
      Zero:Byte;
      Quit:Boolean;
    begin
      FillChar(d,SizeOf(d),255);
      for i:=1 to n do                                  {动态规划边界}
        case Data[i,1] of
          0:d[i,1]:=1;
          2:d[i,1]:=0
        end;
      FillChar(p,SizeOf(p),0);
      repeat                                            {动态规划过程}
        Quit:=True;
        for i:=1 to n do
          for j:=1 to n do
            if d[i,j]<>65535 then
              for k:=1 to 6 do
                begin
                  xx:=i+Move[k,1];
                  yy:=j+Move[k,2];
                  if (xx>=1) and (yy>=1) and (xx<=n) and (yy<=n) and (Data[xx,yy]<>1) then
                    begin
                      if Data[xx,yy]=2
                      then Temp:=d[i,j]
                      else Temp:=d[i,j]+1;
                      if Temp<d[xx,yy] then 
                        begin                                   {更新}
                          d[xx,yy]:=Temp;
                          p[xx,yy][1]:=i;
                          p[xx,yy][2]:=j;
                          Quit:=False
                        end
                    end
                end;
      until Quit;                                       {动态规划结束}

      Temp:=65535;
      for i:=1 to n do
        if d[i,n]<Temp then
          Temp:=d[i,n];                               {求出最小权路径}
      {计算下一步可能位置}
      pv:=0;
      for i:=1 to n do
        if d[i][n]=Temp then
          begin
            x:=i;
            y:=n;
            Zero:=0;
            while x<>0 do
              begin
                if (Data[x,y]=0) and (pv<100) then          {可能位置}
                  begin
                    Inc(pv);
                    Inc(Zero);         {控制离开对方棋子的位置小等于2}
                    if Zero=5 then
                      begin
                        v[pv-2]:=v[pv-1];
                        Dec(pv);
                        Dec(Zero)
                      end;
                    v[pv][1]:=x;
                    v[pv][2]:=y;
                    z[pv]:=Zero
                  end;
                if Data[x,y]<>0 then
                  for j:=Zero downto Zero div 2+1 do
                    z[pv+j-Zero]:=Zero-j+1;
                j:=x;
                x:=p[j][y][1];
                y:=p[j][y][2]
              end
          end;
      {随机找一个位置}
      Poss:=0;
      for i:=1 to pv do Inc(Poss,z[i]);
      Temp:=Random(Poss)+1;
      i:=1;
      while Temp>0 do
        begin
          Dec(Temp,z[i]);
          Inc(i)
        end;
      Dec(i);
      x:=v[i][1];
      y:=v[i][2];
    end;
  begin
    Randomize;
    DataIn;                                         {输入棋盘初始状态}
    PrintState;                                             {输出棋盘}
    CheckWinA;                                          {是否我方获胜}
    CheckWinB;                                         {是否对方获胜} 
    repeat
      AGetXY(x,y);                                          {我方走子}
      Data[x,y]:=1;
      Print(x,y);
      CheckWinA;                                        {判断我方获胜}
      BGetXY(x,y);                                          {对方走子}
      Data[x,y]:=2;
      Print(x,y); 
      CheckWinB                                         {判断对方获胜}
    until False
  end.
