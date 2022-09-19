program berry_sol_int_5;
{$APPTYPE CONSOLE}
uses SysUtils, Math;

const
  maxk = 100;

var
  a, b, c: array [1..maxk] of integer;
  i, j, k, ans, save1, save2, save3: integer;

begin
  k := 57;
  assign(input, 'berry5.std.1');
  reset(input);
  for i:=1 to k do read(j, a[j]);
  close(input);
  assign(input, 'berry5.std.2');
  reset(input);
  for i:=1 to k do read(j, b[j]);
  close(input);
  assign(input, 'berry5.std.3');
  reset(input);
  for i:=1 to k do read(j, c[j]);
  close(input);
  ans := 0;
  for i:=1 to k-2 do
   for j:=1 to k-i-1 do
   begin
     if min(min(a[i], b[j]), c[k-i-j]) > ans then
     begin
       ans := min(min(a[i], b[j]), c[k-i-j]);
       save1 := i;
       save2 := j;
       save3 := k - i - j;
     end;
   end;
  writeln(ans); // 54612
  writeln(save1, ' ', save2, ' ', save3); // 21 17 19
end.
