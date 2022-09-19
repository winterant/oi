{
Solution for task SORT3
-------- --- ---- -----

The basic idea behind our solution is the following.
Compute first the number of appearances Na[x] for elements x=1, 2, 3  in 
the input sequence. Then the sorted sequence consists of Na[1] number of 
1's followed by Na[2] number of 2's and then Na[3] number of 3's. 
We say that an element x is in the place of y's if the current position of x
equals the position of an element y in the sorted sequence. We use the 
abbreviation x:y to denote an element x in place of y's.
Next compute NEP[x,y], the number of elements x's in the place of y's for all
x and y. Consider the following algorithm written in pseudo-code.
  
  NoCh:=0;
  While Not Sorted(S) Do Begin
    If there are x and y in each other's place Then Begin
      Inc(NoCh);
      Exchange x and y;
      Update NEP[x,y] and NEP[y,x];
    End Else Begin
      If (NEP[1,2]>0) And (NEP[3,1]>0) Then Begin
        Exchange a pair of elements 3:1 and 1:2 ;
        Update NEP[1,2] And NEP[3,1];
        Inc(NoCh);
      End;
      If (NEP[2,1]>0) And (NEP[1,3]>0) Then Begin
        Exchange a pair of elements 2:1 and 1:3 ;
        Update NEP[2,1] And NEP[1,3];
        Inc(NoCh);
      End;
    End;   
  End;

First we show that the number of exchange operations performed by the 
algorithm can be given by the expression

     Ch(S)=Min(NEP[1,2], NEP[2,1])+
           Min(NEP[1,3], NEP[3,1])+
           Min(NEP[2,3], NEP[3,2])+
           2*Abs(NEP[1,2]-NEP[2,1])

After performing Min(NEP[x,y], NEP[y,x]) exchange operations for all x<>y the
resulting sequence contains NEP[1,2]-NEP[2,1] number of elements 1:2, 2:3, 3:1
if NEP[1,2]>NEP[2,1] and 1:3, 2:1, 3:2 if NEP[1,2]<NEP[2,1]. In the first case
the algorithm makes exchange 2:1 and 1:3 which results an element 2 in 
place of 3, therefore in the next iteration an exchange of 2:3 and 3:2 will be
performed. The second case is similar. We conclude that the expression Ch(S)
is correct for the number of exchange operations performed by the algorithm.

Let us denote by OCh(S) the minimal number of exchange operations needed to
make the sequence S sorted. We shall prove that Ch(S)=OCh(S). The proof is by 
induction on the value OCh(S).
If OCh(S)=0 or 1 then the statement obviously holds.
Assume that Och(S)=Ch(S) for all S if OCh(S)<k, for some k>1.
Let S be a sequence and OCh(S)=k. 

Consider an optimal sequence of exchange operations that makes S sorted. 
Assume that the first exchange operation exchanges elements x1:y1 and x2:y2
( or x1:y2 and x1:y1) and denote by S' the resulting sequence.
We distinguish the following two cases:
  C1: x1=y2 and x2=y1 or
      NEP[1,2]>NEP[2,1] and x1=1, y1=2, x2=3, y2=1 or
                            x1=1, y1=2, x2=2, y2=3 or
                            x1=3, y1=1, x2=2, y2=3 or
      NEP[1,2]>NEP[2,1] and x1=2, y1=1, x2=3, y2=2 or
                            x1=2, y1=1, x2=1, y2=3 or
                            x1=3, y1=2, x2=1, y2=3 or
  C2: all other combinations for x1, y1, x2, y2.
  
We can verify by a routine calculation that Ch(S')=Ch(S)-1 in case C1 and
Ch(S')>=Ch(S) in case C2. In case C1 we obtain by the inductive hypotheses 
that the algorithm performs Ch(S)=Ch(S')+1=OCh(S')+1=OCh(S) exchange 
operations.
Case C2 contradicts to the optimality condition, therefore an optimal
sequence of exchange operations can only start with an exchange specified in
case C1.
  
In order to develop efficient algorithm that constructs a sequence of exchange
operations, we introduce the array First, that First[x,y] always contains 
the first position of x in place of y's. First[x,y] is computed by the
preprocess procedure and is updated after each exchange operation.
           
}
Program Sort3;
Const
  MaxN =1000;                 { max number of elements to sort }
Type
  ElemType = 1..3;
  ArrayType= Array[1..MaxN] Of ElemType;
  Matrix   = Array[ElemType, ElemType] of Integer;
Var
  N : Word;                   { number of elements to sort              }
  S : ArrayType;              { array of elements to sort               }
  Na: Array[ElemType] Of Word;{ Na[x] is the number of x's in the input }
  NEP : Matrix;               { NEP[x,y] is the number of x's           }
                              { in place of y's                         }
  First: Matrix;              { First[x,y] is the first position of x   }
                              { in place of y's                         }
  NoCh: Word;                 { number of exchange operations           }
  OutFile: Text;

Procedure ReadInput;
{ Global output variables: N, S, Na }
  Var
    InFile: Text;
    i,j: Word;
  Begin
    Assign(InFile, 'input.txt');
    Reset(Infile);

    ReadLn(InFile, N);
    For i:=1 To 3 Do Na[i]:=0;
    For i:=1 To N Do Begin
      ReadLn(InFile,S[i]);
      Inc(Na[S[i]]);
    End;
    Close(InFile);
  End { ReadInput };

Function Min(X,Y: Word):Word;
  Begin
    If X<Y Then Min:=X
           ELse Min:=Y
  End { Min };

Procedure Preprocess;
{ Global input variables: N, S, Na }
{ Global output variables: NEP, First }
  Var i,j,M:Word;
  Begin
    For i:=1 To 3 Do Begin
      For j:=1 To 3 Do Begin
        NEP[i,j]:=0; First[i,j]:=0
      End { For j };
    End { For i };

    For i:=1 To N Do Begin
      If i<=Na[1] Then Begin                    { S[i] is in place of 1's    }
        If NEP[S[i],1]=0 Then First[S[i],1]:=i; { first S[i] in place of 1's }
        Inc(NEP[S[i],1]);
      End Else If i<=Na[1]+Na[2] Then Begin     { S[i] is in place of 2's    }
        If NEP[S[i],2]=0 Then First[S[i],2]:=i; { first S[i] in place of 2's }
        Inc(NEP[S[i],2]);
      End Else Begin                            { S[i] is in place of 3's    }
        If NEP[S[i],3]=0 Then First[S[i],3]:=i; { first S[i] in place of 3's }
        Inc(NEP[S[i],3])
      End;
    End { For i };
    NoCh:= Min(NEP[1,2], NEP[2,1])+             { subtask A }
           Min(NEP[1,3], NEP[3,1])+
           Min(NEP[2,3], NEP[3,2])+
           2*Abs(NEP[1,2]-NEP[2,1]);
  End;{ Preprocess }

  Procedure Next(i1,i2:Byte);
  { Global input-output variables: First, NEP }
    Begin
      Dec(NEP[i1,i2]);
      If NEP[i1,i2]>0 Then Begin
        Repeat
          Inc(First[i1,i2]);
        Until S[First[i1,i2]]=i1;
      End;
    End { Next };

Procedure Pairs;
  Var M,i,x,y :Word;
  Begin
    For x:=1 To 3 Do
      For y:=x+1 To 3 Do Begin
        M:=Min(NEP[x,y], NEP[y,x]);
        For i:=1 To M Do Begin
          WriteLn(OutFile, First[x,y],' ',First[y,x]);
          Next(x,y); Next(y,x);
        End;
      End;
   End { Pairs };

Procedure Triples;
  Var M,i: Word;
  Begin
    If NEP[1,2] > 0 Then Begin
      M:=NEP[1,2];
      For i:=1 To M Do Begin
        WriteLn(OutFile, First[3,1],' ',First[1,2]);
        WriteLn(OutFile, First[1,2],' ',First[2,3]);
        Next(3,1); Next(1,2); Next(2,3);
      End;
    End Else Begin
      M:=NEP[2,1];
      For i:=1 To M Do Begin
        WriteLn(OutFile, First[2,1],' ',First[1,3]);
        WriteLn(OutFile, First[1,3],' ',First[3,2]);
        Next(2,1); Next(3,2); Next(1,3);
      End;
    End;
  End;

Begin { Program }
  ReadInput;

  Preprocess;

  Assign(OutFile, 'output.txt');
  Rewrite(OutFile);
  WriteLn(OutFile,NoCh);

  Pairs;
  Triples;

  Close(OutFile);
End.

{ Scientific Committee IOI'96 }