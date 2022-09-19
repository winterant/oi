{ IOI 2001 population problem - optimized binary indexed tree solution }
program fastbixp (input, output);
var
   size, c, p1, p2, p3, p4 : longint;
   tab			   : array [0..1024, 0..1024] of longint;

procedure init (table_size : integer);
begin
   size := 1;
   while size < table_size do
      size := size shl 1;
end;

procedure update (amount, x, y : integer);
var
   ix : longint;
begin
   x := x + 1;
   y := y + 1;
   while y < (size + 1) do
   begin
      ix := x;
      while ix < (size + 1) do
      begin
	 tab [ix-1, y-1] := tab [ix-1, y-1] + amount;
	 ix := ix + (ix and (ix xor (ix - 1)));
      end;
      y := y + (y and (y xor (y - 1)));
   end;
end;

function query (x1, y1, x2, y2 : integer) : longint;
var
   result	      : longint;
   ix1, ix2, iy1, iy2 : longint;
begin	  
   result := 0;
   iy2 := y2 + 1;
   while iy2 > y1 do
   begin
      ix2 := x2 + 1;
      while ix2 > x1 do
      begin
	 result := result + tab[ix2-1, iy2-1];
	 ix2 := ix2 - (ix2 and (ix2 xor (ix2 - 1)));
      end;
      ix1 := x1;
      while ix1 > ix2 do
      begin
	 result := result - tab[ix1-1, iy2-1];
	 ix1 := ix1 - (ix1 and (ix1 xor (ix1 - 1)));
      end;
      iy2 := iy2 - (iy2 and (iy2 xor (iy2 - 1)));
   end;
   iy1 := y1;
   while iy1 > iy2 do
   begin
      ix2 := x2 + 1;
      while ix2 > x1 do
      begin
	 result := result - tab[ix2-1, iy1-1];
	 ix2 := ix2 - (ix2 and (ix2 xor (ix2 - 1)));
      end;
      ix1 := x1;
      while ix1 > ix2 do
      begin
	 result := result + tab[ix1-1, iy1-1];
	 ix1 := ix1 - (ix1 and (ix1 xor (ix1 - 1)));
      end;	 
      iy1 := iy1 - (iy1 and (iy1 xor (iy1 - 1)));
   end;
   query := result;
end;		

begin
   repeat
      read (c);
      case c of
	0 : begin
	       read (p1);
	       init (p1);
	    end;
	1 : begin
	       read (p1, p2, p3);
	       update (p3, p1, p2);
	    end;
	2 : begin
	       read (p1, p2, p3, p4);
	       writeln (query (p1, p2, p3, p4));
	    end;
      end; { case }
   until c = 3;
end.
	
	 
	 