const
    outputfile	= 'stack6.dat';
	x:integer	= 3;
    y:integer	= 3;
    z:integer	= 6;
    n:integer	= 50;
var
	f			: file of integer;
    a			: array[1..1000, 1..3] of integer;
    b,c			: array[1..1000] of integer;
    i,j,k,time	: integer;
    p			: boolean;
begin
	randomize;
	assign(f, outputfile);
    rewrite(f);
    i := n*2;
    write(f, x, y, z, i);
    fillchar(b, sizeof(b), 0);
    time := 0;
    for i := 1 to n*2 do
    begin
    	repeat
        	j := random(n)+1;
        until (b[j]<2);
        inc(b[j]);
        a[i,1] := b[j];
        a[i,2] := j;
        if b[j] = 1 then inc(time);
        if b[j] = 2 then c[j] := time;
    end;
    for i := 1 to n*2 do
    if a[i,1] = 1 then
    begin
    	j := c[a[i,2]];
        j := j+random(11)-5;
    	a[i,3] := j;
    end;
    for i := 1 to n*2 do
    write(f, a[i,1], a[i,2], a[i,3]);
    close(f);
end.
