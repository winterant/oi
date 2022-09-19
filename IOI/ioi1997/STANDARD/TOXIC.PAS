{$M 65520,0,655360}
program Toxic;
  {HGF 1998-3-24}
  const
    NameIn ='TOXIC.DAT';                                    {输入文件}
    NameOut='TOXIC.OUT';                                    {输出文件}
    Move:array[1..6,1..3]of ShortInt=                    {6个移动方向}
         ((0,0,1),(0,0,-1),
          (0,1,0),(0,-1,0),
          (1,0,0),(-1,0,0));
    Max=32;                                                 {最大数据}
  type
    aType=array[0..Max+1,0..Max+1]of Byte;
    bType=array[0..Max+1]of aType;
  var
    Ans:Integer;                                            {最终答案}
    Block:bType;                                        {存放最终结果}
      {表示整个立方体中各个立方块的情况;1表示路径;0表示未吃;2表示已吃}
    x,y,Bl,w:array[0..3]of Integer;
  procedure DataIn;                                     {数据输入过程}
    var
      f:Text;
      i,j:Integer;
    begin
      Assign(f,NameIn);
      Reset(f);
      ReadLn(f,x[1],x[2],x[3]);                           {读入长宽高}
      y[1]:=1; y[2]:=2; y[3]:=3;                    {记下长宽高的顺序}
      for i:=1 to 2 do                     {把长宽高排序,同时记下顺序}
        for j:=i+1 to 3 do
          if x[j]<x[i] then
            begin
              x[0]:=x[j]; x[j]:=x[i]; x[i]:=x[0];
              y[0]:=y[j]; y[j]:=y[i]; y[i]:=y[0]
            end;
      Close(f)
    end; {of DataIn}
  procedure GetAns(m,n,l,z1,z2,z3:Integer);
                               {计算长宽高分别为n,l,m的立方体的近似解}
    var
      a:array[1..2]of aType;                      {存放小虫的基本路径}
      b:bType;                                          {存放吃的结果}
      Now:Integer;                                {被吃的立方块的个数}
      p,i,j:Integer;
    procedure GetEasy;                            {获取小虫的基本路径}
      var
        i,j:Integer;
      begin
        FillChar(a,SizeOf(a),0);
        for i:=1 to n do
          case i mod 8 of
            1:begin
                a[2][i][1]:=1;
                for j:=1 to l do
                  a[1][i][j]:=1
              end;
            2:begin
                a[1][i][l]:=1;
                a[2][i][l]:=1
              end;
            3:begin
                a[1][i][1]:=1;
                for j:=1 to l do
                  a[2][i][j]:=1
              end;
            4:for j:=1 to l do
                a[1][i][j]:=1;
            5:begin
                a[1][i][l]:=1;
                for j:=1 to l do
                  a[2][i][j]:=1
              end;
            6:begin
                a[1][i][1]:=1;
                a[2][i][1]:=1
              end;
            7:begin
                a[2][i][l]:=1;
                for j:=1 to l do
                  a[1][i][j]:=1
              end;
            0:for j:=1 to l do
                a[2][i][j]:=1
          end
      end; {of GetEasy}
    procedure Change;                           {对基本的路径进行调整}
      begin
        case n mod 8 of
          1:if n>1 then
              begin
                a[2][n-1][l]:=0;
                a[2][n-2][l]:=0;
                a[1][n-2][l]:=0;
                a[2][n-1][l-1]:=1;
                a[2][n-2][l-1]:=1
              end;
          4:begin
              a[2][n-1][l]:=0;
              a[2][n-2][l-1]:=1
            end;
          5:begin
              a[1][n-1][1]:=0;
              a[1][n-2][1]:=0;
              a[2][n-2][1]:=0;
              a[1][n-1][2]:=1;
              a[1][n-2][2]:=1
            end;
          0:begin
              a[1][n-1][1]:=0;
              a[1][n-2][2]:=1
            end
        end;
        if n mod 8 in [3,6] then a[1][n][1]:=0;
        a[2,1,1]:=0;
        if n mod 8 in [2,7] then a[2][n][l]:=0
      end; {of Change}
    procedure FillSelf;                     {寻找沿途其它可吃的方块}
      var
        i,j,k,o,xx,yy,zz:Integer;
        Ok:Byte;
      begin
        for i:=1 to m do
          for j:=1 to n do
            for k:=1 to l do
              if b[i][j][k]=0 then
                begin
                  Ok:=0;
                  for o:=1 to 6 do
                    begin
                      xx:=i+Move[o,1];
                      yy:=j+Move[o,2];
                      zz:=k+Move[o,3];
                      case b[xx][yy][zz] of
                        1:begin
                            Inc(Ok);
                            if Ok>1 then Break
                          end;
                        2:begin
                            Ok:=2;
                            Break
                          end
                      end
                    end;
                  if Ok=1 then b[i][j][k]:=2        {可吃的方块做标记}
                end
      end; {of FillSelf}
    procedure Link;                   {合并各个层次的结果，得到整体解}
      var
        i:Integer;
        Up:Boolean;
      begin
        Up:=n mod 8 in [1,2,4,7];
        for i:=1 to m do
          case i mod 3 of
            1:begin
                b[p+i]:=a[1];
                if (i mod 6=4) and not Up then
                  begin
                    b[p+i][n][1]:=1;
                    b[p+i-1][n][1]:=1
                  end
              end;
            2:begin
                b[p+i]:=a[2];
                if (i mod 6=5) then
                  begin
                    b[p+i][1][1]:=1;
                    b[p+i+1][1][1]:=1
                  end;
                if (i mod 6=2) and Up then
                  begin
                    b[p+i][n][l]:=1;
                    b[p+i+1][n][l]:=1
                  end
              end
          end
      end; {of Link}
    procedure GetBlock;                   {计算总共被吃的立方块的个数}
      var
        i,j,k:Integer;
      begin
        Now:=0;
        for i:=1 to m do
          for j:=1 to n do
            for k:=1 to l do
              if b[i][j][k]<>0 then Inc(Now)
      end; {of GetBlock}
    begin {of GetAns}
      FillChar(b,SizeOf(b),0);
      if m>1                                                  {高度>1}
      then begin
             if m mod 3=1
             then p:=1
             else p:=0;
             GetEasy;                                   {取得基本途径}
             if m>4
             then begin
                    Change;                                     {调整}
                    Link                                        {合并}
                  end
             else begin
                    b[p+1]:=a[2];
                    b[p+2]:=a[1]
                  end;
             if p=1 then b[1,1,1]:=1
           end
      else begin                                            {二维情况}
             {获取基本途径}
             for i:=1 to n do
               case i mod 6 of
                 1,4:for j:=1 to l do b[1][i][j]:=1;
                 2,3:b[1][i][l]:=1;
                 5,0:b[1][i][1]:=1
               end;

             if n mod 3=0 then
               begin                                            {调整}
                 if n>3 then
                   if n mod 6=0
                   then begin
                          b[1][n-3][l-1]:=1;
                          b[1][n-2][l]:=0;
                          b[1][n-1][l]:=1;
                          for j:=l-2 downto 1 do
                            if Odd(j)=Odd(l)
                            then b[1][n-4][j]:=2
                            else b[1][n-3][j]:=2
                        end
                   else begin
                          b[1][n-3][2]:=1;
                          b[1][n-2][1]:=0;
                          b[1][n-1][1]:=1;
                          for j:=3 to l do
                            if Odd(j)
                            then b[1][n-4][j]:=2
                            else b[1][n-3][j]:=2
                        end;
                 for j:=1 to l do b[1][n][j]:=1
               end
           end;
      FillSelf;                             {计算沿途其它可吃的立方块}
      GetBlock;                               {计算被吃的立方块的个数}
      if Now>Ans then                                         {更优解}
        begin
          Ans:=Now;                                           {更新解}
          Block:=b;
          Bl[1]:=z1;
          Bl[2]:=z2;
          Bl[3]:=z3
        end
    end; {of GetAns}
  procedure Process;                                        {处理过程}
    {对长宽高进行排列,求出最好的近似解}
    begin
      Ans:=0;
      case x[1] of
        1:if x[2]<3                                            {高为1}
          then GetAns(1,x[2],x[3],y[1],y[2],y[3])
          else begin
                 GetAns(1,x[2],x[3],y[1],y[2],y[3]);
                 GetAns(1,x[3],x[2],y[1],y[3],y[2])
               end;
        2:begin                                                {高为2}
            GetAns(2,x[2],x[3],y[1],y[2],y[3]);
            GetAns(2,x[3],x[2],y[1],y[3],y[2])
          end
        else begin                                              {其它}
               GetAns(x[1],x[2],x[3],y[1],y[2],y[3]);
               GetAns(x[1],x[3],x[2],y[1],y[3],y[2]);
               GetAns(x[2],x[1],x[3],y[2],y[1],y[3]);
               GetAns(x[2],x[3],x[1],y[2],y[3],y[1]);
               GetAns(x[3],x[1],x[2],y[3],y[1],y[2]);
               GetAns(x[3],x[2],x[1],y[3],y[2],y[1])
             end
      end
    end; {of Process}
  procedure DataOut;                                    {数据输出过程}
    var
      g:Text;
      i:Integer;
      x,y,z,xx,yy,zz,k:Integer;
    procedure Say(Ch:Char;x,y,z:Integer);                 {输出到文件}
      var
        i:Integer;
        o:array[1..3]of Integer;
      begin
        o[1]:=x;
        o[2]:=y;
        o[3]:=z;
        Write(g,Ch);
        for i:=1 to 3 do
          Write(g,' ',o[w[i]]);
        WriteLn(g);
        Block[x][y][z]:=0
      end; {of Say}
    begin {of DataOut}
      for i:=1 to 3 do
        w[Bl[i]]:=i;
      Assign(g,NameOut);
      Rewrite(g);
      Say('E',1,1,1);
      Say('M',1,1,1);
      x:=1; y:=1; z:=1;
      repeat                          {根据立方体的情况求出小虫的动作}
        for k:=1 to 6 do
          begin
            xx:=x+Move[k,1];
            yy:=y+Move[k,2];
            zz:=z+Move[k,3];
            if Block[xx][yy][zz]=2 then
              Say('E',xx,yy,zz)                              {动作Eat}
          end;
        k:=0;
        repeat
          Inc(k);
          xx:=x+Move[k,1];
          yy:=y+Move[k,2];
          zz:=z+Move[k,3]
        until (k=7) or (Block[xx][yy][zz]=1);
        if k<7 then                                     {动作Eat&Move}
          begin
            Say('E',xx,yy,zz);
            Say('M',xx,yy,zz);
            x:=xx;
            y:=yy;
            z:=zz
          end;
      until k=7;                                            {无路可走}
      Close(g)
    end; {of DataOut}
  begin {of Main}
    DataIn;                                                 {读入数据}
    Process;                                                    {处理}
    DataOut                                                 {输出结果}
  end. {of Main}