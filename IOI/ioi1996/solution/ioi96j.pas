{
Solution of task JOBS
-------- -- ---- ----

Consider the following data structures.
Const
  MaxM=30;                  (* max number of machines *)
Type
  Operation='A'..'B';
  ProcTime=Array[Operation,1..MaxM] Of Word;
Var
  N:Longint;                 (* number of jobs *)
  M:Array[Operation] Of Word;(* M[op] is the number of machines of type op *)
  PTime: ProcTime;           (* PTime[op,m] is the processing time for machine
                               m of type op *)
Subtask A

It is obvious that an optimal schedule can be modified in such a way that
each machine starts processing at time 0 and never idle until performing
the operation on all jobs that are scheduled for that machine.
The maximal number of jobs that can be processed within time t by machine m
of type Op is t div PTime[Op,m]. Therefore the minimal amount of time that
is needed to perform operation Op on all N jobs is the least number t
such that the sum
  (t Div PTime[Op,i]) (for i:=1 to M[Op])
is greater or equal to N.
The following algorithm computes the total processing time for operation Op
in variable t:

    t:=0;
    Repeat
      Inc(t);
      Processed:=0;
      For i:=1 To M[Op] Do
        Processed:=Processed+(t Div PTime[Op,i]);
    Until Processed>=N;

Subtask B

It is obvious that the schedule for type A machines is the same as in case
of subtask A.
Let TAB be the minimal amount of time that is necessary to perform both
operations on all N jobs.
We may assume that each machine of type B finishes processing exactly at time
TAB and never idle between executing two consecutive jobs. If this is not
the case originally then we can modify the optimal schedule accordingly,
since if a job is available at a time in the intermediate container then this
job will be available later too.

Let d be the time when processing of the first job by a machine of type B
starts according to the optimal schedule. Denote by TB the minimal amount of
time that is necessary to perform single operation B on all N jobs.
By the same argument as in case of subtask A, we have that TAB=d+TB.
We already have an algorithm to compute the value TB, hence it remains to
develop an algorithm which computes the delay time d.

Let Finish(Op,t) be the number of jobs that are finished at time t according
to an optimal schedule for single operation Op.

The delay time d is the least number that satisfies the following condition:
  for every t, 0 <= t < TB at least Finish('B',TB-t) number of jobs are
  available in the intermediate container at time d+t.

We can check for a given d whether it satisfies the above condition. Therefore
the value d could be computed by starting d=1 and incrementing d while the
condition does not hold.
We have faster computation by using incremental method. This method works
as follows. The starting value for d is 1. Suppose that the above condition
holds for a given d and t values 0,...,ts. If the condition does not hold
for t value ts+1 then increase d until the condition holds.
This method is implemented in the program by the procedure Adjust.

}
Program Jobs;
Const
  MaxM=30;                    { max number of machines }
Type
  Operation='A'..'B';
  ProcTime=Array[Operation,1..MaxM] Of Word;
Var
  N:Longint;                  { number of jobs }
  M:Array[Operation] Of Word; { M[op] is the number of machines of type op }
  PTime: ProcTime;            { PTime[op,m] is the processing time for machine
                                m of type op }
  TA,         { the time needed to perform single operation A on all N jobs }
  TB: Longint;{ the time needed to perform single operation B on all N jobs }
  d :Longint;

Procedure ReadInput;
{ Global output variables: N, M, PTime }
  Var InFile: Text; i: Word;
  Begin
    Assign(InFile, 'input.txt'); Reset(InFile);
    ReadLn(InFile,N);
    ReadLn(InFile,M['A']);
    For i:=1 To M['A'] Do
      Read(InFile, PTime['A',i]);
    ReadLn(InFile);
    ReadLn(InFile,M['B']);
    For i:=1 To M['B'] Do
      Read(InFile, PTime['B',i]);

    Close(InFile);
  End {ReadInput};

Function Compute_Time(Op:Operation):Longint;
{Computes the minimal time that is needed to perform operation Op on N jobs}
{ Global input variables: M, PTime }
  Var t,Processed:Longint;
    i:Word;
  Begin
    t:=0;
    Repeat
      Inc(t);
      Processed:=0;
      For i:=1 To M[Op] Do
        Processed:=Processed+(t Div PTime[Op,i]);
    Until Processed>=N;
    Compute_Time:=t;
  End;{Compute_Time}

Function Finish(Op:Operation; t: Longint): Longint;
{ Finish(Op,t) is the number of jobs that are finished at time t
  according to the optimal schedule for single operation Op for N jobs. }
{ Global input variables: N, M, PTime }
  Var Res,UpTo: Longint;
    i: Word;
  Begin
    Res:=0;
    For i:=1 To M[Op] Do
      If (t Mod PTime[Op,i])=0 Then Inc(Res);
    { If the number of jobs that can be completed up to time t
      is more then N then decrease Res to the proper value. }
    UpTo:=0;
    For i:=1 To M[Op] Do UpTo:= UpTo+ (t-1) Div PTime[Op,i];
    If Upto >= N Then
      Res:= 0
    Else If Upto+Res>N Then
      Res:= N-UpTo;
    Finish:=Res;
  End {Finish};

Procedure Adjust;
{ Computes the delay time d when the first type B machine starts to work }
{ Global input variables: TA, TB }
{ Global output variables: d }
  Var Inter:Word;{ number of jobs in the intermediate container }
    t: Longint;
    JB:Word;
  Begin
    d:=1; t:=0; Inter:=0;
    While d+t<TA Do Begin
      Inter:=Inter+Finish('A',d+t);
      JB:=Finish('B',TB-t);    { # jobs starting at time d+t }
      While Inter<JB Do Begin  { while not enough jobs available }
        Inc(d);
        Inter:=Inter+Finish('A',d+t);
      End;
      Inter:=Inter-JB;
      Inc(t);
    End;
  End;{Adjust}

Procedure WriteOut(AnswerA,AnswerB:Longint);
  Var OutFile: Text;
  Begin
    Assign(OutFile, 'output.txt'); Rewrite(OutFile);
    WriteLn(OutFile, AnswerA);
    WriteLn(OutFile, AnswerB);
    Close(OutFile);
  End;{WriteOut}

Begin {Main}
  ReadInput;
  TA:= Compute_Time('A');
  TB:= Compute_Time('B');
  Adjust;
  WriteOut(TA, d+TB);
End.

{Scientific Committee for IOI'96}
