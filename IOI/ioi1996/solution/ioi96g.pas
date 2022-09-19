{
Solution for task GAME
-------- --- ---- ----
The following simple observation leads to a solution of the task:
Since the game board initially contains an even number of elements arranged
in a sequence, when the first player moves one end of the sequence is in odd
and the other end is in even position. Therefore the first player can always
select element either from odd or even position.
The algorithm pre-process the contents of the initial board before staring the
game to compute the values OddSum and EvenSum, the sum of the elements in odd
positions and the sum of the elements in even positions, respectively.
If OddSum>=EvenSum then the first player always selects from odd position
and force the second player to select from even position. The case
OddSum<EvenSum treated similarly.
}

Program Game;
Uses Play;
Const
  MaxN=100;               { max size of the board }
Var
  N: Word;                { size of the board }
  Board:Array[1..MaxN] Of Word; {contents of the board }
  Sum:Word;               { sum of the elements in the initial board }
  Sel:Word;               { sum of the elements selected by the first player }
  Odds:Boolean;

Procedure ReadInput;
{ Global output variables: N, Board, Sum }
Var InFile: Text;i:Word;
Begin
  Assign(InFile,'input.txt'); Reset(InFile);
  ReadLn(InFile,N);
  Sum:=0;
  For i:=1 To N Do Begin
    ReadLn(InFile,Board[i]);
    Sum:=Sum+Board[i];
  End;
  Close(InFile);
End;

Procedure Preprocess;
{ Global input variables: N, Board }
{ Global output variable: Odds }
Var i:Word;
  OddSum,EvenSum:Word;
Begin
  OddSum:=0;
  EvenSum:=0;
  For i:=1 To N Do
    If Odd(i) Then Inc(OddSum,Board[i])
              Else Inc(EvenSum,Board[i]);
  {end for i};
  Odds:=OddSum>=EvenSum;
End {Preprocess};

Procedure Playing;
{ Global input variable: N, Board, Odds }
{ Global output variable: Sel }
Var M,i:Word;
  C1,           { move of the first player }
  C2:Char;      { move of the second player }
  Head,         { position of the left end of the board }
  Tail:1..MaxN; { position of the right end of the board }
Begin
  Sel:=0;
  Head:=1; Tail:=N;
  M:=N Div 2;          { number of moves for one player}
  For i:=1 To M Do Begin
    If Odds Then Begin {select from the odd position}
      If Odd(Head) Then Begin
          Sel:=Sel+Board[Head];
          Inc(Head);
          C1:='L';
        End Else Begin
          Sel:=Sel+Board[Tail];
          Dec(Tail);
          C1:='R';
        End;
    End Else Begin     {select from the even position}
      If Odd(Head) Then Begin
        Sel:=Sel+Board[Tail];
        Dec(Tail);
        C1:='R';
      End Else Begin
        Sel:=Sel+Board[Head];
        Inc(Head);
        C1:='L';
      End;
    End {Odd-Even};
    MyMove(C1);        { perform the move }

    YourMove(C2);      { obtain the second player's move }
    If C2='L' Then Inc(Head)
              Else Dec(Tail);
  End{For i};
End;

Procedure WriteOut;
Var OutFile: Text;
Begin
  Assign(OutFile,'output.txt'); Rewrite(OutFile);
  WriteLn(OutFile,Sel,' ',Sum-Sel);
  Close(OutFile);
End;

Begin { Program }
  ReadInput;
  Preprocess;
  StartGame;
  Playing;
  WriteOut;
End.

{Scientific Committee IOI'96}
