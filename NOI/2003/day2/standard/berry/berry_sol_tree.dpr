program berry_sol_tree;
{$APPTYPE CONSOLE}
uses SysUtils;

const
  maxn = 10000;
  maxm = maxn * 2;

var
  n, m, k, l, r, sum, i, j, t, cl, op: integer;
  FileName: string;
  v, head, fa, q, tv: array [1..maxn] of integer;
  e, next: array [1..maxm] of integer;
  check: array [1..maxn] of boolean;

procedure error(const msg: string);
begin
  writeln(msg);
  close(input);
  halt(1);
end;

function get_k(const top: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i:=1 to n do tv[i] := v[i];
  for i:=n downto 1 do
  begin
    if tv[q[i]] >= top then
    begin
      inc(Result);
    end else
    begin
      if i <> 1 then inc(tv[fa[q[i]]], tv[q[i]]);
    end;
  end;
end;

procedure print_sub_tree(const root: integer);
var
  i: integer;
  q: array [1..maxn] of integer;
begin
  if check[root] then
  begin
    writeln('conflicted at ', root);
    exit;
  end;
  cl := 0;
  op := 1;
  q[1] := root;
  check[root] := true;
  repeat
    inc(cl);
    i := head[q[cl]];
    while i <> 0 do
    begin
      if (e[i] <> fa[q[cl]]) and not check[e[i]] then
      begin
        inc(op);
        q[op] := e[i];
        check[q[op]] := true;
      end;
      i := next[i];
    end;
  until cl >= op;
  write(op);
  for i:=1 to op do write(' ', q[i]);
  writeln;
end;

procedure get_k_and_out(const top: integer);
var
  i: integer;
  flag: boolean;
begin
  fillchar(check, sizeof(check), false);
  for i:=1 to n do tv[i] := v[i];
  t := 0;
  flag := true;
  for i:=n downto 1 do
  begin
    if tv[q[i]] >= top then
    begin
      print_sub_tree(q[i]);
      inc(t);
      if t >= k then
      begin
        if i = 1 then flag := false;
        break;
      end;
    end else
    begin
      if i <> 1 then inc(tv[fa[q[i]]], tv[q[i]]);
    end;
  end;
  if flag then
  begin
    writeln('addtional:');
    print_sub_tree(q[1]);
  end;
end;

begin
  write('File Name: '); readln(FileName);
  assign(input, FileName);
  reset(input);
  read(n, m, k);
  for i:=1 to n do read(j, v[j]);
  if m <> n - 1 then error('no tree!');
  fillchar(head, sizeof(head), 0);
  for t:=1 to m do
  begin
    read(i, j);
    e[2*t-1] := j;
    next[2*t-1] := head[i];
    head[i] := 2*t-1;
    e[2*t] := i;
    next[2*t] := head[j];
    head[j] := 2*t;
  end;
  fillchar(fa, sizeof(fa), 0);
  q[1] := 1;
  cl := 0;
  op :=1;
  repeat
    inc(cl);
    i := head[q[cl]];
    while i <> 0 do
    begin
      if e[i] <> fa[q[cl]] then
      begin
        inc(op);
        q[op] := e[i];
        fa[e[i]] := q[cl];
      end;
      i := next[i];
    end;
  until cl >= op;
  if op <> n then error('unknown error!');
  sum := 0;
  for i:=1 to n do inc(sum, v[i]);
  l := 0;
  r := sum;
  while l <= r do
  begin
    t := (l + r) shr 1;
    if get_k(t) < k then r := t - 1 else l := t + 1;
  end;
  assign(output, 'berry.std');
  rewrite(output);
  writeln(r);
  get_k_and_out(r);
  close(output);
  close(input);
end.
