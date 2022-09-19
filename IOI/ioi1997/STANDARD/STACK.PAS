{$M 65520,0,655360}
uses stacklib;

label
    hasfound;

var
    x,y,z       : integer;
    i,j,k,s,l   : integer;
    total       : integer;
    mi,mj,ntime : integer;
    map         : array[1..32, 1..32, 0..32] of byte;
    no,time     : array[1..500] of integer;

function get(t1,t2:integer):integer;
var
    i,j,k1,k2   : integer;
begin
    k1 := 0; k2 := 0;
    for i := t1-5 to t1+5 do
    	if (i >= 1) then
        for j := t2-5 to t2+5 do
        if (j >= 1) then
        if i > j then inc(k1)
        else if i < j then inc(k2);
    get := round(k1/(k1+k2)*100);
end;

procedure put(s,zi,zj:integer);
var
    i,j,k,l,m   : integer;
    mina        : integer;
begin
    mina := maxint;
    for i := 1 to x do
        for j := 1 to y do
        if (i <> zi) or (j <> zj) then
        if map[i,j,0] < z then
        begin
            k := 0;
            for l := 1 to map[i,j,0] do
                inc(k,get(time[s],time[map[i,j,l]]));
            if (k < mina) or (map[i,j,0] > 0) and (k = mina) then
            begin
                mina := k;
                mi := i;
                mj := j;
            end;
        end;
end;

begin
    init('stack.dat', 'stack.out');
    x := getx; y := gety; z := getz;
    fillchar(map, sizeof(map), 0);
    fillchar(time, sizeof(time), 0);
    fillchar(no, sizeof(no), 0);
    i := getnextcontainer;
    total := 0;
    ntime := 0;
    while i <> 0 do
    begin
        j := getnextaction;
        s := 1;
        inc(ntime);
        if j = 1 then
        begin
            while no[s] > 0 do inc(s);
            no[s] := i;
        end
        else
            while no[s] <> i do inc(s);
        if j = 1 then
        begin
            if (x*y-1)*z+1<=total then
                refusecontainer
            else
            begin
                time[s] := getnextstoragetime+ntime;
                put(s,0,0);
                inc(map[mi,mj,0]);
                map[mi,mj,map[mi,mj,0]] := s;
                storearrivingcontainer(mi, mj);
                inc(total);
            end;
        end
        else
        begin
            for i := 1 to x do
                for j := 1 to y do
                    for k := 1 to map[i,j,0] do
                    if map[i,j,k] = s then goto hasfound;
            hasfound:
            for l := map[i,j,0] downto k+1 do
            begin
                put(map[i,j,l], i, j);
                inc(map[mi,mj,0]);
                map[mi,mj,map[mi,mj,0]] := map[i,j,l];
                movecontainer(i, j, mi, mj);
                dec(map[i,j,0]);
            end;
            removecontainer(i, j);
            dec(map[i,j,0]);
            dec(total);
            no[s] := 0;
        end;
        i := getnextcontainer;
    end;
    report;
end.
