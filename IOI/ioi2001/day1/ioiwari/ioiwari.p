Program Owari;

Const

  TSize=7;                               {# pits}

  Total=20;                              {total number of beads in pits}

  Inf  =2*Total+1;                       {infinity value for minimax}

  MaxN =6*6*6*6*6*6*6-1;                 {max. base-6 number=279936}



Type

  Board=Record

          Who:Boolean;                   {=True: first player moves next}

          Pit:Array[1..TSize] of Byte;   {Pit contents }

          Bank:Array[Boolean] of Integer;{Banks for players}

        End;

Var

  T:Array[Boolean,0..MaxN] of Byte;

  {T[w,b] is the best score difference for player w, that can be obtained

   from game position whose base-6 number is b }

  OM1: Array[0..MaxN] of Byte;           {winning moves for the first player}



  B:Board;                               {current game board}

  i:Longint;



Function B6N(Var B:Board):Longint;

{Base-6 number id of board B}

Const

  P6:Array[1..TSize] of Longint=(6*6*6*6*6*6,6*6*6*6*6,6*6*6*6,6*6*6,6*6,6,1);

Var i:Integer;

  a:Longint;

{Remark: Rotational equivalent of B that gives the least B6N should be taken

first.

 This would reduce the required memory to 121305 from 279936  }

Begin{B6N};

  a:=0;

  For i:=1 To TSize Do Begin

    a:=a+B.Pit[i]*P6[i];

  End;

  B6N:=a;

End{B6N};



Procedure Move(Var B:Board; i:Byte; Var BB:Board);

Var S:Integer;

  j:Byte;

  W0,W:Boolean;

Begin

  S:=B.Pit[i];

  W0:=B.Who;  {current player}

  W:=Not W0;  {opposite player}

  BB:=B;

  BB.Who:=W;

  BB.Pit[i]:=0;

    j:=i;

    While S>1 Do Begin

      Inc(j); If j>Tsize Then j:=1;

      If BB.Pit[j]=5 Then Begin

        Dec(BB.Pit[j]);

 	Inc(BB.Bank[W0]);

      End Else Begin

        Inc(BB.Pit[j]);

        Dec(S);

      End;

    End{while};



    Inc(j); If j>Tsize Then j:=1;

    If (BB.Pit[j]>=1)And(BB.Pit[j]<=4) Then Begin

      Inc(BB.Bank[W0],BB.Pit[j]+1);

      BB.Pit[j]:=0;

    End Else Begin

      Inc(BB.Bank[W]);

    End;

End{Move};



Function MinMax(Var B:Board):Integer;

{Returns the optimal score difference, and computes the optimal move for the

 first player. Computation is by recursion with memoization. }

Var

  i:Byte;

  BB:Board;

  Diffn,Diffs:Integer;

  a:Longint;

Begin{MinMax}

  a:=B6N(B);                       {base-6 number for B}



  If (T[B.Who,a])<>Inf Then Begin  {already computed, }

    MinMax:=T[B.Who, a];           {read the value from T}

    Exit;

  End;



  If B.Who Then Begin              {first player moves}

    Diffn:=-Inf;

    For i:=1 To TSize Do

      If (B.Pit[i]>0) Then Begin

        Move(B,i,BB);

        Diffs:=MinMax(BB)+(BB.Bank[True]-BB.Bank[False])-

                          (B.Bank[True]-B.Bank[False]);

        If Diffs>Diffn Then Begin

          Diffn:=Diffs;

          OM1[a]:=i;

        End;

      End;

    ;{for i}

  End Else Begin                   {second player moves}

    Diffn:=Inf;

    For i:=1 To TSize Do

      If (B.Pit[i]>0) Then Begin

        Move(B,i,BB);

        Diffs:=MinMax(BB)+(BB.Bank[True]-BB.Bank[False])-

                          (B.Bank[True]-B.Bank[False]);

        If Diffs<Diffn Then Begin

          Diffn:=Diffs;

        End;

      End;{for i}

  End;



  T[B.Who, a]:=Diffn;              {memoise}

  MinMax:=Diffn;

End{MinMax};



Procedure Play(Var B:Board);

{Play the game}

Var i,ii:Integer;

  a:Longint;

Begin

  While True Do Begin

    a:=B6N(B);

    i:=OM1[a];

    Move(B,i, B);

    WriteLn(i);



    If B.Bank[true]+B.Bank[false]=Total Then halt;



    ReadLn(ii);

    Move(B, ii, B);

    If B.Bank[true]+B.Bank[false]=Total Then halt;

  End{while};



End{Play};



Begin{Prog}

  For i:=1 To TSize Do      {read the initial game position}

    ReadLn(B.Pit[i]);

  B.Bank[True]:=0;          {init bank contents}

  B.Bank[False]:=0;

  B.Who:=True;              {first player moves first}



  For i:=1 To MaxN Do Begin {init for minimax computation}

    T[True, i]:=Inf;

    T[False,i]:=Inf;

  End;

  T[True, 0]:=Total;

  T[False,0]:=Total;

  OM1[0]:=0;



  MinMax(B);                {compute optimal moves for the first player}



  Play(B);                  {play the game}

End.



