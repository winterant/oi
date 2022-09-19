{
Solution of task PREFIX
-------- -- ---- ------
Let S be a sequence of letters and let P be a set of primitives.
Denote by Suff(S,P) the set of sequences v such that the following
two conditions hold:
  (1) v is a prefix of a primitive in P
  (2) S=uv for some u.

(For two sequences of letters u and v we denote the concatenation of u and v
by uv.)
It is obvious that S can be composed from primitives in P iff the empty
sequence is in Suff(S,P). Moreover, S has an extension u on the right that
makes Su a composition of primitives in P iff Suff(S,P) is non-empty.
Therefore the following algorithm gives a solution to the task if DataFile
contains the sequence to be examined.

  Res:=0;
  S:=empty; NoS:=1;
  ReadLn(DataFile,X);
  Slength:=1;
  While (X<>'.') And (NoS>0) Do Begin
    Append X to the end of S;
    Q:=Suff(S,P);
    NoS:=number of elements of Q;
    If the empty sequence is element of Q Then Res:=Slength;
    ReadLn(DataFile,X);
    Inc(Slength);
  End;
  WriteOut(Res);

One of the obvious problem with this algorithm is that the datafile is too
large to read into the memory (unless you know how to use the machine's
extra memory).
Fortunately, it is not necessary to read the whole sequence into memory.
Let us observe that Suff(Sx,P) for a sequence S and a letter x can be
computed from the set Suff(S,P). Indeed, the following algorithm satisfies
the requirement that if Q=Suff(S,P) holds before executing Next(Q,X)
then after the execution Q=Suff(SX,P) will hold.

Procedure Next(Q,X);
  Begin
    Q1:=empty;
    Forall u in Q Do Begin
      If ux is a prefix of some primitives in P Then
        Begin
          include ux in Q1;
          If ux is equal to a primitive in P
            Then include the empty sequence in Q1
        End;
    End;
    Q:=Q1;
  End;

In order to refine the algorithm Next we have to answer for the questions:
  - Is a sequence ux a prefix of some primitive in P?
  - Is a sequence u equal to a primitive in P?

Consider the following data structure for the set of primitives P.
Const
  MaxN=100;                      (* maximum possible number of primitives *)
  MaxL=20;                       (* maximum possible length of primitives *)
Var
  P:Array[1..MaxN,1..MaxL] Of Char;                (* array of primitives *)
  L:Array[1..MaxN] Of Word;                   (* length of the primitives *)

Let us represent a sequence u which is a prefix of a primitive in P by the
pair (i,j), such that the prefix of P[i] consisting of the first j letters
of the primitive P[i] equals u, and i is the least such index for u.
Note that the empty sequence is represented by the pair (1,0).

We can pre-process the set of primitives to build a transition table T:

  T[i,j,x] is 0 if there is no primitive in P with prefix P[i][1..j]x,
  otherwise the least index k such that P[i][1..j]x is a prefix of P[k].
  (P[i][1..j] denotes the sequence of letters consisting of the first j
  elements of the primitive P[i].)

In other words, if a sequence u is represented by the pair (i,j) then the
sequence ux is a prefix of a primitive in P iff T[i,j,x]>0, and in this case
ux is a prefix of P[T[i,j,x]] and is represented by the pair (T[i,j,x],j+1).
The procedure BuildTable computes the transition table T and builds the array
Full as well. Full[i,j] is true iff the sequence represented by (i,j) is equal
to a primitive in P.
We can easily implement the algorithm Next(Q,X) using the arrays T and Full.

}
Program Prefix;
Const
  MaxN=100;                          { maximum possible number of primitives }
  MaxL=20;                           { maximum possible length of primitives }
Var
  DataFile:Text;                      { file for the sequence to be examined }
  P:Array[1..MaxN,1..MaxL] Of Char;                    { array of primitives }
  L:Array[1..MaxN] Of Word;                       { length of the primitives }
  T:Array[1..MaxN,0..MaxL,'A'..'Z'] Of Byte;              { transition table }
  N,                                                  { number of primitives }
  ML:Word;                             { max of the length of the primitives }
  Res:Longint;                                { length of the longest prefix }
  Full:Array[1..MaxN,1..MaxL] Of Boolean;

Type
  State=Array[1..MaxL+1] Of Record
                              i,j:Byte;
                            End;
Procedure Init;
Var M,i,j:Word;
  InFile:Text;
Begin
  Assign(InFile,'input.txt'); Reset(InFile);
  ReadLn(InFile,N);
  ML:=0;
  For i:=1 To N Do Begin
    ReadLn(InFile,L[i]);
    If L[i]>ML Then ML:=L[i];
    For j:=1 To L[i] Do Read(InFile,P[i][j]);
    ReadLn(InFile);
  End;
  Close(InFile);
  Assign(DataFile,'data.txt'); Reset(DataFile);
End;

Procedure BuildTable;
{Global input variables: N, ML, P }
{Global output variables: T, Full }
Var
  i,i1,j,k:Word;
  X:Char;
Begin
  For i:=1 To N Do  {initialize the array Full}
    For j:=1 To ML Do Full[i,j]:=False;
  For i:=1 To N Do          { compute T[i,0,x] }
    For X:='A' To 'Z' Do Begin
      k:=1;
      While (k<=N) And (P[k][1]<>X) Do Inc(k);
      If (k<=N) Then Begin
        T[i,0,X]:=k;
        Full[k,1]:=Full[k,1] Or (L[i]=1) And (P[i][1]=X);
      End Else
        T[i,0,X]:=0;
    End;
  For j:=1 To ML Do Begin
    For i:=1 To N Do Begin
      For X:='A' To 'Z' Do Begin { compute T[i,j,X] }
        If j>L[i] Then Begin
          T[i,j,X]:=0;
        End Else Begin
          i1:=T[i,j-1,P[i][j]];
          k:=1;
          While (k<=N) And
                Not ((j+1<=L[k]) And (P[k][j+1]=X) And (i1=T[k,j-1,P[k][j]]))
            Do Inc(k);
          If (k<=N) Then Begin
            T[i,j,X]:=k;
            Full[k,j+1]:=Full[k,j+1] Or (L[i]=j+1);
          End Else
            T[i,j,X]:=0;
        End;
      End {for 'A'..'Z'};
    End {for i};
  End {for j};
End {BuildTable};

Procedure Next(Var NoS:Word; Var Q:State; X:Char; Var Complete:Boolean);
{Input: NoS is the number of prefixes in Suff(S,P),
        (Q[1].i,Q[1].j),...,(Q[NoS].i,Q[NoS].j) are the representatives of
        the prefixes in Suff(S,P),
        X is the actual element of the sequence to be examined.
 Output:NoS is the number of prefixes in Suff(SX,P),
        (Q[1].i,Q[1].j),...,(Q[NoS].i,Q[NoS].j) are the representatives of
        the prefixes in Suff(SX,P),
        Complete is True iff the empty sequence is in Q.
}
  Var i,j,ii,newi,newj:word;
  Begin
    ii:=0; Complete:= False;
    For i:=1 To NoS Do Begin                            { compute next state }
      newi:=T[Q[i].i,Q[i].j,X]; newj:=Q[i].j+1;
      If newi>0 Then Begin
        Inc(ii);
        Q[ii].i:=newi; Q[ii].j:=newj;
        Complete:=Complete Or Full[newi,newj];
      End;
    End;
    If Complete Then Begin
      Inc(ii); Q[ii].i:=1;Q[ii].j:=0;             {include the empty string}
    End;
    NoS:=ii;
  End {Next};

Procedure Process;
{Global input variables: DataFile }
{Global output variables: Res }
Var
  X:Char;                               { the actual element of the sequence }
  Q:State;                          { set of prefixes of primitives that are
                                         suffixes of the sequence red so far }
  NoS:Word;                                    { number of the elements of Q }
  Slength:Longint;                       { length of the sequence red so far }
  Complete:Boolean;
Begin
  NoS:=1; Q[1].i:=1; Q[1].j:=0;                               { initialize Q }
  Res:=0; Slength:=1;
  ReadLn(DataFile,X);
  While (X<>'.') And (NoS>0) Do Begin
    Next(NoS,Q,X,Complete);
    If Complete Then Res:=Slength;
    ReadLn(DataFile,X);
    Inc(Slength);
  End {While};
  Close(DataFile);
End {Process};

Procedure WriteOut(Res:Longint);
  Var OutFile:Text;
Begin
  Assign(OutFile,'output.txt'); Rewrite(OutFile);
  WriteLn(OutFile,Res);
  Close(OutFile);
End;

Begin
  Init;
  BuildTable;
  Process;
  WriteOut(Res);
End.

{ Scientific Committee IOI'96 }
