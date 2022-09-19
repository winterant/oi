
unit undertpu;

interface
   procedure start;
   procedure move(ch:char);
   function look(ch:char):char;
   procedure finish(x,y:integer);

implementation
   uses dos;
   const
      serdarWALL='W';
      serdarOPEN='O';
      serdarMARK='c';
      OUR_FILE_SIZE		=6;
      start_not_called  	=  1;
      move_to_wall          	=  2;
      file_size_wrong           =  3;
      wrong_argument         	=  4;
      a_lot_start               =  5;
      a_lot_looks       	=  7;
   var
      serdarn,serdarm                           :integer;
      serdartahta:array [0..99,0..99] of char;
      serdarch                                  :char;
      serdarx,serdary,serdarmin                 :integer;
      basx,basy                                 :integer;
      serdarcompetition                         :boolean;
      serdar_num_looks                          :word;
      serdarstart                               :boolean;

      ffblk:SearchRec;
      our_file:string[10];

      eval_inp_dosyasi  :string[10];
      inp_dosyasi       :string[11];
      pla_dosyasi  :string[10];
      xy_dosyasi   :string[7];
      puan_dosyasi :string[9];
      result_dosyasi:string[11];

      ten,zero:byte;

procedure serdar_error(x:integer);forward;

function serdarust(x:integer):integer;
begin serdarust:=(((x)+serdarn-1) mod serdarn);end;


function serdarsol(x:integer):integer;
begin serdarsol:=(((x)+serdarm-1) mod serdarm);end;

function serdaralt(x:integer):integer;
begin serdaralt:=(((x)+1) mod serdarn);end;

function serdarsag(x:integer):integer;
begin serdarsag:=(((x)+1) mod serdarm);end;





procedure solve_names;
   var
      i:integer;
begin
   for i:=1 to Length(inp_dosyasi) do
       inp_dosyasi[i]:=chr(ord(inp_dosyasi[i])+40);
   for i:=1 to Length(eval_inp_dosyasi) do
       eval_inp_dosyasi[i]:=chr(ord(eval_inp_dosyasi[i])+40);
   for i:=1 to Length(pla_dosyasi) do
       pla_dosyasi[i]:=chr(ord(pla_dosyasi[i])+40);
   for i:=1 to Length(xy_dosyasi) do
       xy_dosyasi[i]:=chr(ord(xy_dosyasi[i])+40);
   for i:=1 to Length(our_file) do
       our_file[i]:=chr(ord(our_file[i])+40);
   for i:=1 to Length(puan_dosyasi) do
       puan_dosyasi[i]:=chr(ord(puan_dosyasi[i])+40);
   for i:=1 to Length(result_dosyasi) do
       result_dosyasi[i]:=chr(ord(result_dosyasi[i])+40);
end;


procedure start;
   var
      i,j:integer;
      f:TEXT; 
   begin

if (serdarstart) then serdar_error(a_lot_start);

   solve_names;
   findfirst(our_file,AnyFile,ffblk);
if(doserror<>0) then
   serdarcompetition:=true
else
begin
   if(ffblk.size = OUR_FILE_SIZE) then
       serdarcompetition:=False
   else
       begin
	  serdarstart:=true;
	  serdar_error(file_size_wrong);
       end;
end;



   if(serdarcompetition) then assign(f,inp_dosyasi) else assign(f,eval_inp_dosyasi);
   reset(f);
   read(f,serdarm,serdarn);
   for i:=0 to serdarn-1 do
   begin
      for j:=0 to serdarm-1 do
         read(f,serdartahta[i,j]);
      readln(f);
   end;
   read(f,serdarch);
   close(f);


   if(serdarcompetition) then
     begin
      assign(f,pla_dosyasi);
      reset(f);
      read(f,serdarx,serdary);
      close(f);
     end
   else
     begin
      assign(f,xy_dosyasi);
      reset(f);
      read(f,serdarx,serdarmin,serdary);
      close(f);
     end;
   basx:=serdarx;
   basy:=serdary;

   serdary:=basx-1;
   serdarx:=serdarn-basy;

   serdarstart:=true;
end;

procedure serdar_error(x:integer);
var
   f:TEXT;
begin
  if(not serdarstart) then solve_names;
  if(serdarcompetition) then
  begin
     assign(f,result_dosyasi);
     rewrite(f);
     write(f,'Error');
     close(f);
  end
  else begin
   assign(f,puan_dosyasi);
   rewrite(f);
   write(f,x,' ',zero);
   close(f);
  end;
   halt;
end;

procedure move(ch:char);
begin
if(not serdarstart)then serdar_error(start_not_called);
   case ch of
      'S':serdarx:=serdaralt(serdarx);
      'N':serdarx:=serdarust(serdarx);
      'E':serdary:=serdarsag(serdary);
      'W':serdary:=serdarsol(serdary);
   else serdar_error(wrong_argument);
   end;
   if(serdartahta[serdarx,serdary]<>serdarOPEN)then serdar_error(move_to_wall);
end;


function look(ch:char):char;
begin
if(not serdarstart)then serdar_error(start_not_called);
if (serdar_num_looks>20000) then serdar_error(a_lot_looks);
inc(serdar_num_looks);
   case ch of
      'S':if(serdartahta[serdaralt(serdarx),serdary]=serdarOPEN)
	    then look:=serdarOPEN else look:=serdarWALL;
      'N':if(serdartahta[serdarust(serdarx),serdary]=serdarOPEN)
	    then look:=serdarOPEN else look:=serdarWALL;
      'E':if(serdartahta[serdarx,serdarsag(serdary)]=serdarOPEN)
	    then look:=serdarOPEN else look:=serdarWALL;
      'W':if(serdartahta[serdarx,serdarsol(serdary)]=serdarOPEN)
	    then look:=serdarOPEN else look:=serdarWALL;
      else serdar_error(wrong_argument);
   end;
end;


procedure finish(x,y:integer);
   var
      f:TEXT;
      puan:integer;
begin
  if(not serdarstart)then serdar_error(start_not_called);

  if (serdarcompetition) then assign(f,result_dosyasi) else assign(f,puan_dosyasi);
  rewrite(f);
   if(serdarcompetition) then
    begin
      writeln(f,x,' ',y);
      write(f,'You used look ',serdar_num_looks,' times');
    end
   else if(x=basx) and (y=basy) then
   begin
      if (serdar_num_looks <= serdarmin) then puan:=ten
      else if (serdar_num_looks >= serdarmin+serdarmin) then puan:=zero
	   else puan:= trunc (  ( 10.0 * ( 2.0 * serdarmin - serdar_num_looks  )   ) / serdarmin  + 0.5);

      write(f,zero,' ',puan);

   end
   else
   begin
      write(f,ten,' ',zero);
   end;
  close(f);
   halt;
end;



begin
   serdar_num_looks:=0;
   serdarstart:=false;

   ten:=10;
   zero:=0;

   eval_inp_dosyasi[0]:=chr(9);
   eval_inp_dosyasi[1]:=chr(65);
   eval_inp_dosyasi[2]:=chr(70);
   eval_inp_dosyasi[3]:=chr(72);
   eval_inp_dosyasi[4]:=chr(77);
   eval_inp_dosyasi[5]:=chr(76);
   eval_inp_dosyasi[6]:=chr(6);
   eval_inp_dosyasi[7]:=chr(76);
   eval_inp_dosyasi[8]:=chr(80);
   eval_inp_dosyasi[9]:=chr(76);
   eval_inp_dosyasi[10]:=chr(0);

   inp_dosyasi[0]:=chr(9);
   inp_dosyasi[1]:=chr(77);
   inp_dosyasi[2]:=chr(70);
   inp_dosyasi[3]:=chr(60);
   inp_dosyasi[4]:=chr(61);
   inp_dosyasi[5]:=chr(74);
   inp_dosyasi[6]:=chr(6);
   inp_dosyasi[7]:=chr(65);
   inp_dosyasi[8]:=chr(70);
   inp_dosyasi[9]:=chr(72);
   inp_dosyasi[10]:=chr(0);

   pla_dosyasi[0]:=chr(9);
   pla_dosyasi[1]:=chr(72);
   pla_dosyasi[2]:=chr(68);
   pla_dosyasi[3]:=chr(57);
   pla_dosyasi[4]:=chr(59);
   pla_dosyasi[5]:=chr(61);
   pla_dosyasi[6]:=chr(6) ;
   pla_dosyasi[7]:=chr(76);
   pla_dosyasi[8]:=chr(80);
   pla_dosyasi[9]:=chr(76);
   pla_dosyasi[10]:=chr(0) ;

   xy_dosyasi[0]:=chr(6);
   xy_dosyasi[1]:=chr(80);
   xy_dosyasi[2]:=chr(81);
   xy_dosyasi[3]:=chr(6) ;
   xy_dosyasi[4]:=chr(63);
   xy_dosyasi[5]:=chr(65);
   xy_dosyasi[6]:=chr(74);
   xy_dosyasi[7]:=chr(0) ;

   puan_dosyasi[0]:=chr(8);
   puan_dosyasi[1]:=chr(72);
   puan_dosyasi[2]:=chr(77);
   puan_dosyasi[3]:=chr(57);
   puan_dosyasi[4]:=chr(70);
   puan_dosyasi[5]:=chr(6) ;
   puan_dosyasi[6]:=chr(59);
   puan_dosyasi[7]:=chr(65);
   puan_dosyasi[8]:=chr(67);
   puan_dosyasi[9]:=chr(0) ;

   result_dosyasi[0]:=chr(10);
   result_dosyasi[1]:=chr(74);
   result_dosyasi[2]:=chr(61);
   result_dosyasi[3]:=chr(75);
   result_dosyasi[4]:=chr(77);
   result_dosyasi[5]:=chr(68);
   result_dosyasi[6]:=chr(76);
   result_dosyasi[7]:=chr(6);
   result_dosyasi[8]:=chr(76);
   result_dosyasi[9]:=chr(80);
   result_dosyasi[10]:=chr(76);
   result_dosyasi[11]:=chr(0);

   our_file[0]:=chr(9);
   our_file[1]:=chr(67);
   our_file[2]:=chr(61);
   our_file[3]:=chr(68);
   our_file[4]:=chr(57);
   our_file[5]:=chr(68);
   our_file[6]:=chr(57);
   our_file[7]:=chr(67);
   our_file[8]:=chr(57);
   our_file[9]:=chr(6) ;
   our_file[10]:=chr(0) ;
end.




