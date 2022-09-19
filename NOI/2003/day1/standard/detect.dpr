program detect;
{$APPTYPE CONSOLE}
uses detect_lib;

const
  minc = -10002;
  maxc = 10002;
  maxn = 1000;
  EpsReal = 1e-5;

type
  TAnswer = record
    a1, a2: double;
    got, notnull: boolean;
  end;

var
  d: array [minc..maxc] of TAnswer;
  p: array [0..maxn+1, 1..2] of integer;
  l, r, i, j, m, n: integer;
  t: double;

function query(const x: integer): boolean;
var
  t: double;
begin
  if d[x].got then Result := d[x].notnull else
  begin
    Result := ask_x(x, d[x].a1, d[x].a2) > 0;
    if d[x].a1 > d[x].a2 then
    begin
      t := d[x].a1;
      d[x].a1 := d[x].a2;
      d[x].a2 := t;
    end;
    d[x].got := true;
    d[x].notnull := Result;
  end;
end;

begin
  prog_initialize();
  fillchar(d, sizeof(d), 0);
  m := 0;
  l := minc; r := 0;
  while l <= r do
  begin
    m := (l + r) div 2;
    if query(m) then
    begin
      if d[m].a1 = d[m].a2 then break else r := m - 1;
    end else l := m + 1;
  end;
  n := 1;
  p[1, 1] := m; p[1, 2] := trunc(d[m].a1);

  j := m+2;
  while (not d[j].notnull) and (j < maxc) do inc(j);

  while query(p[n, 1] + 1) do
  begin
    t := d[p[n, 1] + 1].a1 - d[p[n, 1]].a1;
    for i:=1 to maxc*2 do
     if frac(abs(t * i) + 1e-8) < EpsReal then break;
    if abs(t * (j - p[n, 1]) + p[n, 2] - d[j].a1) < EpsReal then
    begin
      l := (j - 2 - p[n, 1]) div i + 1;
      inc(j);
      while j < maxc do
      begin
        if d[j].notnull then
        begin
          if abs(t * (j - p[n, 1]) + p[n, 2] - d[j].a1) > EpsReal then break;
        end;
        inc(j);
      end;
      r := (j - p[n, 1]) div i;
    end else
    begin
      l := 1;
      r := (j - p[n, 1]) div i;
    end;

    while l <= r do
    begin
      m := (l + r) shr 1;
      if query(p[n, 1] + m * i) then
      begin
        if abs(t * i * m + p[n, 2] - d[p[n, 1] + m * i].a1) < EpsReal then l := m + 1 else
        begin
          r := m - 1;
          j := p[n, 1] + m * i;
        end;
      end else
      begin
        r := m - 1;
        j := p[n, 1] + m * i;
      end;
    end;

//    query(l);
    inc(n);
    p[n, 1] := p[n-1, 1] + r * i;
    p[n, 2] := trunc(d[p[n-1, 1] + r * i].a1);
  end;

  j := p[n, 1] - 2;
  while (not d[j].notnull) and (j > minc) do dec(j);

  while query(p[n, 1] - 1) do
  begin
    t := d[p[n, 1] - 1].a2 - d[p[n, 1]].a2;
    for i:=1 to maxc*2 do
     if frac(abs(t * i) + 1e-8) < EpsReal then break;

    if abs(t * (p[n, 1] - j) + p[n, 2] - d[j].a2) < EpsReal then
    begin
      l := (p[n, 1] - 2 - j) div i + 1;
      dec(j);
      while j > minc do
      begin
        if d[j].notnull then
        begin
          if abs(t * (p[n, 1] - j) + p[n, 2] - d[j].a2) > EpsReal then break;
        end;
        dec(j);
      end;
      r := (p[n, 1] - j) div i;
    end else
    begin
      l := 1;
      r := (p[n, 1] - j) div i;
    end;

    while l <= r do
    begin
      m := (l + r) shr 1;
      if query(p[n, 1] - m * i) then
      begin
        if abs(t * i * m + p[n, 2] - d[p[n, 1] - m * i].a2) < EpsReal then l := m + 1 else
        begin
          r := m - 1;
          j := p[n, 1] - m * i;
        end;
      end else
      begin
        r := m - 1;
        j := p[n, 1] - m * i;
      end;
    end;
//    query(l);
    inc(n);
    p[n, 1] := p[n-1, 1] - r * i;
    p[n, 2] := trunc(d[p[n-1, 1] - r * i].a2);
    if (p[n, 1] = p[1, 1]) and (p[n, 2] = p[1, 2]) then break;
  end;

  t := 0;
  p[0] := p[n-1];
  for i:=1 to n-1 do t := t + p[i, 1] * (p[i+1, 2] - p[i-1, 2]);

  ret_area(abs(t) / 2);
  ret_n(n-1);
  for i:=1 to n-1 do ret_vertex(p[i, 1], p[i, 2]);
end.

