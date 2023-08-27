{$A-,B-,D+,E-,F-,G-,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X-,Y-}
{$M 65520,0,655360}
Program Image (input , output);
Const  Inputname           = 'Image.dat';{�����ʶ���ļ����ļ���}
       Fontname            = 'Font.dat';{����ģʽ�ļ����ļ���}
       Outputname          = 'Image.out';{����ļ���}
       maxln               = 1200;{�������}
       size                = 20;{�ַ���׼�ߴ�}
       sn                  = 27;{ģʽ�ַ�����}
       samplestr{ģʽ�ַ�} : string[sn] = ' abcdefghijklmnopqrstuvwxyz';

Type   Strtype             = string[size];{һ���ַ�01��Ϣ����}
       FontType            = array[1 .. size] of strtype;{һ��׼�ַ���Ϣ����}
Var    Font                : Array[1 .. sn] of FontType;{��׼�ַ���Ϣ}
       cost , from         : Array[0 .. maxln] of Integer;
                           {COST[P]��ʾǰP��ʶ��ʧ�����;
                            FROM[P]��ʾ���ߵ�ǰһ�׶�λ��}
       ans                 : Array[1 .. maxln] of char;{ʶ����}
       ln                  : integer;{ʶ�����ַ���}

Procedure Initalize;{��ʼ������}
Var    fp                  : text;{�����ļ�ָ��}
       i , j               : integer;{��������}
Begin
  {����}
  Fillchar (ans , sizeof(ans) , 0);
  fillchar (cost , sizeof(cost) , 0);
  fillchar (from , sizeof(from) , 0);
  fillchar (font , sizeof(font) , 0);
  {�����׼�ַ�}
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

Procedure Solve;{������}
Type   ResType{20*20ʶ����Ϣ}= array[1 .. sn , 0 .. size] of integer;
                       {RESTYPE[K,J]��ʾ��K���ַ�ʶ��ǰJ�е���ʧ����}
Var    fp                  : text;{�ļ�ָ��}
       Rescost             : Array[-1 .. 1] of Restype;
                             {��ǰ�׶�Ϊ��I��,��
                       RESCOST[-1]��ʾ��I-1��ǰ��20�������׼�ַ�ʶ��Ľ��;
                       RESCOST[0 ]��ʾ��I  ��ǰ��20�������׼�ַ�ʶ��Ľ��;
                       RESCOST[1 ]��ʾ��I+1��ǰ��20�������׼�ַ�ʶ��Ľ��}
       i , j , k , p , q   : integer;{��������}
       oneImage            : FontType;{��ǰ20��ͼ��}
       oneline             : StrType;{��ǰ��}

Procedure GetDist (rp , sp , comsize: integer);
{����RESCOST[RP,SP,1..COMSIZE]�Ľ��}
Var    i , j , k           : integer;{��������}
Begin
  {����}
  fillchar (rescost[rp , sp] , sizeof(rescost[rp , sp]) , 0);
  for i :=1 to comsize do{����}
    begin
      rescost[rp,sp , i+size-comsize] :=rescost[rp,sp,i+size-comsize-1];
      for j :=1 to size do
      if oneimage[i , j] <> font[sp , i + size - comsize, j]{ʧ��}
      then inc (rescost[rp , sp , i+size-comsize]);{�ۼ�}
    end;
end; {Getdist}

Begin
  {����}
  Fillchar (ResCost , sizeof(ResCost) , 0);
  {�����ʶ���ļ�}
  assign (fp , inputname);
  reset (fp);
  readln (fp , ln);
  for i :=0 to ln do
    begin
      if i > 0 then cost[i] :=maxint{��ֵ}
               else cost[i] :=0;{�߽�}
      Rescost[-1] :=Rescost[0]; Rescost[0] :=Rescost[1];{RESCOSTת��}
      if i + 1 > size then{����ǰ��>=��׼�ַ�����}
            begin
              for j :=2 to size do{��ǰͼ��ת��}
                oneimage[j - 1] :=oneimage[j];
              if i + 1 <= ln
                then readln (fp , oneimage[size]){��ǰ�в�����ĩ��,�����һ��}
                else oneimage[size] :=oneimage[size - 1];{����,��ĩΪ0��}
              for j :=1 to sn do{����������ʶ��ͳ��}
                begin
                  Getdist (1 , j , size);
                end;
            end
          else begin{��ǰ��<��׼�ַ�����}
                 if i + 1 <= ln
                   then {��ǰ�в�����ĩ��,�����һ��}
                     readln (fp , oneimage[i + 1])
                   else {����,��ĩΪǰһ�еĸ���}
                     oneimage[i + 1] :=oneimage[i];

                 for j :=1 to sn do{����������ʶ��ͳ��}
                   begin
                     Getdist (1 , j , i + 1);
                   end;
               end;
      if i < size -1  then continue;{�߽����}
      {��̬�滮״̬ת��}
      for j :=1 to sn do
        Begin
          if (i >= size - 1)
            and (cost[i - (size-1)] < cost[i])
            then begin{��ǰ�ַ��ٶ�����Ϊ(SIZE-1=19)}
                   for k :=1 to size do{ѡ�����}
                     if cost[i-(size-1)]+Rescost[1,j,k-1]
                                        +Rescost[0,j,size]
                                        -Rescost[0,j,k] < cost[i] then
                     begin{�ɸĽ�}
                       cost[i] :=cost[i-(size-1)]+Rescost[1,j,k-1]
                                                 +Rescost[0,j,size]
                                                 -Rescost[0,j,k];{�滻}
                       from[i] :=i - (size - 1);{���߼�¼}
                       ans[i] :=samplestr[j];{ʶ������¼}
                     end;
                 end;
          if (i >= size) and (cost[i - size] < cost[i])
            then begin{��ǰ�ַ��ٶ�����ΪSIZE=20}
                   if (cost[i - size] + resCost[0 , j , size] < cost[i])
                     then begin{�ɸĽ�}
                            {�滻}
                            cost[i] :=cost[i - size] + rescost[0 , j , size];
                            from[i] :=i - size;{���߼�¼}
                            ans[i] :=samplestr[j];{ʶ������¼}
                          end;
                 end;
          if (i >= size + 1) and (cost[i - (size + 1)] < cost[i])
            then begin{��ǰ�ַ��ٶ�����ΪSIZE=20}
                   for k :=2 to size + 1 do
                     if cost[i-(size+1)]+ResCost[-1,j,k-1]
                                        +ResCost[0,j,size]
                                        -ResCost[0,j,k-1] < cost[i]
                       then begin{�ɸĽ�}
                              cost[i] :=Cost[i-(size+1)]
                                        + resCost[-1,j,k-1]
                                        + ResCost[0,j,size]
                                        - resCost[0,j,k-1];{�滻}
                              from[i] :=i - (size + 1);{���߼�¼}
                              ans[i] :=samplestr[j];{ʶ������¼}
                            end;
                 end;
        end;
    end;
  close (fp);{�ر��ļ�}
end; {Solve}

Procedure Printout;{�������}
Var    fp                  : text;{����ļ�ָ��}
       i , j               : integer;{��������}
       result              : string;
Begin
  i :=ln;   result :='';{��ʼ��ֵ}
  While i <> 0 do
    begin{��¼���}
      result :=ans[i] + result;
      i :=from[i];
    end;
  {�ļ����}
  assign (fp , outputname);
  rewrite (fp);
  writeln (fp , result);
  close (fp);
  writeln ('Cost = ' , cost[ln]);{��Ļ��ӡʧ������}
end; {Printout}

Begin
  Initalize;{��ʼ��}
  Solve;{������}
  Printout;{������}
end. {main}