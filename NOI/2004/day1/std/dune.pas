program dune;

uses
        dune_lib;
const
        maxn=101;
        maxm=4001;
var
	now,n,m,from:longint;
	havestone,check:boolean;
	d,p,fa,fap:array [1..maxn] of longint;
	g,h:array [1..maxn,0..maxm-1] of longint;

	procedure dfs(k:longint);
	var
		_d,last,start,i:longint;
	begin
		look(_d,havestone);
		if havestone and (k<>n) then
		begin
			take_sign;
			check:=true;
			if k<>1 then
			begin
				walk(0);
				from:=fap[k];
			end
			else from:=p[k];
			exit;
		end;
		last:=0;
		if k=1 then last:=p[1];
		start:=1;
		if k=1 then start:=0;
		for i:=start to d[k]-1 do
			if (g[k,i]>0) and (g[k,i]<>n) then
			begin
				walk((i-last+d[k]) mod d[k]);
				dfs(g[k,i]);
				last:=i;
				if check then break;
			end;
		if k<>1 then
		begin
			from:=fap[k];
			walk((d[k]-last) mod d[k]);              		end;
	end;

	function isnew(now:longint):boolean;
	var
		way:array [0..maxn-1] of longint;
		num,next,i,j:longint;
	begin
		put_sign;
		num:=0;
		next:=0;
		while now<>1 do
		begin
			walk(d[now]-next);
			way[num]:=fap[now]; inc(num);
			next:=fap[now];
			now:=fa[now];
		end;
		check:=false;
		dfs(1);
		j:=d[1]-1;
		while g[1,j]=0 do dec(j);
		for i:=num-1 downto 0 do
			if i=num-1 then walk(d[1]-from+way[i]) else walk(way[i]);
		isnew:=not check;
	end;
	
begin
	init;
	now:=1;
	n:=1;
	m:=1;
	fillchar(d,sizeof(d),0);
	fillchar(p,sizeof(p),0);
	p[1]:=-1;
	fillchar(fa,sizeof(fa),0);
	fillchar(fap,sizeof(fap),0);
	fa[1]:=-1;
	look(d[now],havestone);
	while now<>-1 do
	begin
		walk(1);
		inc(p[now]);
		if p[now]=d[now] then
		begin
			now:=fa[now];
			if now=-1 then break;
			continue;
		end;
		inc(n);
		look(d[n],havestone);
		fa[n]:=now;
		fap[n]:=p[now];
		g[now,p[now]]:=n;
		g[n,0]:=now;
		if not isnew(n) then
		begin
			fa[n]:=0;
			fap[n]:=0;
			d[n]:=0;
			g[now,p[now]]:=-1;
			g[n,0]:=-1;
			dec(n);
			walk(0);
		end
		else begin
			now:=n;
			inc(m,d[n]);
			take_sign;
		end;
	end;
	inc(m,d[1]);
	m:=m div 2;
	report(n,m);
end.
	
