program game_zig;
{$APPTYPE CONSOLE}
uses SysUtils;

const
  InputFileName = 'game.in';
  OutputFileName = 'game.out';

type
  TTransform = record
    Count: integer;
    l: array [1..3] of char;
  end;

var
  s, r: string;
  i, j, k, p, q: integer;
  f, g, h: array ['0'..'9'] of TTransform; // 0, +1, -1

procedure pair2(const a, b: integer); //  a + 1 -> b
begin
  with g[chr(a + ord('0'))] do
  begin
    inc(Count);
    l[Count] := chr(b + ord('0'));
  end;
  with h[chr(b + ord('0'))] do
  begin
    inc(Count);
    l[Count] := chr(a + ord('0'));
  end;
end;

procedure pair3(const a, b: integer); // a <-> b
begin
  with f[chr(a + ord('0'))] do
  begin
    inc(Count);
    l[Count] := chr(b + ord('0'));
  end;
  with f[chr(b + ord('0'))] do
  begin
    inc(Count);
    l[Count] := chr(a + ord('0'));
  end;
end;

function valid(s: string): boolean;
var
  i, x, left: integer;
  isplus: boolean;
begin
  left := 0;
  isplus := true;
  x := 0;
  for i:=1 to pos('=', s) do
  begin
    if s[i] in ['0'..'9'] then
    begin
      x := x * 10 + ord(s[i]) - ord('0');
    end else
    begin
      if isplus then inc(left, x) else dec(left, x);
      x := 0;
      if s[i] = '+' then isplus := true else isplus := false;
    end;
  end;

  isplus := true;
  for i:=pos('=', s)+1 to length(s) do
  begin
    if s[i] in ['0'..'9'] then
    begin
      x := x * 10 + ord(s[i]) - ord('0');
    end else
    begin
      if isplus then dec(left, x) else inc(left, x);
      x := 0;
      if s[i] = '+' then isplus := true else isplus := false;
    end;
  end;
  
  if isplus then dec(left, x) else inc(left, x);

  Result := left = 0;
end;

begin
  assign(input, InputFileName);
  assign(output, OutputFileName);
  reset(input); rewrite(output);

  fillchar(f, sizeof(f), 0);
  fillchar(g, sizeof(g), 0);
  fillchar(h, sizeof(h), 0);

	pair2(1,7); pair2(3,9); pair2(5,6); pair2(5,9); pair2(0,8); pair2(6,8); pair2(9,8);
	pair3(0,6); pair3(0,9); pair3(6,9); pair3(2,3); pair3(3,5);
  readln(s);
  s := copy(s, 1, pos('#', s) - 1);

  for i:=1 to length(s) do
   for j:=1 to length(s) do
    if (s[i] in ['0'..'9']) and (s[j] in ['0'..'9']) then
    begin
      if i = j then
      begin
        for k:=1 to f[s[i]].Count do
        begin
          r := s;
          r[i] := f[s[i]].l[k];
          if valid(r) then writeln(r, '#');
        end;
      end else
      begin
        for p:=1 to g[s[i]].Count do
         for q:=1 to h[s[j]].Count do
         begin
           r := s;
           r[i] := g[s[i]].l[p];
           r[j] := h[s[j]].l[q];
           if valid(r) then writeln(r, '#');
         end;
      end;
    end;
  close(input); close(output);
end.
