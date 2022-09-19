unit oracle;

interface

procedure start_string;
function  oracle_call(s:String) : integer;
procedure answer_string(s:String);

implementation

Uses SysUtils;

var
	oracle_cnt:integer;
	fin,fout:text;
	sin:String;

procedure ABOUT(e:String);
begin
	writeln (e);
	halt (2);
end;

procedure start_string;
begin
	oracle_cnt:=0;
	assign (fin, 'string.in' );	
	{$I-}	
	reset(fin);
	{$I+}
	if (IOresult <> 0) then ABOUT('Error: Cannot open ''string.in''.');
	readln(fin,sin);
	assign (fout, 'string.out' );	
	{$I-}		
	rewrite(fout);	
	{$I+}	
	if (IOresult <> 0) then ABOUT('Error: Cannot open ''string.out''.');	
end;

function oracle_call(s:String) : integer ;
var i:integer;
    tt:integer;
begin
	if oracle_cnt=-99 then ABOUT('ERROR: start_string() called at first.');
	for i:=1 to length(s) do
		if ((s[i]<>'A') and (s[i]<>'G') and (s[i]<>'T') and (s[i]<>'C')) then
		ABOUT('ERROR: other character except A,T,G,C appeared.');
	if (length(s)=0) then ABOUT('ERROR: S should not be null.');
	if (length(s)>255) then ABOUT('ERROR: The length of query S shold be less than 255 chars.');
	inc(oracle_cnt);
	if (pos(sin, s) <> 0) then tt:=1 else tt:=0;	
	oracle_call:=tt;
end;


procedure answer_string(s:String);
begin
	if oracle_cnt=-99 then ABOUT('ERROR: start_string() called at first.');
	writeln(fout,oracle_cnt);
	writeln(fout,s);	
	close(fout);
	close(fin);	
	halt;
end;

begin
	oracle_cnt:=-99;
end.


