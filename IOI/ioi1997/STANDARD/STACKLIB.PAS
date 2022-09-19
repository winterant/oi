unit stacklib;

interface

function getx:integer;
function gety:integer;
function getz:integer;
function getnextcontainer:integer;
function getnextaction:integer;
function getnextstoragetime:integer;
function movecontainer(x1,y1,x2,y2:integer):integer;
procedure refusecontainer;
procedure storearrivingcontainer(x,y:integer);
procedure removecontainer(x,y:integer);
procedure init(s1,s2:string);
procedure report;


implementation

type
	stype		= array[1..6] of integer;
    maptype		= array[1..32, 1..32, 0..32] of byte;

var
    x,y,z		: integer;
    i,j,tt		: integer;
    f2			: file of stype;
    t			: stype;
    a			: array[1..1000, 1..3] of integer;
    mm			: array[1..1000] of boolean;
    map			: ^maptype;
	movetime	: integer;

procedure error(k:integer);
begin
	write('ERROR at time ', i, ':');
    case k of
    	1:	write('Run procedure GetNextContainer after project is already finished.');
    	2:	write('Run procedure GetNextAction after project is already finished.');
    	3:	write('Run procedure GetNextStorageTime after project is already finished.');
    	4:	write('Run procedure RefuseContainer when a container is asked to remove.');
    	5:	write('Run procedure StorageArrivingContainer(', t[2], ',', t[3], ') when a container is asked to remove.');
    	6:	write('Run procedure RemoveContainer(', t[2], ',', t[3], ') when a container is asked to store.');
    	7:	write('Run procedure StorageArrivingContainer(', t[2], ',', t[3], ') when (', t[2], ',', t[3], ') is full.');
    	8:	write('Run procedure RemoveContainer(', t[2], ',', t[3], ') when it is empty.');
    	9:	write('Run procedure MoveContainer(', t[2], ',', t[3], ',', t[4], ',', t[5], ') when (', t[2],
			',', t[3], ') is empty.');
    	10:	write('Run procedure MoveContainer(', t[2], ',', t[3], ',', t[4], ',', t[5], ') when (', t[4],
			',', t[5], ') is full.');
    end;
    writeln;
    close(f2);
    halt(1);
end;

function getx:integer;
begin
    getx := x;
end;
function gety:integer;
begin
    gety := y;
end;
function getz:integer;
begin
    getz := z;
end;

function getnextcontainer:integer;
begin
    if i > j+1 then error(1);
    t[1] := 103;
    if i > j then t[2] := 0
    else t[2] := a[i,2];
    write(f2, t);
    if t[2] = 0 then
		close(f2);
    getnextcontainer := t[2];
end;

function getnextaction:integer;
begin
    if i > j then error(2);
	t[1] := 104;
    t[2] := a[i,1];
    write(f2,t);
	getnextaction := t[2];
end;

function getnextstoragetime:integer;
begin
    if i > j then error(3);
	t[1] := 105;
    t[2] := a[i,3];
    write(f2,t);
	getnextstoragetime := t[2];
end;

procedure refusecontainer;
begin
    if a[i,1] = 2 then error(4);
	t[1] := 106;
    t[2] := a[i,2];
    inc(tt);
    t[3] := tt;
    write(f2, t);
    inc(movetime,5);
    mm[t[2]] := true;
	inc(i);
    while (i <= j) and mm[a[i,2]] do inc(i);
end;

procedure storearrivingcontainer(x,y:integer);
begin
	t[1] := 107;
    t[2] := x;
    t[3] := y;
    if a[i,1] = 2 then error(5);
    if map^[x,y,0] = z then error(7);
    inc(map^[x,y,0]);
    map^[x,y,map^[x,y,0]] := a[i,2];
    write(f2, t);
    inc(i);
    while (i <= j) and mm[a[i,2]] do inc(i);
end;

procedure removecontainer(x,y:integer);
begin
	t[1] := 108;
    t[2] := x;
    t[3] := y;
	if a[i,1] = 1 then error(6);
    if map^[x,y,map^[x,y,0]] <> a[i,2] then error(8);
    dec(map^[x,y,0]);
    write(f2,t);
    inc(i);
    while (i <= j) and mm[a[i,2]] do inc(i);
end;

function movecontainer(x1,y1,x2,y2:integer):integer;
begin
	t[1] := 109;
    t[2] := x1;
    t[3] := y1;
    t[4] := x2;
    t[5] := y2;
    t[6] := 1;
    if map^[x1,y1,0] = 0 then error(9);
    if map^[x2,y2,0] = z then error(10);
    inc(map^[x2,y2,0]);
    map^[x2,y2,map^[x2,y2,0]] := map^[x1,y1,map^[x1,y1,0]];
    dec(map^[x1,y1,0]);
    write(f2, t);
    inc(movetime);
    movecontainer := 0;
end;

procedure init(s1,s2:string);
var
	f			: file;
begin
	assign(f, s1);
    reset(f,1);
    blockread(f, x, sizeof(x));
    blockread(f, y, sizeof(x));
    blockread(f, z, sizeof(x));
    blockread(f, j, sizeof(x));
    blockread(f, a, j*sizeof(a[1]));
    close(f);
    assign(f2, s2);
    rewrite(f2);
    fillchar(t, sizeof(t), 0);
    i := 1;
    movetime := 0;
    tt := 0;
    fillchar(mm, sizeof(mm), 0);
    new(map);
    fillchar(map^, sizeof(map^), 0);
end;

procedure report;
begin
	writeln;
	writeln('-------------------------');
    writeln('IOI''97 Day2 STACK Report');
    writeln('-------------------------');
	writeln('Size     : ', x, 'x', y, 'x', z);
    writeln('Volume   : ', x*y*z);
    writeln('Container: ', j div 2);
    writeln('Refuse   : ', tt);
    writeln('Move     : ', movetime-tt*5);
    writeln('Total Moving Times : ', movetime);
    writeln('-------------------------');
end;

begin
end.
