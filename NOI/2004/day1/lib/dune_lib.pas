unit dune_lib;

interface

procedure init;
procedure put_sign;
procedure take_sign;
procedure walk(i:longint);
procedure look(var roadnum:longint; var stone:boolean);
procedure report(ncave,nchannel:longint);

implementation

const
	MaxN=100;
	MaxM=4000;
	
var
	n,m,nowpos,nowroad,Count,score:longint;
	initialized, isInTest:boolean;
	stone,cave,channel:boolean;
	havestone:array [1..MaxN] of boolean;
	g,h:array [1..MaxN,0..MaxM-1] of longint;
	d:array [1..MaxN] of longint;

procedure error(s:string);
begin
	if (not isInTest) then writeln(s)
	else writeln(-1);
	close(input);
	close(output);
	halt;
end;
	
procedure init;
var
	i,j,k:longint;
begin
	if (initialized) then error('You have called init twice!');
	initialized:=true;
	assign(input,'dune.in');
	reset(input);
	read(n);
	isInTest:=false;
	if (n=0) then
	begin
		read(n, m);
		isInTest:=true;
	end;
	if (isInTest) then assign(output, 'dune.out')
	else assign(output, 'dune.log');
	rewrite(output);
    if (not isInTest) then writeln('init');
	m:=0;
	for i:=1 to n do
	begin
		read(d[i]);
		inc(m,d[i]);
		for j:=0 to d[i]-1 do read(g[i,j]);
	end;
	m:=m div 2;
	for i:=1 to n do
		for j:=0 to d[i]-1 do
		begin
			for k:=1 to d[g[i,j]] do
				if g[g[i,j],k]=i then break;
			h[i,j]:=k;
		end;
	nowpos:=1;
	nowroad:=0;
	stone:=true;
	fillchar(havestone,sizeof(havestone),0);
        Count:=0;
	score:=0;
	cave:=false;
	channel:=false;
end;

procedure put_sign;
begin
	if (not isInTest) then writeln('put_sign');
	if (not initialized) then error('You must call init first');
	if (not stone) then error('Error in put_sign');
	stone:=false;
	havestone[nowpos]:=true;
end;

procedure take_sign;
begin
	if (not isInTest) then writeln('take_sign');
	if (not initialized) then error('You must call init first');
	if (not havestone[nowpos]) then error('Error in take_sign');
	stone:=true;
	havestone[nowpos]:=false;
end;

procedure walk(i:longint);
var
	nextpos:longint;
begin
	if (not isInTest) then writeln('walk(', i, ')');
	if (not initialized) then error('You must call init first');
	nextpos:=g[nowpos,(nowroad+i) mod d[nowpos]];
	nowroad:=h[nowpos,(nowroad+i) mod d[nowpos]];
	nowpos:=nextpos;
	inc(Count);
end;

procedure look(var roadnum:longint; var stone:boolean);
begin
	if (not isInTest) then writeln('look(d, sign) returned with d=', d[nowpos], ', sign=', havestone[nowpos]);
	if (not initialized) then error('You must call init first');
	roadnum:=d[nowpos];
	stone:=havestone[nowpos];
end;

procedure report(ncave,nchannel:longint);
begin
	if (not isInTest) then writeln('report(', ncave, ', ', nchannel, ')');
	if (not initialized) then error('You must call init first');
	if (not isInTest) then
	begin
		if ncave=n then writeln('The number of caves is correct!')
		else writeln('The number of caves is NOT correct!');
		if nchannel=m then writeln('The number of channels is correct!')
		else writeln('The number of channels is NOT correct!');
        writeln('You have walked ',Count,' time(s)!');
    end
    else begin
    	writeln(count);
    	writeln(ncave, ' ', nchannel);
    end;
    close(input);
    close(output);
    halt;
end;

begin
  initialized := false;
end.

