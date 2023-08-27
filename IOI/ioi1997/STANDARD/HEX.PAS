program Hex;
  {HGF 1998-4-4}
  {˵����������û�еõ����Կ����
           ֻ�ò��ü�������ķ�ʽ��
         ��ʼ״̬���ļ����벢�������Ļ}
  uses Crt;
  const
    NameIn='HEX.DAT';                                 {��ʼ״̬�ļ���}
    Move:array[1..6,1..2]of ShortInt=                       {��������}
         ((1,0),(1,1),(0,-1),(0,1),(-1,-1),(-1,0));
    Strs:array[0..2]of Char=('�','x','o');              {��Ļ�ϵ���ʾ}
    Max=20;                                                 {�������}
  var
    Data:array[1..Max,1..Max]of ShortInt;                   {����״̬}
    n,x,y:Integer;
  procedure DataIn;                                     {�����ʼ״̬}
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
  procedure Print(x,y:Integer);                           {�������Ļ}
    begin
      GotoXY((n-x)+y*2,x+2);
      Write(Strs[Data[x][y]],#8)
    end; {of Print}
  procedure PrintState;                                 {�����������}
    var
      i,j:Integer;
    begin
      Clrscr;
      for i:=1 to n do
        for j:=1 to n do
          Print(i,j)
    end; {of PrintState}
  procedure CheckWinA;                                  {�ж��ҷ�ʤ��}
    var
      Q:array[1..Max*Max,1..2]of Integer;                       {����}
      b:array[1..Max,1..Max]of Boolean;                         {���}
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
      while Q1<=Q2 do                                       {��������}
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
                    if xx=n then                            {�ҷ���ʤ}
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
  procedure CheckWinB;                                  {�ж϶Է���ʤ}
    var
      Q:array[1..Max*Max,1..2]of Integer;                       {����}
      b:array[1..Max,1..Max]of Boolean;                         {���}
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
      while Q1<=Q2 do                                       {��������}
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
                    if yy=n then                            {�Է���ʤ}
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
  procedure BGetXY(var x,y:Integer);                        {�Է��ж�}
    {���ضԷ����ӵ�λ��(x,y)}
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
  procedure AGetXY(var x,y:Integer);                        {�ҷ��ж�}
    {�����ҷ����ӵ�λ��(x,y)}
    var
      i,j,k,xx,yy:Integer;
      Temp:Longint;
      d:array[1..Max,1..Max]of Word;                    {��̬�滮����}
      p:array[1..Max,1..Max,1..2]of Byte;               {��¼·������}
      v:array[1..100,1..2]of Byte;                  {��һ���Ŀ���λ��}
      z:array[1..100]of Byte;                       {��з����ӵľ���}
      pv:Byte;                                         {����λ����Ŀ} 
      Poss:Longint;       
      Zero:Byte;
      Quit:Boolean;
    begin
      FillChar(d,SizeOf(d),255);
      for i:=1 to n do                                  {��̬�滮�߽�}
        case Data[i,1] of
          0:d[i,1]:=1;
          2:d[i,1]:=0
        end;
      FillChar(p,SizeOf(p),0);
      repeat                                            {��̬�滮����}
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
                        begin                                   {����}
                          d[xx,yy]:=Temp;
                          p[xx,yy][1]:=i;
                          p[xx,yy][2]:=j;
                          Quit:=False
                        end
                    end
                end;
      until Quit;                                       {��̬�滮����}

      Temp:=65535;
      for i:=1 to n do
        if d[i,n]<Temp then
          Temp:=d[i,n];                               {�����СȨ·��}
      {������һ������λ��}
      pv:=0;
      for i:=1 to n do
        if d[i][n]=Temp then
          begin
            x:=i;
            y:=n;
            Zero:=0;
            while x<>0 do
              begin
                if (Data[x,y]=0) and (pv<100) then          {����λ��}
                  begin
                    Inc(pv);
                    Inc(Zero);         {�����뿪�Է����ӵ�λ��С����2}
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
      {�����һ��λ��}
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
    DataIn;                                         {�������̳�ʼ״̬}
    PrintState;                                             {�������}
    CheckWinA;                                          {�Ƿ��ҷ���ʤ}
    CheckWinB;                                         {�Ƿ�Է���ʤ} 
    repeat
      AGetXY(x,y);                                          {�ҷ�����}
      Data[x,y]:=1;
      Print(x,y);
      CheckWinA;                                        {�ж��ҷ���ʤ}
      BGetXY(x,y);                                          {�Է�����}
      Data[x,y]:=2;
      Print(x,y); 
      CheckWinB                                         {�ж϶Է���ʤ}
    until False
  end.