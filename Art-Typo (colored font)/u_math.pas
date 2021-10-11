unit u_math;

interface

const    deuxpi=pi*2;
			pisur2=pi/2;
			_180surpi=180/pi;

function distance(a,b,x,y:integer):real;
function angle_radian(x,y,px,py:longint):Real; {radian}
function angle_degree(a,b, x,y:integer):real;

implementation

function distance(a,b,x,y:integer):real;
	var da,db:integer;
	begin
   da:=a-x;
	db:=b-y;
	result:=sqrt(da*da+db*db);
   end;

function angle_radian(x,y,px,py:longint):Real; {radian}
	var a:Real;
	begin
	if x=px then a:=pisur2
	else a:=arctan(abs(y-py)/abs(x-px));
	if (px<x) and (py<y) then angle_radian:=pi-a else
	if (px<x) and (py>=y) then angle_radian:=a+pi else
	if (px>=x) and (py>y) then angle_radian:=deuxpi-a
	else angle_radian:=a;
	end;

function angle_degree(a,b, x,y:integer):real;
	{renvoie l'angle entre ces 2 points en degrés}
	begin
	angle_degree:=angle_radian(a,b,x,y)*_180surpi;
	end;



end.
