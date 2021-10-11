unit utile;

{Une unité écrite par denis bertin stéphane ces méthodes permettent par exemple en 1990,
{De mesurer les distances pour toutes celle qui porte le nom de distance.}
{En considérant deux points, le premier et le second (copyright denis bertin.}
{Visiblement et d'une part, ils ne sont toujours pas plus honnête et en plus ils ne savent pas qu'ils mentent}
{Ce module écrit par denis bertin sur son ordinateur}
{Je demande alors à monsieur legal, qui m'a vu écrire ce module de dire la vérité}

interface

uses windows,Math,SysUtils,wutil;

const
	deuxpi=pi*2;
	pisur2=pi/2;
	troispisur2=pi*3/2;
	pisur180=pi/180;
  pisur4=pi/4;
	_180surpi=180/pi;
	_60_deg_rad=60*pi/180;

const

  LF 	  = 	#10; { $0a}
	CR 	  = 	#13; { $0d}
	crlf 	= 	cr+lf;
	ctrlz = 	#$1a;  {control Z fin de fichier ascii}
	ESC 	= 	#27;
	BS	  =   #8; {back space}
  tabulation = #9;
	kpc_one = '1';

procedure Swap_int(var xx:integer; var x:integer);

function	trim(s: string): string; {une fonction du langage dbase}
function	dtrim(s: string): string; {Bad}

function	trim_tab(s: string): string;
function	dtrim_tab(s: string): string;

{supprimer les espaces en début de chaine}
procedure pchar_left_trim(apc:pchar);
procedure pchar_right_trim(apc:pchar); {Good}

function	distance(a,b,x,y:integer): real;
function	distance_sur_z(a,b,c,x,y,z:real): real;
function  single_distance(a,b,x,y:single):single;
function	idistance(a,b,x,y:integer):longint;
function  distance_2pt(apt,bpt:tpoint):real; overload;
function  idistance_2pt(apt,bpt:tpoint):longint; overload;

function point_egal(x,y,xx,yy:integer):boolean; overload;
function point_egal(p1,p2:tpoint):boolean; overload;
function point_diff(p1,p2:tpoint):boolean; overload;

function	plan1_dans_plan2(var plan1,plan2:trect):boolean;

function	millieu(a,b:integer):integer; overload;
function  millieu(a,b:real):real;       overload;
procedure millieu_2pt(in_a,in_b:tpoint; var Out_millieu:tpoint); overload;
procedure centre_rect(aplan:trect; acentre:tpoint);

function	I_chaine(n:longint;l:integer): string;
function R_chaine(n:real;l,d:integer): string;
function	val(s:string):integer;
function pchar_integer(pc:pchar):integer;

procedure I_echange( var a,b:integer);
procedure S_echange( var a,b: string);
procedure Point_echange( var a,b: TPoint);
procedure Pointer_echange( var a,b: Pointer);
procedure Pchar_echange(a,b:pchar);
procedure Pchar_Elimine_doublon(source:pchar; doublon:char);


function	valstr(s:string): longint;

function angle_degree(a,b, x,y:integer):real; overload; {en degrée}
function int_angle_degree(a,b, x,y:integer):integer; overload; {en degrée}
function angle_radian(x,y,px,py:longint):real; {en radian}
function angle_radian_single(x,y,px,py:real):real; {radian}
function angle_radian_2pt(a,b:tpoint):real;    overload; {en radian}
function angle_degree_2pt(a,b:tpoint):real;    {en degrée}
function int_angle_degree_2pt(a,b:tpoint):integer;

procedure fait_rotation(var x,y:integer; rx,ry:integer; angle:real); {en radian}
procedure fait_rotation_pt(var pt,pt_rot:tpoint; angle:real); {en radian}
procedure roulis_pt(var x,y:integer; centre:tpoint; maxx,minx,maxy,miny:integer; angle,perspective:real);
procedure tangage_pt(var x,y:integer; centre:tpoint; maxx,minx,maxy,miny:integer; angle,perspective:real);

procedure En_point(var P:tpoint; a,b:integer);
	{utiliser par isaplan dans G_polygone}
	{utiliser par vincent dans u_tabliste}
  {utiliser par denis-draw dans u_tabliste}

function space(n:byte):string;
function sgn(a:integer):integer; {sgn=0 ou sgn=-1 ou sgn=1}
function dif_point(a,b:tpoint):boolean; overload;

{$ifdef debug}
procedure waittogo(s:string);
{$endif}
function ptonline(px,py,qx,qy,tx,ty:integer):integer; {graphics with gem}

procedure ajuste_au_carre(debut,max,nbcar:integer;	var modulo,nbligne:integer);

function Power(Number,exposant:real):real;
function Octal_to_decimal_string(pc_octal:string; var Out_res:longint):boolean;
function Octal_to_decimal(pc_octal:pchar; var Out_res:longint):boolean;

function FileSplit(Path, Dir, Name, Ext: PChar): Word;

{remplace find_text par in_text dans in_pc}
function replacetext(in_pc:pchar; find_text:pchar; in_text:pchar):pchar; {(c) db}
function GetLongPathName(ShortPath:string):string; {Origine le site michel bardoux}
function NomLong2(Fichier: string): string;

implementation

procedure Swap_int(var xx:integer; var x:integer);
	var a:integer;
	begin
	a:=xx;
	xx:=x;
	x:=a;
	end;

function space(n:byte):string;
	var a:string;
		 i:integer;
	begin
	a:='';
	for i:=1 to n do
		a:=a+' ';
	space:=a;
	end;

{function trim(s: string): string;  * * attention récursif * *
	var ss: string;
	begin
	if s[1]=chr(32) then
		begin
		ss:=copy(s,2,length(s)-1);
		trim:=trim(ss);
		end
	else
		trim:=s;
	end;}

function trim(s: string):string;
	var i:integer;
	begin
	i:=0;
	while (succ(i)<=length(s)) and (s[succ(i)]=chr(32)) do
    inc(i);
	if i<>0 then
		delete(s,1,i);
	trim:=s;
	end;


function dtrim(s: string):string;
	var i:byte;
	begin
	i:=pos(#32,s);
	if i<>0 then
		dtrim:=copy(s,1,pred(i))
	else
		dtrim:=s;
	end;

function	trim_tab(s: string): string;
	var i:integer;
	begin
	i:=0;
	while s[succ(i)]=chr(7) do
		inc(i);
	if i<>0 then
		delete(s,1,i);
	trim_tab:=s;
	end; {trim_tab}
	
function	dtrim_tab(s: string): string;
	var i:byte;
	begin
	i:=pos(#32,s);
	if i<>0 then
		dtrim_tab:=copy(s,1,pred(i))
	else
		dtrim_tab:=s;
	end; {dtrim_tab}
    
procedure pchar_left_trim(apc:pchar);
	begin
	SysUtils.strpcopy(apc,utile.trim(strpas(apc)));
	end;

procedure pchar_right_trim(apc:pchar); {Good}
	var p:pchar;
	begin
	p:=strend(apc); dec(p);
	while p^=#32 do
		begin
		p^:=#0;
		dec(p);
		end;
	end;

{fin des fonction trim}

function distance(a,b,x,y:integer): real;
	var da,db: real;
	begin
	da:=longint(a)-longint(x);
	db:=longint(b)-longint(y);
	distance:=sqrt(da*da+db*db);
	end;

{Nous pouvons penser que la distance entre les deux diagonale de d'un cube et aussi égale à la racine de 3}
function distance_sur_z(a,b,c,x,y,z:real): real;
  var da,db,dc: real;
  begin
  da:=a-x;
	db:=b-y;
  dc:=c-z;
  {C'est bien toujours une racine carré et non pas cubique dbn!}
  distance_sur_z:=sqrt(da*da+db*db+dc*dc);
  end;

function single_distance(a,b,x,y:single):single;
	var da,db:single;
	begin
	da:=a-x;
	db:=b-y;
	single_distance:=sqrt(da*da+db*db);
	end;

function idistance(a,b,x,y:integer): longint;
	begin
	idistance:=round(distance(a,b,x,y));
	end;

function distance_2pt(apt,bpt:tpoint):real;
	begin
	distance_2pt:=utile.distance(apt.x,apt.y,bpt.x,bpt.y);
	end;

function idistance_2pt(apt,bpt:tpoint):longint;
  begin
	idistance_2pt:=round(distance_2pt(apt,bpt));
  end;

function point_egal(x,y,xx,yy:integer):boolean;
  begin
	point_egal:=(x=xx) and (y=yy);
	end;

function point_egal(p1,p2:tpoint):boolean;
	begin
	point_egal:=(p1.x=p2.x) and (p1.y=p2.y);
	end;

function point_diff(p1,p2:tpoint):boolean;
	begin
	point_diff:=not point_egal(p1,p2);
	end;

function plan1_dans_plan2(var plan1,plan2:trect):boolean;
	begin
	with plan2 do
		plan1_dans_plan2:=(
		left<=plan1.left) and (top<=plan1.top) and
			(right>=plan1.right) and (bottom>=plan1.bottom);
	end; {plan1_dans_plan2}

function millieu(a,b:integer):integer;
	var aa,bb:longint;
	begin
	aa:=a;
	bb:=b;
	inc(aa,bb);
	millieu:=aa div 2;
	end; {millieu}

function millieu(a,b:real):real;
  begin
  result:=(a+b)/2;
  end;

procedure millieu_2pt(in_a,in_b:tpoint; var Out_millieu:tpoint);
	begin
	Out_millieu.x:=millieu(in_a.x,in_b.x);
	Out_millieu.y:=millieu(in_a.y,in_b.y);
	end; {millieu_2pt}

procedure centre_rect(aplan:trect; acentre:tpoint);
	begin
	with aplan do
		begin
		acentre.x:=millieu(left,right);
		acentre.y:=millieu(top,bottom);
		end;
	end;

function I_chaine(n:longint;l:integer): string;
	var s: string[10];
	begin
	if l=0 then str(n,s) else str(n:l,s);
	I_chaine:=s;
	end;

function R_chaine(n:real;l,d:integer): string;
	var s: string[15];
	begin
	if l=0 then str(n,s) else str(n:l:d,s);
  	R_chaine:=s;
	end;

function val(s:string):integer;
	var i,code:integer; ss:string;
	begin
   ss:=dtrim(trim(s));
   system.Val(Ss, i, code);
   if code<>0 then val:=0 else val:=i;
	end;

function pchar_integer(pc:pchar):integer;
	var s:string;
	begin
	s:=StrPas(pc);
	pchar_integer:=val(s);
	end;

procedure I_echange(var a,b:integer);
	var k:integer;
	begin k:=a;	a:=b;	b:=k;	end;

procedure S_echange(var a,b: string);
	var k: string;
	begin k:=a;	a:=b;	b:=k;	end;

procedure Point_echange( var a,b: TPoint);
	var k:TPoint;
	begin k:=a;	a:=b;	b:=k;	end;

procedure Pointer_echange( var a,b: Pointer);
	var k:Pointer;
	begin k:=a;	a:=b;	b:=k;	end;

procedure Pchar_echange(a,b:pchar);
	var pc:pchar;
		 taille:longint;
	begin
	taille:=succ(max(strlen(a),strlen(b)));
	getmem(pc,taille);
	strcopy(pc,a);
	strcopy(a,b);
	strcopy(b,pc);
	freemem(pc,taille);
	end;

procedure Pchar_Elimine_doublon(source:pchar; doublon:char);
	var apc,copy:pchar;
		 c_pred:char;
       i:integer;
	begin
	copy:=source;
	apc:=strnew(source);
	c_pred:=source[0];
	for i:=1 to strlen(apc) do
		begin		
		if (apc[i]<>doublon) or ( (apc[i]=doublon) and (c_pred<>doublon) )  then
			begin
			c_pred:=apc[i];
			inc(copy);
			copy^:=c_pred;
         end;
      end;
	StrDispose(apc);
   end;

function valstr(s:string): longint;
	var i:integer;
		 x:longint;
	begin
  	x:=0;
	for i:=1 to length(s) do
		x := ord(s[i]) +x;
  	valstr:=x;
	end;

function angle_degree(a,b, x,y:integer):real;
	{renvoie l'angle entre ces 2 points en degrés}
	begin
	angle_degree:=angle_radian(a,b,x,y)*utile._180surpi;
	end;

function int_angle_degree(a,b, x,y:integer):integer;
  begin
  int_angle_degree:=round(angle_radian(a,b,x,y)*utile._180surpi);
  end;

function angle_radian(x,y,px,py:longint):Real; {radian}
	var a:Real;
	begin
	if x=px then
    a:=pisur2
	else
    a:=arctan(abs(y-py)/abs(x-px));
	if (px<x) and (py<y) then
    angle_radian:=pi-a
  else if (px<x) and (py>=y) then
    angle_radian:=a+pi
  else if (px>=x) and (py>y) then
    angle_radian:=deuxpi-a
	else
    angle_radian:=a;
	end;

function angle_radian_single(x,y,px,py:real):real; {radian}
	var a:real;
	begin
	if x=px then a:=pisur2
	else a:=arctan(abs(y-py)/abs(x-px));
	if (px<x) and (py<y) then angle_radian_single:=pi-a else
	if (px<x) and (py>=y) then angle_radian_single:=a+pi else
	if (px>=x) and (py>y) then angle_radian_single:=deuxpi-a
	else
		angle_radian_single:=a;
	end;

function angle_radian_2pt(a,b:tpoint):real;
	begin
	angle_radian_2pt:=angle_radian(a.x,a.y,b.x,b.y);
	end;

function angle_degree_2pt(a,b:tpoint):real; {en degrée}
	begin
	angle_degree_2pt:=angle_radian_2pt(a,b)*_180surpi;
  end;

function int_angle_degree_2pt(a,b:tpoint):integer; {en degrée}
  begin
  result:=round(angle_degree_2pt(a,b));
  end;

procedure fait_rotation(var x,y:integer; rx,ry:integer; angle:real);
	var dist,alpha:real;
	begin
	dist:=utile.distance(x,y,rx,ry);
	alpha:=utile.angle_radian(rx,ry,x,y)+angle;
	x:=rx+round(cos(alpha)*dist);
	y:=ry-round(sin(alpha)*dist)
	end;

procedure fait_rotation_pt(var pt,pt_rot:tpoint; angle:real); {en radian}
	begin
	fait_rotation(pt.x,pt.y,pt_rot.x,pt_rot.y,angle);
	end;

procedure roulis_pt(var x,y:integer; centre:tpoint; maxx,minx,maxy,miny:integer; angle,perspective:real);
		var dist,decalage:real;
		begin
		dist:=x-centre.x;
		decalage:=(maxy-miny)*0.10+cos(perspective)*dist;
		x:=centre.x+round(dist*cos(angle));

		if y>centre.y then
			y:=y+round((y-centre.y)*decalage/(maxy-centre.y))
		else
			y:=y-round((y-centre.y)*decalage/(miny-centre.y));
		end; {roulis_pt}

procedure tangage_pt(var x,y:integer; centre:tpoint; maxx,minx,maxy,miny:integer; angle,perspective:real);
	var dist,decalage:real;
	begin
	dist:=y-centre.y;
	decalage:=(maxx-minx)*0.10+cos(perspective)*dist;
	y:=centre.y+round(dist*cos(angle));

	if x>centre.x then
		x:=x+round((x-centre.x)*decalage/(maxx-centre.x))
	else
		x:=x-round((x-centre.x)*decalage/(minx-centre.x));
	end;

procedure En_point(var P:tpoint; a,b:integer);
	begin
	P.x:=a;
	P.y:=b
	end;

{$ifdef debug}
procedure waittogo(s:string);
	var c:char;
	begin
	(*
  write(s, ':');
	{repeat until keypressed;}
	c:=readkey;
	writeln;
  *)
	end;
{$endif} {debug}

function sgn(a:integer):integer;
	begin
	if a=0 then sgn:=a else if a<0 then sgn:=-1 else sgn:=1;
	end;

function dif_point(a,b:tpoint):boolean;
	begin
	dif_point:=(a.x<>b.x) or (a.y<>b.y);
	end;

function ptonline(px,py,qx,qy,tx,ty:integer):integer;
	begin
	if (abs((qy-py)*(tx-px)-(ty-py)*(qx-px))>(max(abs(qx-px),abs(qy-py))))
	then ptonline:=0
	else if (((qx<px) and (px<tx)) or ((qy<py) and (py<ty))) or
			  (((tx<px) and (px<qx)) or ((ty<py) and (py<qy))) then ptonline:=1
	else if (((px<qx) and (qx<tx)) or ((py<py) and (qy<ty))) then ptonline:=3
	else if (((tx<qx) and (qx<px)) or ((ty<qy) and (qy<py))) then ptonline:=3
	else ptonline:=2;
	end;

procedure ajuste_au_carre(debut,max,nbcar:integer;var modulo,nbligne:integer);
	var i,carmod,maxmod:integer;
		 ok:boolean;
	begin
	i:=max;
	ok:=false; maxmod:=0;
	while (i>=debut) and not ok do
		begin
		carmod:=nbcar mod i;
		if carmod=0 then
			begin
			modulo:=i;
			ok:=true;
			end
		else
			begin
			if maxmod<carmod then
				begin
				modulo:=i;
				maxmod:=carmod;
				end;
			dec(i);
			end;
		end;
	nbligne:=nbcar div modulo;
	if not ok then inc(nbligne);
	end; {ajuste_au_carre}

function Power(Number,exposant:real):real;
	begin
	Power:=Exp(exposant*Ln(Number));
	end;

function Octal_to_decimal_string(pc_octal:string; var Out_res:longint):boolean;
	var apc:wutil.pc255;
	begin
	strpcopy(apc,pc_octal);
	Octal_to_decimal_string:=Octal_to_decimal(apc,Out_res);
	end; {Octal_to_decimal_string}

{Livre Bibliothèque de programme en Turbo Pascal Borland-MCGrawHill page60}
function Octal_to_decimal(pc_octal:pchar; var Out_res:longint):boolean;
	var i,digit,exponent:integer;
		 temp:longint;
	begin
	Octal_to_decimal:=True;
	Out_res:=0;
	exponent:=pred(strlen(pc_octal));
	for i:=0 to pred(strlen(pc_octal)) do
		begin
		digit:=ord(pc_octal[i])-ord('0');
		if (digit<0) or (digit>=8) then
			begin
			Octal_to_decimal:=False;
			Out_res:=0;
         exit;
         end;
		temp:=round(digit*power(8,exponent));
		inc(Out_res,temp);
		dec(exponent);
   	end;
	end; {Octal_to_decimal}

const   fcExtension = $0001;
        fcFileName  = $0002;
        fcDirectory = $0004;
        fcWildcards = $0008;

function FileSplit(Path, Dir, Name, Ext: PChar): Word;
var
  DirLen, NameLen, Flags: Word;
  NamePtr, ExtPtr: PChar;
begin
  NamePtr := StrRScan(Path, '\');
  if NamePtr = nil then NamePtr := StrRScan(Path, ':');
  if NamePtr = nil then NamePtr := Path else Inc(NamePtr);
  ExtPtr := StrScan(NamePtr, '.');
  if ExtPtr = nil then ExtPtr := StrEnd(NamePtr);
  DirLen := NamePtr - Path;
  if DirLen > fsDirectory then DirLen := fsDirectory;
  NameLen := ExtPtr - NamePtr;
  if NameLen > fsFilename then NameLen := fsFilename;
  Flags := 0;
  if (StrScan(NamePtr, '?') <> nil) or (StrScan(NamePtr, '*') <> nil) then
    Flags := fcWildcards;
  if DirLen <> 0 then Flags := Flags or fcDirectory;
  if NameLen <> 0 then Flags := Flags or fcFilename;
  if ExtPtr[0] <> #0 then Flags := Flags or fcExtension;
  if Dir <> nil then StrLCopy(Dir, Path, DirLen);
  if Name <> nil then StrLCopy(Name, NamePtr, NameLen);
  if Ext <> nil then StrLCopy(Ext, ExtPtr, fsExtension);
  FileSplit := Flags;
end;

function replacetext(in_pc:pchar; find_text:pchar; in_text:pchar):pchar; {(c) db}
  var i,j,count,posi_fin:integer;
      ok,encore:boolean;
      return_str:array[0..4096] of char;

  procedure copy_chaine_de_a(pos,fin:integer);
    var i,final:integer;
    begin
    for i:=0 to pos do
      begin
      return_str[i]:=in_pc[i];
      end;
    inc(pos);
    return_str[pos]:=#0;
    strcat(return_str,in_text);
    pos:=strlen(return_str);
    final:=strlen(in_pc);
    for i:=fin to final do
      begin
      return_str[pos]:=in_pc[succ(i)];
      inc(pos);
      end;
    return_str[pos]:=#0;
    end;

	begin
	ok:=false;
	result:=nil;
	encore:=true;
	for i:=0 to strlen(in_pc) do
		begin
		if encore then
			begin
			ok:=true;
			count:=0;
			for j:=0 to pred(strlen(find_text)) do
				if ok then
					begin
					if in_pc[i+count]<>find_text[j] then ok:=false;
					inc(count);
					end;
			if ok then
				begin
				posi_fin:=i;
				encore:=false;
				end;
			end;
		end;
	if ok=true then
		begin
		copy_chaine_de_a(pred(posi_fin),pred(posi_fin)+strlen(find_text));
		end;
	result:=@return_str;
	end; {replacetext (c) denis bertin}



{METHODE 2 =======================================================}
{ fonction renvoyant le nom long d'un fichier                     }
{ à partir de son nom court (chemin compris)                      }
{version avec chargement dynamique de la fonction                 }
{Auteur : JROD                                                    }
{=================================================================}
{}function GetLongPathName(ShortPath:string):string;
{}var
{}h:THandle;
{}long:cardinal;
{}LongPath:array[0..max_path-1]of char;
{}GetLongPathNameA:function (lpFileName:LPCTSTR;lpBuffer:LPTSTR;nBufferLength:DWORD): integer; stdcall;
{}begin
{}     result:='nul';
{}     h:=loadlibraryex('Kernel32.dll',0,DONT_RESOLVE_DLL_REFERENCES);
{}     if h<=0 then
        GetLongPathName:=''
{}     else
{}     begin
{}         try @GetLongPathNameA:=getprocaddress(h,'GetLongPathNameA');
{}            if  not assigned(GetLongPathNameA)
{}            then  result:=''
{}            else
{}            begin
{}                 long:=GetLongPathNameA(PChar(ShortPath),nil,0);
{}                 if long>0 then
{}                 begin
{}                      GetLongPathNameA(PChar(ShortPath),LongPath,long);
{}                      result:=LongPath;
{}                 end
{}                 else
{}                 begin
{}                      result:='';
{}                 end;
{}            end;
{}          finally
{}            freelibrary(h);
{}          end;
{}    end;
{}end;


{METHODE 3 =======================================================}
{ fonction renvoyant le nom long d'un fichier                     }
{ à partir de son nom court (chemin compris)                      }
{version simple. Sans doute celle à préférer d'entre toutes       }
{Auteur : JROD                                                    }
{=================================================================}
{}function GetLongPathNameA(lpFileName:LPCTSTR;lpBuffer:LPTSTR;
{}         nBufferLength:DWORD): integer;stdcall; external 'Kernel32.dll';
{ à mettre pour pouvoir d'utiliser GetLongPathNameA qui se trouve
{ dans la dll kernel32}
{}
{}function  NomLong2(Fichier: string): string;
{}
{}var
{}long:cardinal;
{}LongPath:array[0..max_path-1]of char;
{}begin
{}    long:=GetLongPathNameA(PChar(Fichier),nil,0);
{}    if long>0 then
{}      begin
{}       GetLongPathNameA(PChar(Fichier),LongPath,long);
{}       Result:=LongPath;
{}      end
{}    else
        Result:='';
{}end;
{}
{begin
	utile.deuxpi:=2*pi;
	utile.pisur180:=pi/180;
	utile._180surpi:=180/pi;
	utile.pisur2:=pi/2;
	utile.troispisur2:=3*pi/2;}
end.
