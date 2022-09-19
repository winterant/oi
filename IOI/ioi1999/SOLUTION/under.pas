program underground;
uses undertpu;

const
   wall = 'W';
   opensqr = 'O';

   marker = 'c';

   possible = 'P';
   impossible = 'I';

   unknown = 'U';

   max = 99;
   max2 = 66*66;
type
   labi = array [0..max,0..max] of char;

var
   f:TEXT;
   n,m:integer;
   board,situation,candidate:labi;

   wallcount : array [0..max,0..max]of integer;

   x,y:integer;

   flag:boolean;

   questionx,questiony:integer;
   questionch:char;
   answer:char;

   path:array [1..max2] of char;

   candidate_number:integer;


procedure read_data;
var
   i,j:integer;
begin
   candidate_number:=0;
   assign(f,'under.inp');
   reset(f);
   readln(f,m,n);
   for i:=0 to n-1 do
  begin
   for j:=0 to m-1 do
   begin
      read(f,board[i,j]);
      if (board[i,j]=opensqr) then begin candidate[i,j]:=possible;inc(candidate_number);end
      else candidate[i,j]:=impossible;
      situation[i,j]:=unknown;
   end;
   readln(f);
  end;
   situation[0,0]:=opensqr;
   close(f);
end;
function onboard(a,b,i,j:integer):char;
begin onboard:=board[(a+i) mod n, (b+j) mod m];end;

function up(x:integer):integer;
begin up:=(((x)+n-1) mod n);end;


function left(x:integer):integer;
begin left:=(((x)+m-1) mod m);end;

function down(x:integer):integer;
begin down:=(((x)+1) mod n);end;

function right(x:integer):integer;
begin right:=(((x)+1) mod m);end;


procedure minus_one_to_wallcount;
var
   i,j:integer;
begin
   for i:=0 to n-1 do
   for j:=0 to m-1 do
      wallcount[i,j]:=-1;
end;
procedure count_walls(a,b:integer);
var
   i,j:integer;
begin
   flag:=true;

   wallcount[a,b]:=0;
   for i:=0 to n-1 do
   for j:=0 to m-1 do
   if (candidate[i,j]=possible) and (onboard(i,j,a,b)=wall) then
      wallcount[a,b]:=wallcount[a,b]+1;
end;

procedure find_question_place(a,b:byte);
begin
   if(situation[a,b]=unknown) then
      begin
         count_walls(a,b);
         if(wallcount[a,b]=0)then begin situation[a,b]:=opensqr;wallcount[a,b]:=-1;end
         else if(wallcount[a,b]=candidate_number) then begin situation[a,b]:=wall;wallcount[a,b]:=-1;end;
      end;

   if(situation[a,b]=opensqr) then
   begin
      situation[a,b]:=marker;
      find_question_place(a,right(b));
      find_question_place(a,left(b));
      find_question_place(up(a),b);
      find_question_place(down(a),b);
   end;
end;
procedure clean_markers;
var
   i,j:integer;
begin
   for i:=0 to n-1 do
   for j:=0 to m-1 do
      if(situation[i,j]=marker) then situation[i,j]:=opensqr;
end;

function where_to_ask:boolean;
var
   i,j:integer;
   su_anki_oran : integer;
begin
   flag:=false;
   su_anki_oran:=candidate_number;
   minus_one_to_wallcount;

   find_question_place(0,0);

   clean_markers;
   if(flag) then
   begin
     for i:=0 to n-1 do
       for j:=0 to m-1 do
         if(wallcount[i,j] > -1) then
         begin
            if (abs(wallcount[i,j]-candidate_number div 2)<su_anki_oran) then
               begin
                  su_anki_oran:=abs(wallcount[i,j]-candidate_number div 2);
                  questionx:=i;
                  questiony:=j;
               end;
         end;






   if (situation[questionx,right(questiony)]=opensqr) then
   begin
      questiony:=right(questiony);
      questionch:='W';
   end
   else if (situation[questionx,left(questiony)]=opensqr) then
        begin
          questiony:=left(questiony);
          questionch:='E';
        end
        else if (situation[up(questionx),questiony]=opensqr) then
             begin
                questionx:=up(questionx);
                questionch:='S';
             end
             else if (situation[down(questionx),questiony]=opensqr) then
                  begin
                     questionx:=down(questionx);
                     questionch:='N';
                  end;

   end;
   where_to_ask:=flag;
end;

procedure ask_the_question;
var
   I_found_the_path:boolean;
   top:integer;

   procedure find_the_path(a,b:byte;adim:integer);
   begin
      if(situation[a,b]=opensqr) then
      begin
      situation[a,b]:=marker;

      if (a=questionx) and (b=questiony) then begin I_found_the_path:=true;top:=adim-1;end
        else begin
if (adim>max2) then begin writeln('Kafayi mi yedin? max2''yi gectin');halt;end;
           path[adim]:='E';find_the_path(a,right(b),adim+1);
           if(not I_found_the_path) then begin path[adim]:='W';find_the_path(a,left(b),adim+1);end;
           if(not I_found_the_path) then begin path[adim]:='N';find_the_path(up(a),b,adim+1);end;
           if(not I_found_the_path) then begin path[adim]:='S';find_the_path(down(a),b,adim+1);end;
        end;
      end;
   end;
   procedure move_to;
   var
      i:integer;
   begin
      for i:=1 to top do
         move(path[i]);
      x:=questionx;
      y:=questiony;
   end;
begin
   I_found_the_path:=false;
   find_the_path(x,y,1);
   clean_markers;

   move_to;
   answer:=look(questionch);
end;


procedure decrease_candidates;
var
 i,j:integer;
begin
   case questionch of
      'E':questiony:=right(questiony);
      'W':questiony:=left(questiony);
      'N':questionx:=up(questionx);
      'S':questionx:=down(questionx);
   end;

   situation[questionx,questiony]:=answer;

   for i:=0 to n-1 do
      for j:=0 to m-1 do if (candidate[i,j]=possible) then
      if (board[(i+questionx) mod n,(j+questiony) mod m]<>answer) then
         begin
            candidate[i,j]:=impossible;
            dec(candidate_number);
         end;

end;

procedure write_the_answer;
var
   i,j:integer;
begin
   for i:=0 to n-1 do
   for j:=0 to m-1 do
      if candidate[i,j]=possible then
      begin
         writeln('answer: ','(',j+1,',',n-i,')');
         finish(j+1,n-i);
      end;
end;

begin
   start;

   read_data;
   while((candidate_number>1) and where_to_ask) do
   begin
      ask_the_question;
      decrease_candidates;
   end;
   if(candidate_number>1) then writeln('Attention !... More than one solution')
   else if (candidate_number=0) then writeln('Attention !... No answer');
   write_the_answer;
end.

