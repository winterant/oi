program berry_sol_1;
{$APPTYPE CONSOLE}
uses SysUtils;

const
  InputFileName = 'berry1.in';
  OutputFileName = 'berry1.std';

const
  maxn = 10;

var
  i, j, n, m, k, p, t, currmin, tmin, maxmin: integer;
  g: array [1..maxn, 1..maxn] of boolean;
  v, c, sc: array [1..maxn] of integer;
  check: array [1..maxn] of boolean;

procedure depth_first_search(x, cx: integer);
var
  i: integer;
begin
  if not check[x] and (c[x] = cx) then
  begin
    inc(tmin, v[x]);
    check[x] := true;
    for i:=1 to n do
     if g[x, i] and (c[i] = cx) and not check[i] then
      depth_first_search(i, cx);
  end;
end;

procedure checknum;
var
  i, j, p: integer;
begin
  j := 0; p := 0;
  fillchar(check, sizeof(check), false);
  currmin := maxlongint;
  for i:=1 to n do
   if not check[i] then
   begin
     inc(j);
     inc(p, c[i]);
     tmin := 0;
     depth_first_search(i, c[i]);
     if tmin < currmin then currmin := tmin;
   end;
  if (j = 3) and (p = 6) then
  begin
    if currmin > maxmin then
    begin
      maxmin := currmin;
      sc := c;
    end;
  end;
end;

procedure depth(dep: integer);
var
  i: integer;
begin
  if dep > n then
  begin
    checknum;
  end else
  begin
    for i:=1 to k do
    begin
      c[dep] := i;
      depth(dep+1);
    end;
  end;
end;

begin
  assign(input, InputFileName);
  assign(output, OutputFileName);
  reset(input); rewrite(output);
  read(n, m, k);
  fillchar(g, sizeof(g), false);
  for i:=1 to n do read(j, v[j]);
  for p:=1 to m do
  begin
    read(i, j);
    g[i, j] := true;
    g[j, i] := true;
  end;
  maxmin := -1;
  depth(1);
  writeln(maxmin);
  for i:=1 to k do
  begin
    t := 0;
    for j:=1 to n do
     if sc[j] = i then
      inc(t);
    write(t);
    for j:=1 to n do
     if sc[j] = i then
      write(' ', j);
    writeln;
  end;
  close(input); close(output);
end.
