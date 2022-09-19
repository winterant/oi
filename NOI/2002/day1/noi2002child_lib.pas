unit
  childlib;

interface
procedure GetNM(var N,M:integer);
function Ask(Child1,Child2,T:integer):integer;
procedure Answer(Ans:integer);

implementation
const
  MaxN=501;
var
  i,Num1,Num2,Flag,MaxNum,DataType,NowPos:integer;
  NumOfQuery,A,ChildType:array[1..MaxN] of integer;
  Tried:array[1..MaxN,1..MaxN] of boolean;
  f1,f2:Text;

procedure GetNM(var N,M:integer);
begin
  N:=Num1;
  M:=Num2;
end;

function Ask(Child1,Child2,T:integer):integer;
begin
  if (Child1<1)or(Child1>Num1+Num2+1) then halt;
  if (Child2<1)or(Child2>Num1+Num2+1) then halt;
  if (T<>0)and(T<>1) then halt;
  if Child1=Child2 then halt;
  if Tried[Child1,Child2] then halt;
  Tried[Child1,Child2]:=true;
  case ChildType[Child1] of
    0: if ChildType[Child2]=T then Ask:=1 else Ask:=0;
    1: if ChildType[Child2]=T then Ask:=0 else Ask:=1;
    2: begin if ChildType[Child2]=T then Ask:=1-Flag else Ask:=Flag; Flag:=1-Flag; end;
    else halt;
  end;
  if NumOfQuery[Child1]<10 then
    inc(NumOfQuery[Child1]);
  if NumOfQuery[Child1]>MaxNum then MaxNum:=NumOfQuery[Child1];
end;

procedure WriteOut;
begin
  case DataType of
    1: begin
         assign(f2,'child.out');
         rewrite(f2);
         writeln(f2,'MaxNum = ',MaxNum);
         for i:=1 to Num1+Num2+1 do
           write(f2,A[i],' ');
         writeln(f2);
         close(f2);
       end;
    2: begin
         assign(f2,'child.log');
         rewrite(f2);
         writeln(f2,MaxNum);
         for i:=1 to Num1+Num2+1 do
           write(f2,A[i],' ');
         writeln(f2);
         close(f2);
       end;
  end;
  halt;
end;

procedure Answer(Ans:integer);
begin
  inc(NowPos);
  A[NowPos]:=Ans;
  if NowPos=Num1+Num2+1 then WriteOut;
end;

begin
  assign(f1,'child.in');
  reset(f1);
  Flag:=0;
  read(f1,Num1);
  if Num1<0 then
  begin
    read(f1,Num1);
    DataType:=1;
    assign(f2,'child.out');
    rewrite(f2);
    writeln(f2,'Abnormal Termination');
    close(f2);
  end
  else begin
    DataType:=2;
    assign(f2,'child.log');
    rewrite(f2);
    writeln(f2,'Abnormal Termination');
    close(f2);
  end;
  read(f1,Num2);
  for i:=1 to Num1+Num2+1 do
  begin
    read(f1,ChildType[i]);
    NumOfQuery[i]:=0;
  end;
  MaxNum:=0;
  NowPos:=0;
  close(f1);
  fillchar(Tried,sizeof(Tried),0);
end.

