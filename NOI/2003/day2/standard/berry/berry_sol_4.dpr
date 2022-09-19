program berry_sol_4;
{$APPTYPE CONSOLE}
uses SysUtils;

const
  maxn = 50;
  maxv = 4000;
  maxl = maxn * maxv;

var
  i, j, k, n, m, p: integer;
  v: array [1..maxn] of integer;
  g: array [1..maxn, 1..maxn] of boolean;
  d: array [0..maxl] of boolean;
  check: array [1..maxn] of boolean;
  from: array [0..maxl] of integer;

procedure error(const msg: string);
begin
  writeln(msg);
  close(input);
  halt(1);
end;

begin
  assign(input, 'berry4.in');
  reset(input);
  read(n, m, k);
  if m <> n * (n - 1) div 2 then error('not complete');
  fillchar(g, sizeof(g), false);
  fillchar(from, sizeof(from), 0);
  for i:=1 to n do read(j, v[j]);
  for p:=1 to m do
  begin
    read(i, j);
    if g[i, j] then error('not complete');
    g[i, j] := true;
    g[j, i] := true;
  end;
  fillchar(d, sizeof(d), false);
  d[0] := true;
  for i:=1 to n do
  begin
    for j:=maxv*i downto v[i] do
     if d[j-v[i]] and not d[j] then
     begin
       d[j] := true;
       from[j] := i;
     end;
  end;

  assign(output, 'berry4.std');
  rewrite(output);
  p := 0;
  for i:=1 to n do inc(p, v[i]);
  p := p div 2;
  while not d[p] do dec(p);
  fillchar(check, sizeof(check), false);
  writeln(p);
  while p > 0 do
  begin
    check[from[p]] := true;
    dec(p, v[from[p]]);
  end;
  p := 0;
  for i:=1 to n do if check[i] then inc(p);
  write(p); for i:=1 to n do if check[i] then write(' ', i); writeln;
  write(n-p); for i:=1 to n do if not check[i] then write(' ', i); writeln;
  close(output);

  close(input);
end.
