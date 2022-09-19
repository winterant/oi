program Hex;
  {HGF 1998-4-4}
  {ËµÃ÷£ºÓÉÓÚÎÒÃ»ÓĞµÃµ½²âÊÔ¿â³ÌĞò£¬
           Ö»ºÃ²ÉÓÃ¼üÅÌÊäÈëµÄ·½Ê½£¬
         ³õÊ¼×´Ì¬ÓÉÎÄ¼şÊäÈë²¢Êä³öµ½ÆÁÄ»}
  uses Crt;
  const
    NameIn='HEX.DAT';                                 {³õÊ¼×´Ì¬ÎÄ¼şÃû}
    Move:array[1..6,1..2]of ShortInt=                       {Áù¸ö·½Ïò}
         ((1,0),(1,1),(0,-1),(0,1),(-1,-1),(-1,0));
    Strs:array[0..2]of Char=('ú','x','o');              {ÆÁÄ»ÉÏµÄÏÔÊ¾}
    Max=20;                                                 {×î´óÆåÅÌ}
  var
    Data:array[1..Max,1..Max]of ShortInt;                   {ÆåÅÌ×´Ì¬}
    n,x,y:Integer;
  procedure DataIn;                                     {ÊäÈë³õÊ¼×´Ì¬}
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
  procedure Print(x,y:Integer);                           {Êä³öµ½ÆÁÄ»}
    begin
      GotoXY((n-x)+y*2,x+2);
      Write(Strs[Data[x][y]],#8)
    end; {of Print}
  procedure PrintState;                                 {Êä³öÕû¸öÆåÅÌ}
    var
      i,j:Integer;
    begin
      Clrscr;
      for i:=1 to n do
        for j:=1 to n do
          Print(i,j)
    end; {of PrintState}
  procedure CheckWinA;                                  {ÅĞ¶ÏÎÒ·½Ê¤Àû}
    var
      Q:array[1..Max*Max,1..2]of Integer;                       {¶ÓÁĞ}
      b:array[1..Max,1..Max]of Boolean;                         {±ê¼Ç}
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
      while Q1<=Q2 do                                       {¿í¶ÈËÑË÷}
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
                    if xx=n then                            {ÎÒ·½»ñÊ¤}
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
  procedure CheckWinB;                                  {ÅĞ¶Ï¶Ô·½»ñÊ¤}
    var
      Q:array[1..Max*Max,1..2]of Integer;                       {¶ÓÁĞ}
      b:array[1..Max,1..Max]of Boolean;                         {±ê¼Ç}
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
      while Q1<=Q2 do                                       {¿í¶ÈËÑË÷}
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
                    if yy=n then                            {¶Ô·½»ñÊ¤}
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
  procedure BGetXY(var x,y:Integer);                        {¶Ô·½ĞĞ¶¯}
    {·µ»Ø¶Ô·½×ß×ÓµÄÎ»ÖÃ(x,y)}
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
  procedure AGetXY(var x,y:Integer);                        {ÎÒ·½ĞĞ¶¯}
    {·µ»ØÎÒ·½×ß×ÓµÄÎ»ÖÃ(x,y)}
    var
      i,j,k,xx,yy:Integer;
      Temp:Longint;
      d:array[1..Max,1..Max]of Word;                    {¶¯Ì¬¹æ»®Êı×é}
      p:array[1..Max,1..Max,1..2]of Byte;               {¼ÇÂ¼Â·¾¶¸¸±²}
      v:array[1..100,1..2]of Byte;                  {ÏÂÒ»²½µÄ¿ÉÄÜÎ»ÖÃ}
      z:array[1..100]of Byte;                       {ÓëµĞ·½Æå×ÓµÄ¾àÀë}
      pv:Byte;                                         {¿ÉÄÜÎ»ÖÃÊıÄ¿} 
      Poss:Longint;       
      Zero:Byte;
      Quit:Boolean;
    begin
      FillChar(d,SizeOf(d),255);
      for i:=1 to n do                                  {¶¯Ì¬¹æ»®±ß½ç}
        case Data[i,1] of
          0:d[i,1]:=1;
          2:d[i,1]:=0
        end;
      FillChar(p,SizeOf(p),0);
      repeat                                            {¶¯Ì¬¹æ»®¹ı³Ì}
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
                        begin                                   {¸üĞÂ}
                          d[xx,yy]:=Temp;
                          p[xx,yy][1]:=i;
                          p[xx,yy][2]:=j;
                          Quit:=False
                        end
                    end
                end;
      until Quit;                                       {¶¯Ì¬¹æ»®½áÊø}

      Temp:=65535;
      for i:=1 to n do
        if d[i,n]<Temp then
          Temp:=d[i,n];                               {Çó³ö×îĞ¡È¨Â·¾¶}
      {¼ÆËãÏÂÒ»²½¿ÉÄÜÎ»ÖÃ}
      pv:=0;
      for i:=1 to n do
        if d[i][n]=Temp then
          begin
            x:=i;
            y:=n;
            Zero:=0;
            while x<>0 do
              begin
                if (Data[x,y]=0) and (pv<100) then          {¿ÉÄÜÎ»ÖÃ}
                  begin
                    Inc(pv);
                    Inc(Zero);         {¿ØÖÆÀë¿ª¶Ô·½Æå×ÓµÄÎ»ÖÃĞ¡µÈÓÚ2}
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
      {Ëæ»úÕÒÒ»¸öÎ»ÖÃ}
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
    DataIn;                                         {ÊäÈëÆåÅÌ³õÊ¼×´Ì¬}
    PrintState;                                             {Êä³öÆåÅÌ}
    CheckWinA;                                          {ÊÇ·ñÎÒ·½»ñÊ¤}
    CheckWinB;                                         {ÊÇ·ñ¶Ô·½»ñÊ¤} 
    repeat
      AGetXY(x,y);                                          {ÎÒ·½×ß×Ó}
      Data[x,y]:=1;
      Print(x,y);
      CheckWinA;                                        {ÅĞ¶ÏÎÒ·½»ñÊ¤}
      BGetXY(x,y);                                          {¶Ô·½×ß×Ó}
      Data[x,y]:=2;
      Print(x,y); 
      CheckWinB                                         {ÅĞ¶Ï¶Ô·½»ñÊ¤}
    until False
  end.
