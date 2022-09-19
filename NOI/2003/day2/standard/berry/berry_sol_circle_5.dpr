program berry_sol_circle_5;
{$APPTYPE CONSOLE}
uses SysUtils;

const
  maxn = 10000;

var
  deg: array [1..maxn] of integer;
  li: array [1..maxn, 1..2] of integer;
  i, j, p, n, m, k, t, l, r, sum, ans, save: integer;
  v, q: array [1..maxn] of integer;
  FileName: string;

procedure error(const msg: string);
begin
  writeln(msg);
  close(input);
  halt(1);
end;

function get_k(const top: integer): integer;
var
  t, i: integer;
begin
  result := 0;
  t := 0;
  for i:=1 to n do
  begin
    inc(t, v[q[i]]);
    if t >= top then
    begin
      t := 0;
      inc(result);
    end;
  end;
end;

procedure get_k_and_out(const top: integer);
var
  t, i, j: integer;
begin
  t := 0;
  j := 1;
  for i:=1 to n do
  begin
    inc(t, v[q[i]]);
    if t >= top then
    begin
      t := 0;
      write(i - j + 1);
      while j <= i do
      begin
        write(' ', q[j]);
        inc(j);
      end;
      writeln;
    end;
  end;
  if j <= n then
  begin
    writeln('additional:');
    write(n - j + 1);
    while j <= n do
    begin
      write(' ', q[j]);
      inc(j);
    end;
  end;
 end;

begin
  write('File Name: '); readln(FileName);
  assign(input, FileName);
  reset(input);
  fillchar(deg, sizeof(deg), 0);
  read(n, m, k);
  if m <> n  then error('no circle!');
  for i:=1 to n do read(j, v[j]);
  for p:=1 to m do
  begin
    read(i, j);
    inc(deg[i]); inc(deg[j]);
    if deg[i] > 2 then error('no circle! edge');
    if deg[j] > 2 then error('no circle! edge');
    li[i, deg[i]] := j;
    li[j, deg[j]] := i;
  end;

  for i:=1 to 1258 do if deg[i] <> 0 then break;
  j := i;
  i := li[i, 1];
  p := 1;
  q[1] := j;
  while p < n do
  begin
    inc(p);
    q[p] := i;
    if li[i, 1] = j then
    begin
      j := i;
      i := li[i, 2];
    end else
    begin
      j := i;
      i := li[i, 1];
    end;
  end;
  inc(p);
  q[p] := i;

  if p <> n+1 then error('555');

  r := 0;
  for i := 1 to n do inc(r, v[q[i]]);
  sum := r;

  k := 21;

  ans := 0;

  for i:=1 to n do
  begin
    t := q[1];
    for j:=2 to n do q[j-1] := q[j];
    q[n] := t;
    
    l := 0;
    r := sum;
    while l <= r do
    begin
      t := (l + r) shr 1;
      if get_k(t) < k then r := t - 1 else l := t + 1;
    end;

    if r > ans then
    begin
      ans := r;
      save := i;
    end;
  end;

  assign(output, 'berry.std');
  rewrite(output);
  for i:=1 to save do
  begin
    t := q[1];
    for j:=2 to n do q[j-1] := q[j];
    q[n] := t;
  end;
  writeln(ans);
  get_k_and_out(ans);
  close(output);

  close(input);
end.
