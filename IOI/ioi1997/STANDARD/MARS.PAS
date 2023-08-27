{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}
Program Mars (input , output);
Const  Inputname           = 'Mars.dat';{�����ļ���}
       Outputname          = 'Mars.out';{����ļ���}
       maxsize             = 128;{��ͼ�ߴ�}
       maxleft             = 30;{����������������������ģ��ʣ���2�Ŷ�����}
       maxnode             = maxleft * 2 + 3;{����ͼ���������}

Type   maptype             = Array[1 .. maxsize , 1 .. maxsize] of byte;
                           {��ͼ����}
       Gtype               = array[1 .. maxnode , 1 .. maxnode] of integer;
                           {ͼ����}
       Direct              = (None , Pod , South , East);{����ö������}
       FromType            = Array[1 .. maxsize , 1 .. maxsize] of Direct;
                           {·����¼����}
Var    map                 : Maptype;{��ͼ}
       n , p , q           : integer;{N--·����,(P,Q)--��ͼ�ߴ�}

Procedure Initalize;{��ʼ������}
Var    fp                  : text;{�ļ�ָ��}
       i , j               : integer;{��������}
Begin
  {����}
  fillchar (map , sizeof(map) , 0);
  {��������}
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
  {��̬�滮��MAP�в��ɴ�(p,q)�ĵ㶼��Ϊ1}
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

Procedure Solve;{������}
Var    i , j               : integer;{��������}
       fp                  : text;{�ļ�ָ��}
       Dist                : Maptype;{����ɴ����:�������������������ʯ��}
       From                : Fromtype;{������·�������߷���}
       testp               : integer;{��������}
       left                : integer;{ʣ��δ���ߵ�2�Ŷ�����}

Procedure GetFrom;
{��̬�滮�����ɴ����:��㵽���㾭�������ʯ��,��̰��ѡ��ǰ·��}
Var    i , j , k           : integer;{��������}
Begin
  {����}
  left :=0;
  fillchar (from , sizeof(from) , 0);
  fillchar (dist , sizeof(dist) , 0);
  {��̬�滮,��(1,1)����}
  for i :=1 to q do
    for j :=1 to p do
      begin
        if (i = 1) and (j = 1)
          then begin{�߽����}
                 if map[i , j] <> 1
                   then begin {���û���ϰ�}
                          from[i , j] :=Pod;
                          dist[i , j] :=0;
                        end
                   else from[i , j] :=None;{��·��}
               end
          else begin
                 if (i > 1) and (from[i - 1 , j] <> None)
                   and (map[i , j] <> 1)
                 then begin{����ͨ�����ϵ���,�滮}
                        from[i , j] :=South;
                        if map[i , j] = 2{��ǰ������ʯ}
                          then dist[i , j] :=dist[i - 1 , j] + 1{��ʯ��+1}
                          else dist[i , j] :=dist[i - 1 , j];
                      end
                 else from[i , j] :=None;{��·��}
                 if (j > 1) and (from[i , j - 1] <> None)
                    and (map[i , j] <> 1)
                    and ((from[i , j] = None)
                        or (dist[i , j - 1] > dist[i - 1 , j]))
                    then begin{�����ɴ�,���Ҿ�����ʯ����}
                           from[i , j] :=East;
                           if map[i , j] = 2{��ǰ������ʯ}
                             then dist[i , j] :=dist[i , j- 1] + 1{��ʯ��+1}
                             else dist[i , j] :=dist[i , j- 1];
                         end;
               end;
        if (map[i , j] = 2) and (from[i , j] <> NONE)
          then inc (left);{ʣ����ʯ��}
      end;
end; {GetFrom}

Procedure Printway (ri , rj : integer);
{���ݵݹ����(RI,RJ)������·��}
Begin
  Case from[ri , rj] of
    South : Begin{����}
              Printway (ri - 1 , rj);{�ݹ�}
              writeln (fp ,testp , ' ',  0);{�����ǰ�㼰����}
            end;
    East : Begin{����}
             Printway (ri , rj - 1);
             writeln (fp , testp , ' ' , 1);{�����ǰ�㼰����}
           end;
  end;
  map[ri , rj] :=0;
end; {Printway}

Procedure solve2;{�������㷨}
Var    Cont , Price , Ans  : ^Gtype;
       {CONT--��������;PRICE--������λ����;ANS--������}
       s , t               : integer;{S:����Դ,T--ʼĩ��}
       midp                : integer;{������}
       nodeset             : Array[1 .. maxleft , 1 .. 2] of byte;
                           {�������ӦMAP�е�λ��}
       get           : Fromtype;{MAP�и���ɴ��Ծ���:����·���ϵ��ƶ�����}

Procedure GetGet (si , sj : integer);
{���ش�(SI,SJ)�����ĸ���ɴ��Ծ���GET}
Var    i , j , k           : integer;{��������}
Begin
  {����}
  fillchar (get , sizeof(get) , NONE);
  {��̬�滮}
  for i :=si to q do
    for j :=sj to p do
      begin
        if map[i , j] = 1
          then begin{�ϰ���}
                 get[i , j] :=None;{��·��}
                 continue;
               end;
        if (i = si) and (j = sj)
          then get[i , j] :=Pod{���}
          else begin
                 if (i > si) and (get[i - 1 , j] <> NONE)
                   then get[i , j] :=South{���Ͽɴ�}
                   else if (j > sj) and (get[i , j - 1] <> NONE)
                          then get[i , j] :=East;{�����ɴ�}
               end;
      end;
end; {GetGet}

Procedure MakeGraph;{���������Ӧ����}
Var    i , j , k           : integer;{��������}
Begin
  {����}
  fillchar (cont^ , sizeof(cont^) , 0);
  Fillchar (Price^ , sizeof(Price^) , 0);
  {���NODESET,�������еĽ����MAP�еĿɴ��2��λ�ö�Ӧ}
  k :=0;
  for i :=1 to q do
    for j :=1 to p do
      if (map[i , j] = 2) and (From[i , j] <> NONE)
        then begin{�ɴ��2��λ��}
               inc (k);
               nodeset[k , 1] :=i;
               nodeset[k , 2] :=j;
             end;
  {��������}
  s :=2 * left + 1;{����Դ} midp :=2 * left + 2;{������}
  t :=2 * left + 3;{���}
  {����S-MIDP�ı�,����������·����}
  cont^[s , midp] :=n-testp+1; price^[s , midp] :=0;
  for i :=1 to left do
    begin
      GetGet (nodeset[i,1] , nodeset[i,2]);{��õ�ǰλ�ó����ĸ���ɴ����}
      {���������,���Ƶ�Ȩ,����¼����}
      Cont^[i , Left + i] :=1; Price^[i , left + i] :=0;
      for j :=1 to left do
        if (i <> j) and (get[nodeset[j,1] , nodeset[j,2]] <> NONE) then
        begin{J����I��ɴ�,������,�趨������Ȩ}
        {1.��ʾ���ɼ���ʯ�ı�}
          Cont^[i , j] :=n-testp+1;
          price^[i , j] :=
            (nodeset[j,1]-nodeset[i,1])+(nodeset[j,2]-nodeset[i,2]);
        {2.��ʾ�ɼ���ʯ�ı�}
          Cont^[left + i , j] :=1;
          Price^[left + i , j] :=
            (nodeset[j,1]-nodeset[i,1])+(nodeset[j,2]-nodeset[i,2])-1;
        end;
      {��MIDP������}
      price^[midp , i] :=nodeset[i,1] + nodeset[i,2];
      cont^[midp , i] :=n-testp+1;
      {��㽨����}
      {1.��ʾ���ɼ��ı�}
      price^[i , t] :=q-nodeset[i , 1]+p-nodeset[i,2] + 1;
      cont^[i , t] :=n-testp+1;
      {2.��ʾ�ɼ��ı�}
      price^[left + i , t] :=q-nodeset[i , 1]+p-nodeset[i,2];
      cont^[left + i , t] :=1;
    end;
EnD; {makeGraph}

Procedure MinFlow;{���������С���������}
Var    i , j , k           : integer;{��������}
       nd , np             : ^Gtype;{ND--���·��������Ϣ;
                                     NP--���·��ǰ����Ϣ}
       delta               : integer;{�������ĸı���}

Procedure MakeW;{������ͼ}
var    i , j , k           : integer;{��������}

Begin
  {����}
  fillchar (nd^ , sizeof(nd^) , 0);
  fillchar (np^ , sizeof(np^) , 0);
  for i :=1 to t do
    for j :=1 to t do
      begin
        if ans^[i , j] < cont^[i , j]
          then begin{����<����}
                 nd^[i , j] :=price^[i , j];{������������}
                 np^[i , j] :=i;
               end;
        if ans^[i , j] > 0
          then begin{����>0}
                 nd^[j , i] :=-price^[i , j];{�������򸺱�}
                 np^[j , i] :=j;
               end;
      end;
end; {MakeW}

Procedure GetPath;{�����·��}
Var    i , j , k           : integer;{��������}
Begin
  {��̬�滮Floyd�㷨}
  for i :=1 to t do
    for j :=1 to t do
      for k :=1 to t do
        if (np^[j , i] > 0) and (np^[i , k] > 0) and
          ((np^[j ,k] =0) or (nd^[j , i] + nd^[i , k] < nd^[j , k]))
        then begin{�滮}
               np^[j , k] :=np^[i , k];
               nd^[j , k] :=nd^[j , i] + nd^[i , k];
             end;
end; {Getpath}

Procedure GetDelta;{�����ı���}
Var    i , j               : integer;{��������}
Begin
  {����}
  delta :=0;
  {��ֵ}
  j :=t;
  while j <> s do
    begin
      i :=np^[s , j];
      if (ans^[i , j] < cont^[i , j])
        and ((delta = 0) or (cont^[i , j] - ans^[i , j] < delta))
        then delta :=Cont^[i , j] - ans^[i , j];{�����}
      if (ans^[j , i] > 0) and
        ((delta = 0) or (ans^[j , i] < delta))
      then delta :=ans^[j , i];{�����}
      j :=i;
    end;
end; {Getdelta}


Procedure ChangeAns;{�ı�����}
var    i , j , k           : integer;{��������}
Begin
  j :=t;
  while j <> s do
    begin
      i :=np^[s , j];
      if (ans^[i , j] < cont^[i , j])
        then ans^[i , j] :=ans^[i , j] + delta;{�����}
      if (ans^[j , i] > 0)
      then ans^[j , i] :=ans^[j , i] - delta;{�����}
      j :=i;
    end;
end; {ChangeAns}

Begin
  {����}
  fillchar (ans^ ,sizeof(ans^) , 0);
  new (np); new (nd);{����ռ�}
  repeat
    MakeW;{������ͼ}
    GetPath;{�����·��}
    if np^[s , t] <> 0
      then begin{�������·��}
             GetDelta;{���������ı���}
             ChangeAns;{�ı�����}
           end;
  Until np^[s,t] = 0;{ֱ��������·��}
  dispose (np); dispose (nd);{�ͷſռ�}
end; {minFlow}

Procedure Print2;{������ANS�������}
Var    i , j , k           : integer;{��������}
       runp                : integer;{���·����}

Procedure Printroute (ri , rj : integer);{�ݹ����·��}
Begin
  Case get[ri , rj] of
    South : Begin{����}
              Printroute (ri - 1 , rj);{�ݹ�}
              writeln (fp ,runp , ' ',  0);{�����ǰλ�ú��ƶ�����}
            end;
    East : Begin{����}
             PrintRoute (ri , rj - 1);{�ݹ�}
             writeln (fp , runp , ' ' , 1);{�����ǰλ�ú��ƶ�����}
           end;
  end;
end; {Printroute}


Procedure DFS (root : integer);
{�ݹ���������,�������·��}
var    next                : integer;{��������,��һ�η��ʵĵ�}

Begin
  if root = t
    then{�����յ�}
    else begin{δ�����յ�}
           if root > left
             then GetGet (nodeset[root-left,1] ,nodeset[root-left,2])
                  {�ǲ�ֺ��,���Ӧλ�õĿɴ���Ϣ}
             else GetGet (nodeset[root,1] ,nodeset[root,2]);
                  {�ǲ��ǰ��,���Ӧλ�õĿɴ���Ϣ}
           for next :=1 to t do
            if ans^[root , next] > 0
               then begin{����>0,ѡ����һ�����ʽ��}
                      if next <= left
                        then{��һ��ǰ��,�������֮���·��}
                          printroute (nodeset[next , 1] , nodeset[next,2])
                        else begin{��ǰ��ĺ��}
                               if next = t
                                 then{�����յ�,��������յ��·��}
                                   printroute (q , p);
                             end;
                      DFS (next);{�ݹ�}
                      dec (ans^[root , next]);{����·���ϵıߵ�����}
                      exit;
                    end;
         end;
end; {DFS}

Begin
  runp :=testp-1;{�Ѿ���ɵ�·����}
  repeat
    {��õ�һ����MIDP���ӵ�������Ϊ��ı�ָ��ĵ�}
    i :=1;
    While (i <= left) and (ans^[midp , i] = 0) do
      inc (i);
    if i <= left
      then begin{���������ĵ�}
             inc (runp);{·����+1}
             GetGet (1 , 1);{�����㵽�����·����Ϣ}
             {�����㵽��һ����ʯ��·��}
             Printroute (nodeset[i,1] , nodeset[i,2]);
             DFS (i);{���·��,����·����Ӧ����}
             dec (ans^[midp , i]);{����������������}
           end;
  Until i > left;
end; {Print2}

Begin
  New (ans); new (cont); New (price);{����ռ�}
  MakeGraph;{���������Ӧ����}
  MinFlow;{���Ӧ�������С���������}
  Print2;{���LEFT��·}
  Dispose (ans); dispose (cont); dispose (price);{�ͷſռ�}
end; {Solve2}

Begin
  {��������ļ�}
  assign (fp , outputname);
  rewrite (fp);
  for testp :=1 to n do{����N��·��}
    begin
      GetFrom;{��̬�滮�õ�����ɴ���Ϣ,̰��ѡ����ʯ���ĵ�ǰ·��}
      if (left <= maxleft) and (left <> 0)
        then begin{�����ģ<=MAXLEFT}
               Solve2;{�������㷨}
               break;{�˳�}
             end;
      Printway (q , p);{���·��}
    end;
  close (fp);{�ر�����ļ�}
end; {Solve}

Begin
  Initalize;{��ʼ��}
  Solve;{������}
end. {main}