unit wutil; {Une unité écrite par denis bertin stéphane en 1989 (c) Bertin denis logiciels celui d'isagri ainsi que ce logiciel}
            {On vous l'a dit vous nous mentez et votre médi aussi, régis vous mentait aussi, le faisait croire comme les bruns}

{Ecrit par denis bertin en 1992 et non pas par régis ni nicolas ni ton maître}
{Ajout par Denis Bertin des soft-rectangle (c) Beelog par denis bertin stéphane}
{Ajout par Denis Bertin des soft-cercle (c) Beelog par denis bertin stéphane}
{D'une unité que denis bertin à écrit pour ceoncevoir son logiciel }
{Ecrit grimaut faisait un applicatif sous dos en C de modélisation 3d qu'il n'a jammais réussi à finaliser.}
{Puis s'est mis à produire une applet d'édition de page web dans une page web en javascript}

interface

uses Messages,Windows,SysUtils;      

const fspathname = 1024;
      fsDirectory = 1024;
      fsFileName = 1024;
      fsExtension = 1024;
      vincent='Denis-draw';
      PS_DOUBLE = 6; // équal to style pipeline

type

namestr=array[0..fspathname] of char;

PScrollBarTransferRec = ^ScrollBarTransferRec;
ScrollBarTransferRec = record
	LowValue: Integer;
	HighValue: Integer;
	Position: Integer;
	end;

p_dda_data = ^tdda_data;
tdda_data = record
	adc:hdc;
	counter_dda:word;
	modulo,rayon:integer;
	end;

const
	lpc10=10;
	lpc20=20;
  lpc32=32;
  lpc50=50;
	lpc100=100;
	lpc255=255;
  lpc1024=1024;
  lpc4096=4096;

  Pc_carriage_return: pchar = #13;
  Pc_CrLf: 			      pchar = #13+#10+#0;
	Pc_tabul:			      pchar=chr(9);
	kpc_zero:			      pchar='0';
	PC_Anti_slash:	    pchar='\';
	pc_zero_ext:		    pchar='°';
	pc_etoile_etoile:	  pchar='*.*';
  kpc_etoile:			pchar='*';
  kpc_plus:			  pchar='+';
	kpc_slash:			pchar='/';
	kpc_empty:			pchar='';
	kpc_minus:			pchar='-';
	kpc_space:			pchar=#32+#0;
	kpc_ampersand:	pchar='&';
	kpc_degree:			pchar='°';
	kpc_pourcent:		pchar='%';
	kpc_pour_mille:	pchar='°/..';
	kpc_colon:			pchar=':';
	kpc_interro:		pchar='?';
	kpc_comma:			pchar=',';
	kpc_quote:			pchar='"';
	kpc_simple_quote:	pchar='''';
  kpc_double_quote:	pchar='"';
	kpc_z_car:			pchar='z';
	kpc_equal:			pchar='=';
	kpc_tild:			  pchar='~';
	kpc_dot:				pchar='.';
	kpc_dot_comma:	pchar=';';
	kpc_underscore:	pchar='_';
	kpc_diese:			pchar='#';
  kpc_grade:      pchar='gr';
  kpc_backspace:  pchar=chr(8);
  kpc_pluriel:    pchar='s';
  kpc_dollard:    pchar='$';

	kpc_open_curly=	'{';
	kpc_end_curly=	'}';
	kpc_lessthan=		'<';
	kpc_morethan=		'>';
  kpc_open_braket='[';
  kpc_close_braket=']';

	kpc_font_arial =	'arial';
  kpc_font_calibri = 'calibri';

type

	pc10  = array[0..lpc10] of char;
	pc20  = array[0..lpc20] of char;
  pc32  = array[0..lpc32] of char;
  pc50  = array[0..lpc50] of char;
	pc100 = array[0..lpc100] of char;
	pc255 = array[0..lpc255] of char;
  pc1024 = array[0..lpc1024] of char;
  pc4096 = array[0..lpc4096] of char;

var version31:boolean;
	 sDecimal:pc10;
	 sThousand:pc10;

function xy_in_rect(arect:trect; x,y:integer):boolean;
procedure MoveTo(DC: HDC; X, Y: Integer);
procedure Cercleto(DC: HDC; X, Y, R: Integer);
procedure call_back_linedda(x,y:integer; data:p_dda_data); export;

function char_oemtoansi(acar:char):char;
function char_ansitooem(acar:char):char;

//remplacer par les fonctions dans math
//function min(a,b:integer):integer; inline(
//  $58/             { pop   ax     }
//  $5b/             { pop   bx     }
//  $3b/$c3/         { cmp   ax,bx  }
//  $7c/$01/         { jl    +1     }
//  $93);            { xchg  ax,bx  }

//remplacer par les fonctions dans math
//function max(a,b:integer):integer; inline(
//  $58/             { pop   ax     }
//  $5b/             { pop   bx     }
//  $3b/$c3/         { cmp   ax,bx  }
//  $7f/$01/         { jg    +1     }
//  $93);            { xchg  ax,bx  }

function Real_min(a,b:Real):Real;
function Real_max(a,b:Real):Real;

{ Convertion nombre à texte }
function  IntToStr(I: Longint): String;
procedure Inttopchar(i:longint;apchar:pchar);
function	Longint_char(i:longint):pchar;
function  PChartolongint(apc:pchar):longint;
function  Is_Pchar_numerique(apc:pchar):Boolean;
function  Is_Pchar_hexadecimal(apc:pchar):Boolean;

procedure remplace_pt_window_pt_decimal(apc:pchar); overload; {1,00 -> 1.00}
procedure remplace_pt_window_pt_decimal(var str:string); overload; {1,00 -> 1.00}
procedure pchar_to_real(apc:pchar; var areal:real);
procedure remplace_pt_decimale_pt_window(apc:pchar);  {1.00 -> 1,00}
procedure remplace_virgule_par_un_point(apc:pchar);  {1,00 -> 1.00}
procedure real_to_pchar(areal:real; apc:pchar);
procedure real_to_pchar_format(areal:extended; apc:pchar; nb_chiffre,nb_decimal : integer);
function  remplace_this_carac(in_string:pchar; carac:char; by_another:char) : pchar;

procedure caller_text_a_gauche(apchar:pchar; nb:integer; car:char);
{nb=taille de la chaine  ex: ('0',5,'x') -> 'xxxx0' }

function rectinrect(var arect,brect:trect):boolean;
{ arect : rectangle le plus grand, doit contenir l'autre }

function  comparer_ext(filename,extension:pchar):boolean; {.???}
procedure verifier_ext(filename,extension:pchar); {.PAS}
{function	 file_name(filename:pchar):pchar; #not used for the moment}
function  file_size(filename:pchar):longint;
function  is_a_directory(filename:pchar):boolean;
function  file_existe(filename:pchar):boolean;
procedure file_erase(filename:pchar); {now ok sans reour erreur}
procedure file_rename(filename,remplacer:pchar);
{procedure dir_erase(adir_name:pchar); #not used for the moment}
procedure Verif_et_creer_repertoire(apc_dir:pchar);
function  compter_le_nb_anti_slash(apc:pchar):integer;
function  file_Copy(entre,sortie:string):boolean;

{output pc and get_start_directory = starting directory}
function get_start_directory(pc:pchar):pchar;

function  Hexbyte(b:byte):string;
procedure Hexbyte_pchar(b:byte; pc:pchar);
function  HexWord(w: Word):string;
function  Hexlongint_24bits(color:tcolorref):string;
function	Hexlongint(long: longint):string;
function  Hexvalue(hex:string):longint;

Procedure move_null(hw:hwnd);
function  clip_board_is_mine(hwin:hwnd):boolean;
procedure bip;
procedure box(hwindow:hwnd;un_message:pchar);
procedure loadandshow(adc:hdc; bm:hbitmap);
procedure loadandshowposition(adc:hdc; bm:hbitmap; x,y:integer);
procedure put_and_draw(adc:hdc; bm:hbitmap; position_x,position_y:integer; double:boolean);
procedure loadandstretch(adc:hdc; bm:hbitmap; deltax,deltay,width,height:integer);
procedure showbitmapposit(adc:hdc; bm:hbitmap; x,y:integer);
procedure init_version;

{il en reste count}
procedure supprimer_item_menu_en_trop(amenu:hmenu;count:integer);

procedure add_car_pos(apc:pchar;pos:word;c:char);

procedure cross_a_rect(adc:hdc;arect:trect);
procedure cross_a_window(hwindow:hwnd;adc:hdc);   

procedure center_window(hwindow:hwnd);
procedure center_window_horizontal(hwindow:hwnd);

procedure init_internationnale;

function get_exe_path(path_exe:pchar):pchar;

function IS_Mode_256_Color:boolean;
function IS_Mode_Big_Font:boolean;
function Demande_largeur_ecran:integer;
function Demande_hauteur_ecran:integer;

procedure MakeDefaultFont(var alogfont:tlogFont; asize:integer); {une arial taille parametrable}
procedure MakeDefaultCalibri(var alogfont:tlogFont; asize:integer);

Function Get_MakeDefaultFont(asize:integer):Hfont;
Function Get_MakeDefaultCalibri(asize:integer):Hfont;

procedure Draw_mini_raindow_circle(paintdc:hdc; center:tpoint; rayon:integer);

function StrCat_espace(apc:pchar):pchar;
function StrCat_point(apc:pchar):pchar;
function StrCat_point_espace(apc:pchar):pchar;
{Function IsCDROMDrive(wDrive:Word):boolean; #not used for the moment}
{Function Get_Letter_of_first_CDROMDrive(apc:pchar):pchar; {ex d:\ #not used for the moment}

function Power(a:real;b:integer):real;

function  Get_dir_appli(apc:pchar):pchar; {=nil si erreur}

function suppr_quote_string(dans:string):string;
function suppr_quote_pchar(dans:pchar):pchar;

function maxavail:integer;

function get_file_size(filename:string):longint;

procedure Cursor_Bouge_DE_Rien;
function  Supprimer_car_underscore(adc:hdc; chaine:pchar; taille:word; var width:word):integer;
procedure Tranche_de_camenbert_par_teinte(dc:hdc; x,y,xx,yy:integer; angle_depart,angle_arriver:real);
procedure Soft_circle(paintdc:hdc; x,y,r:integer);
procedure Soft_rectangle(paintdc:hdc; x,y,xx,yy:integer; couleur:tcolorref);
procedure Soft_rectangle_rectangulaire(paintdc:hdc; Rect:trect; couleur:tcolorref);
procedure Soft_interro(adc:hdc; var un_rectangle:trect);
procedure Draw_Random_Rect(paintdc:hdc; Rect_bouton_palette_fine:trect);
procedure Draw_Rainbow_Rect(paintdc:hdc; Rect_bouton_palette_fine:trect);
procedure Add_Dot_delimitor_each_tree_car(in_pc,out_pc:pchar);
procedure Draw_a_grid_in_this_window(awindow:hwnd; paintdc:hdc; quelle_couleur:tcolorref);
Function Is_drive_removable(lettre:char):boolean;

implementation

uses hls_rvb,utile,math,Forms;

function xy_in_rect(arect:trect; x,y:integer):boolean;
  var apoint:tpoint;
  begin
  apoint.x:=x;
  apoint.y:=y;
  xy_in_rect:=Ptinrect(arect,apoint);
  end;

procedure MoveTo(DC: HDC; X, Y: Integer);
  var apt:tpoint;
      pt:PPoint;
  begin
  pt:=@apt;
  Windows.MoveToEx(DC,X,Y,pt);
  end;

procedure Cercleto(DC: HDC; X, Y, R: Integer);
  begin
  Windows.Ellipse(DC,X-R,Y-R,X+R,Y+R);
  end;

procedure call_back_linedda(x,y:integer; data:p_dda_data);
begin
	with data^ do begin
		if counter_dda=0 then begin			
			ellipse(adc,x-rayon,y-rayon,x+rayon,y+rayon);
      end;
		inc(counter_dda);		
		counter_dda:=counter_dda mod modulo;
	end;
end;

function char_oemtoansi(acar:char):char;
const	s1 : pchar = #0#0#0;
begin
	s1[0]:=acar;
	oemtoansi(s1,s1);
	char_oemtoansi:=s1[0];
end;

function char_ansitooem(acar:char):char;
const	s1 : pchar = #0#0#0;
begin
	s1[0]:=acar;
	ansitooem(s1,s1);
	char_ansitooem:=s1[0];
end;

{function min(a,b:integer):integer;
	begin if a<b then	min:=a else min:=b; end;

function max(a,b:integer):integer;
	begin	if a>b then	max:=a else	max:=b; end;}

function Real_min(a,b:Real):Real;
	begin if a<b then	Real_min:=a else Real_min:=b; end;
	
function Real_max(a,b:Real):Real;
	begin	if a>b then	Real_max:=a else Real_max:=b; end;


function IntToStr(I: Longint): String;
	{ Conversion d'entier en chaîne }
	var S: string[11];
	begin
	Str(I, S);
	IntToStr := S;
	end;

procedure inttopchar(i:longint;apchar:pchar);
	var s:string;
	begin
	s:=inttostr(i);
	StrPCopy(apchar,S);
	end;

function longint_char(i:longint):pchar;
	var pc_20:array[0..20] of char;
	begin
	inttopchar(i,pc_20);
	longint_char:=pc_20;
	end;

function pchartolongint(apc:pchar):longint;
	var areal:real;
	begin
	pchar_to_real(apc,areal);
	pchartolongint:=round(areal);
	end;

function Is_Pchar_numerique(apc:pchar):Boolean;
	var i:integer;
		 abool:boolean;
	begin
	if (apc=nil) or (apc[0]=#0) then
		Is_Pchar_numerique:=False
	else
		begin
		abool:=True;
		for i:=0 to pred(strlen(apc)) do
			abool:=abool and (ord(apc[i]) in [ord('0')..ord('9')]) or (apc[i]=kpc_minus[0]);
		Is_Pchar_numerique:=abool;
		end;
	end;

function Is_Pchar_hexadecimal(apc:pchar):Boolean;
  var i:integer;
		  abool:boolean;
  begin
  if (apc=nil) or (apc[0]=#0) then
		Is_Pchar_hexadecimal:=False
	else
		begin
		abool:=True;
    for i:=0 to pred(strlen(apc)) do
      abool:=abool and
        ((ord(apc[i]) in [ord('0')..ord('9')]) or (apc[i]=kpc_minus[0]) or (ord(apc[i]) in [ord('A')..ord('F')]) or (ord(apc[i]) in [ord('a')..ord('f')]));
    Is_Pchar_hexadecimal:=abool;
    end;
  end;

procedure remplace_pt_window_pt_decimal(apc:pchar); {1,00 -> 1.00}
	var pc:pchar;
	begin
	if sDecimal[0]='.' then exit;
  repeat
	  pc:=strpos(apc,sDecimal);
	  if pc<>nil then pc^:='.';
    pc:=strpos(apc,sDecimal);
  until pc=nil;
	end;

procedure remplace_pt_window_pt_decimal(var str:string);
  var apc:pc1024; {Must be enought}
  begin
  strpcopy(apc,str);
  remplace_pt_window_pt_decimal(apc);
  str:=strpas(apc);
  end;

procedure pchar_to_real(apc:pchar; var areal:real);
	var astring:string;
   	 code:integer;
	begin
	remplace_pt_window_pt_decimal(apc);
	astring:=strpas(apc);
	system.val(astring,areal,code);
	if code<>0 then
   	areal:=0.0;
	end;

procedure remplace_pt_decimale_pt_window(apc:pchar);  {1.00 -> 1,00}
	var pc:pchar;
	begin
	if sDecimal[0]='.' then exit;
	pc:=strpos(apc,'.');
	if pc<>nil then
		pc^:=sDecimal[0];
	end;

procedure remplace_virgule_par_un_point(apc:pchar);
  var pc:pchar;
  begin
  pc:=strpos(apc,',');
  if pc<>nil then pc^:='.';
  end;

procedure real_to_pchar(areal:real; apc:pchar);
	var astring:string;
	begin
	str(areal,astring);
	strpcopy(apc,astring);
	remplace_pt_decimale_pt_window(apc);
   end;

procedure real_to_pchar_format(areal:extended; apc:pchar; nb_chiffre,nb_decimal : integer);
	var astring:string;
	begin
  if nb_decimal=32 then
    begin
    astring:=FloatToStrF(areal,ffGeneral,32,32); {c'est bien denis b}
    strpcopy(apc,astring);
    end
  else
    begin
	  str(areal:nb_chiffre:nb_decimal,astring);
	  strpcopy(apc,astring);
    end;
  remplace_pt_decimale_pt_window(apc);
	end;

function remplace_this_carac(in_string:pchar; carac:char; by_another:char):pchar;
  var pc_counter:pchar;
  begin
  pc_counter:=in_string;
  while pc_counter^<>#0 do
    begin
    if pc_counter^=carac then pc_counter^:=by_another;
    inc(pc_counter);
    end;
  result:=in_string; {By denis bertin}
  end; {remplace_this}

procedure caller_text_a_gauche(apchar:pchar; nb:integer; car:char);
	var apc:array[0..400] of char;
		 len:integer;
	begin
	len:=strlen(apchar);
	if len>=nb then exit;
	fillchar(apc,nb,car);
	strcopy(@apc[nb-len],apchar);
   strcopy(apchar,apc);
	end;


function rectinrect(var arect,brect:trect):boolean;
	var dest_rect:trect;
	begin
	unionrect(dest_rect,arect,brect);
	rectinrect:=(arect.left=dest_rect.left) and
		(arect.right=dest_rect.right) and
		(arect.top=dest_rect.top) and
		(arect.bottom=dest_rect.bottom);
	end;

function comparer_ext(filename,extension:pchar):boolean;
	var	Ext_file:string;
      Ext_verif:string;
	begin
  Ext_file:=ExtractFileExt(strpas(FileName));
  Ext_verif:=strpas(extension);
	comparer_ext:=(Ext_file=Ext_verif);
	end;


procedure verifier_ext(filename,extension:pchar);
  const kpc_dot = '.';
	var une_extension_de_fichier_en_majuscule:pc100;
      p:pchar;
	begin
  strUpper(strcopy(une_extension_de_fichier_en_majuscule,extension));
  if (strpos(filename,extension)=nil) and (strpos(filename,une_extension_de_fichier_en_majuscule)=nil) then
    begin
    p:=strpos(filename,kpc_dot);
    if p<>nil then  p^:=#0;
    strcat(filename,extension);
    end;
	end;

(*
function file_name(filename:pchar):pchar;
	var
	  Path: array[0..fsPathName] of Char;
	  Dir: array[0..fsDirectory] of Char;
	  Name: array[0..fsFileName] of Char;
	  Ext: array[0..fsExtension] of Char;
	begin
	FileSplit(filename, Dir, Name, Ext);
	file_name:=name;
	end;
*)

function file_size(filename:pchar):longint;
	var afile:file of byte;
		 taille:longint;
	begin
  taille:=0;
  try
	  Assign(afile,strpas(filename));
	  Reset(afile);
	  if IOResult=0 then
		  taille:=filesize(afile)
	  else
		  taille:=0;
	  close(afile);
  except
    end;
	file_size:=taille;
	end;


function is_a_directory(filename:pchar):boolean;
	BEGIN
	//FindFirst(filename, faReadOnly+faArchive, DirInfo); doserror<>0
	is_a_directory:= SysUtils.DirectoryExists(strpas(filename));
	end;

{
faReadOnly	$01
faHidden	$02
faSysFile	$04
faVolumeID	$08
faDirectory	$10
faArchive	$20
faAnyFile	$3F
}

function file_existe(filename:pchar):boolean;
	begin
  file_existe:=FileExists(strpas(filename));
	end;

procedure file_erase(filename:pchar);
	var ReOpenBuff: TOfStruct;
	begin
	OpenFile(FileName,ReOpenBuff,OF_DELETE);
	end;

procedure file_rename(filename,remplacer:pchar);
  var F:TextFile;
  begin
  AssignFile(f,strpas(filename));
  Rename(f,remplacer);
  CloseFile(F);
  end;

(*
procedure dir_erase(adir_name:pchar);
	var DirInfo: TSearchRec;
		 my_dir_name,dir_etoile,full_name,void_pc:pc255;
	begin
	strcat(strcopy(my_dir_name,adir_name),'\');
	strcat(strcopy(dir_etoile,my_dir_name),'*.*');
	{writeln('dir_etoile=',dir_etoile);}
	FindFirst(dir_etoile, FaAnyFile, DirInfo); { Same as DIR *.PAS }
	while DosError = 0 do
		begin
		if DirInfo.Name[0]<>'.' then
			begin
			{Writeln('Name=',DirInfo.Name);}
			strcat(strcopy(full_name,my_dir_name),strpcopy(void_pc,DirInfo.Name));
			{Writeln('full_name=',full_name);}
			file_erase(full_name);
			end;
		FindNext(DirInfo);
		end;
	RemoveDir(adir_name);
	end;
*)  

{procedure récursive qui créé tout les répertoire demander}

procedure Verif_et_creer_repertoire(apc_dir:pchar);
	var chaine_dir:string;
		 File_search:TSearchRec;
		 apc_dir_bis,pc:pchar;
	begin
	if compter_le_nb_anti_slash(apc_dir)>=2 then
		begin {verif sous répertoire}
		getmem(apc_dir_bis,300);
		strcopy(apc_dir_bis,apc_dir);
		pc:=strrscan(apc_dir_bis,wutil.PC_Anti_slash[0]);
		if pc<>nil then
			begin
			pc^:=#0;
			WUtil.Verif_et_creer_repertoire(apc_dir_bis);
			end;
		Freemem(apc_dir_bis,300);
		end; {verif sous répertoire}

	if FindFirst(apc_dir,faDirectory,File_search) <> 0 then
		begin
		chaine_dir:=strpas(apc_dir);
		MkDir(chaine_dir);
		end;
	FindClose(File_search)
	end; {Verif_et_creer_repertoire}

function compter_le_nb_anti_slash(apc:pchar):integer;
	var i,n_slash:integer;
	begin
	n_slash:=0; i:=0;
	while apc[i]<>#0 do
		begin
		if apc[i]=wutil.PC_Anti_slash[0] then
			inc(n_slash);
		inc(i);
		end;
	compter_le_nb_anti_slash:=n_slash;
	end; {compter_le_nb_anti_slash}

{Copieur simple avec contrôle d'erreur sur répertoire de destination}
{Attention le fichier d'entré n'est pas vérifier}
function File_Copy(entre,sortie:string):boolean;
	const taille_buf=100000;
	type tbuf=array[1..taille_buf] of Char;
	var FromF, ToF: file;
		 NumRead, NumWritten:Integer;
		 Buf:tbuf;
	begin
  try
  {-$i-}
	File_Copy:=False;
	Assign(FromF, entre);	{ Ouvre entrée }
	Reset(FromF, 1);		 	{ Taille Record = 1 }
	Assign(ToF,sortie);	{ Ouvre sortie }
	Rewrite(ToF, 1);		 	{ Taille Record = 1 }
	repeat
		BlockRead(FromF, Buf, SizeOf(TBuf), NumRead);
		BlockWrite(ToF, Buf, NumRead, NumWritten);
	until (NumRead = 0) or (NumWritten <> NumRead);
	Close(FromF);
	Close(ToF);
	File_Copy:=NumRead = 0;
  {-$i+}
  except
    end;
	end; {File_Copy}

{output pc and get_start_directory = starting directory}
function get_start_directory(pc:pchar):pchar;
	var I: Word;
	begin
	 strpcopy(pc,ParamStr(0));
	 i:=strlen(pc);
	 while i<>0 do
    	begin
		if pc[i]='\' then
      	begin
			pc[succ(i)]:=#0;
			i:=0;
			end
		else
			dec(i);
		end;
	 get_start_directory:=pc;
   end; {get_start_directory}

const hexChars: array [0..$F] of Char='0123456789ABCDEF';

function Hexbyte(b:byte):string;
	begin
	hexbyte:=hexChars[b shr 4]+hexChars[b and $F];
	end;

procedure Hexbyte_pchar(b:byte; pc:pchar);
  begin
  pc[0]:=hexChars[b shr 4];
  pc[1]:=hexChars[b and $F];
  pc[2]:=#0;
  end;

function HexWord(w: Word):string;
	begin
	hexword:=hexbyte(hi(w))+hexbyte(lo(w));
	end;

function Hexlongint_24bits(color:tcolorref):string;
  begin
  Hexlongint_24bits:=Hexbyte(getrvalue(color))+Hexbyte(getgvalue(color))+Hexbyte(getbvalue(color));
  end;

function Hexlongint(long: longint):string;
	begin
	Hexlongint:=hexword(long shr 16)+hexword(long and $ffff)
	end;

function  Hexvalue(hex:string):longint;
	var i:integer;
		 val:longint;
		 c:char;
	begin
	val:=0;
	for i:=length(hex) downto 1 do
		begin
		c:=upcase(hex[i]);
		case c of
			'0'..'9': val := round( val + ( ord(c) - ord('0') ) * power(16,length(hex)-i));
			'A'..'F': val := round( val + ( ord(c) - ord('A') + 10 ) * power(16,length(hex)-i));
			end;
		end;
	HexValue := val;
	end;

procedure bip;
	begin
  messagebeep(0);
  end;

procedure box(hwindow:hwnd;un_message:pchar);
	begin
	if not IsWindow(hwindow) then
		hwindow:=getfocus;
  messagebox(hwindow,un_message,vincent,mb_ok);
	end;

procedure loadandshow(adc:hdc; bm:hbitmap);
  var memdc:hdc;
      obm:hbitmap;
      bi:TBitmap;
  begin
  memdc:=createcompatibledc(adc);
  obm:=selectobject(memdc,bm);
  GetObject(bm,SizeOf(BI),@BI);
  bitblt(adc,0,0,bi.bmWidth,bi.bmHeight,memdc,0,0,SRCCOPY);
  selectobject(memdc,obm);
	deleteDC(memdc);
  end;

procedure loadandshowposition(adc:hdc; bm:hbitmap; x,y:integer);
  var memdc:hdc;
      obm:hbitmap;
      bi:TBitmap;
  begin
  memdc:=createcompatibledc(adc);
  obm:=selectobject(memdc,bm);
  GetObject(bm,SizeOf(BI),@BI);
  bitblt(adc,x,y,bi.bmWidth,bi.bmHeight,memdc,0,0,SRCCOPY);
  selectobject(memdc,obm);
	deleteDC(memdc);
  end;


procedure put_and_draw(adc:hdc; bm:hbitmap; position_x,position_y:integer; double:boolean);
  var memdc:hdc;
      obm:hbitmap;
      bi:TBitmap;
  begin
  memdc:=createcompatibledc(adc);
  obm:=selectobject(memdc,bm);
  GetObject(bm,SizeOf(BI),@BI);
  if double then
    StretchBlt(adc,position_x,position_y,bi.bmWidth*2,bi.bmHeight*2,memdc,0,0,bi.bmWidth,bi.bmHeight,SRCCOPY)
  else
    bitblt(adc,position_x,position_y,bi.bmWidth,bi.bmHeight,memdc,0,0,SRCCOPY);
  selectobject(memdc,obm);
	deleteDC(memdc);
  end;


procedure loadandstretch(adc:hdc; bm:hbitmap; deltax,deltay,width,height:integer);
  var memdc:hdc;
      obm:hbitmap;
      bi:TBitmap;
  begin
  memdc:=createcompatibledc(adc);
  obm:=selectobject(memdc,bm);
  GetObject(bm,SizeOf(BI),@BI);
  StretchBlt(adc,deltax,deltay,width,height,memdc,0,0,bi.bmWidth,bi.bmHeight,SRCCOPY);
  selectobject(memdc,obm);
	deleteDC(memdc);
  end;

procedure showbitmapposit(adc:hdc; bm:hbitmap; x,y:integer);
  var memdc:hdc;
      obm:hbitmap;
      bi:TBitmap;
  begin
  memdc:=createcompatibledc(adc);
  obm:=selectobject(memdc,bm);
  GetObject(bm,SizeOf(BI),@BI);
  bitblt(adc,x,y,bi.bmWidth,bi.bmHeight,memdc,0,0,SRCCOPY);
  selectobject(memdc,obm);
	deleteDC(memdc);
  end;


Procedure move_null(hw:hwnd);
	var apt,bpt:tpoint;
		 along:longint;
	begin
	getcursorpos(apt);
	bpt:=apt;
	screentoclient(hw,apt);
	along:=makelong(apt.x,apt.y);
	setcursorpos(bpt.x,succ(bpt.y));
	sendmessage(hw,Messages.wm_mousemove,0,along);
	setcursorpos(bpt.x,bpt.y);
	end;


function clip_board_is_mine(hwin:hwnd):boolean;
	var szclassname,szclipowner:pc100;
	begin
	getclassname(getclipboardowner,szclipowner,100);
	getclassname(hwin,szclassname,100);
	clip_board_is_mine:=strcomp(szclassname,szclipowner)=0;
	end;


procedure init_version;
	var version:longint;
	begin
	version:=getversion;
	version31:=(loword(version)=$0a03) or (loword(version)=$5f03) {95};
	end;

procedure supprimer_item_menu_en_trop(amenu:hmenu;count:integer);
	var aword:word;
	begin
	aword:=getmenuitemcount(amenu);
	if aword=$FFFF then exit;
	while aword>=count do
   	begin
		deletemenu(amenu,pred(aword),mf_byposition);
		aword:=getmenuitemcount(amenu);
      end;
	end;

procedure add_car_pos(apc:pchar;pos:word;c:char);
	var len,i:word;
	begin
	len:=strlen(apc);
	if len>pos then
		begin
		for i:=succ(len) downto len-pos do
			apc[succ(i)]:=apc[i];
		apc[len-pos]:=c;
		end;
	end;

procedure cross_a_rect(adc:hdc;arect:trect);
	begin
	with arect do
		begin
		moveto(adc,left,top);lineto(adc,right,bottom);
		moveto(adc,right,top);lineto(adc,left,bottom);
		end;
	end;

procedure cross_a_window(hwindow:hwnd;adc:hdc);
	var arect:trect;
	begin
	getclientrect(hwindow,arect);
	cross_a_rect(adc,arect);
	end; {cross_a_window}

procedure center_window(hwindow:hwnd);
	var MyRect: TRect;
		  X, Y: Integer;
      point_cursor:tpoint;
      moniteur:Forms.tmonitor;
	begin
  if (Forms.Screen.MonitorCount=1) then
    begin
	  X := GetSystemMetrics(SM_CXScreen) div 2;
	  Y := GetSystemMetrics(SM_CYScreen) div 2;
	  GetWindowRect(HWindow, MyRect);
	  with MyRect do
	  SetWindowPos(HWindow, 0,
      x -  ((Right-Left) div 2),
		  y - ((Bottom-Top) div 2),
      MyRect.Right,  MyRect.Bottom,swp_NoSize or swp_NoZOrder);
    end
  else
    begin
    Getcursorpos(point_cursor);
    moniteur:=Forms.Screen.MonitorFromPoint(point_cursor,mdNearest);
    with moniteur.BoundsRect do
      begin
      x:=(right+left) div 2;
      y:=(bottom+top) div 2;
      end;
    GetWindowRect(HWindow, MyRect);
    with MyRect do
      Movewindow(hwindow,
        x-((Right-Left) div 2),y-((Bottom-Top) div 2),Right-Left,Bottom-Top,false);
    end;
	end; {center_window}

procedure center_window_horizontal(hwindow:hwnd);
	var MyRect: TRect;
		 X: Integer;
	begin
	X := GetSystemMetrics(SM_CXScreen) div 2;
	GetWindowRect(HWindow, MyRect);
	with MyRect do
	 SetWindowPos(HWindow, 0, x -  ((Right-Left) div 2),
		MyRect.Top, MyRect.Right,  MyRect.Bottom,swp_NoSize or swp_NoZOrder);
	end; {center_window}


procedure init_internationnale;
	var apc: pc100;
	begin
	GetProfileString('intl', 'sDecimal', '.', apc, Sizeof(apc));
	strcopy(sDecimal,apc);
	GetProfileString('intl', 'sThousand',' ', apc, Sizeof(apc));
	strcopy(sThousand,apc);
	end; {init_internationnale}

function get_exe_path(path_exe:pchar):pchar;
	var p:pchar;
	begin
	strpcopy(path_exe,paramstr(0));
	P := StrRScan(path_exe, '\');
	inc(p); p^:=#0;
	get_exe_path:=path_exe;
	end;

function IS_Mode_256_Color:boolean;
	var adc:HDC;
		 nb_couleur:integer;
	begin
	{windows avec palette?}
	adc:=Getdc(0);
	nb_couleur:=GetDeviceCaps(adc, NumColors);
	releasedc(0,adc);
	IS_Mode_256_Color:=nb_couleur=20;
	end; {IS_Mode_256_Color}

function IS_Mode_Big_Font:boolean;
	begin
	IS_Mode_Big_Font:=GetSystemMetrics(SM_CYCAPTION)>20;
	end;

function Demande_largeur_ecran:integer;
	var adc:HDC;
	begin
	adc:=Getdc(0);
	Demande_largeur_ecran:=GetDeviceCaps(adc, HORZRES);
	releasedc(0,adc);
	end; {Demande_largeur_ecran:integer}

function Demande_hauteur_ecran:integer;
	var adc:HDC;
	begin
	adc:=Getdc(0);
	Demande_hauteur_ecran:=GetDeviceCaps(adc,VERTRES);
	releasedc(0,adc);
	end; {Demande_hauteur_ecran:integer}

procedure MakeDefaultFont(var alogfont:tlogFont; asize:integer);
	begin
	FillChar(ALogFont, SizeOf(TLogFont), #0);
	with ALogFont do
		begin
		lfHeight        := asize; 	{40 dans isaplan } { Taille en unite logique ou metre dans ver2}
		lfWeight        := 400;    {Indicate a Normal attribute Bold=700}
		lfItalic        := 0;      {Non-zero value indicates italic   }
		lfUnderline     := 0;      {Non-zero value indicates underline}
		lfOutPrecision  := Out_Stroke_Precis;
		lfClipPrecision := Clip_Stroke_Precis;
		lfQuality       := Default_Quality;
		lfPitchAndFamily:= Variable_Pitch;
		StrCopy(lfFaceName, 'Arial');
		end; {with}
	end; {MakeDefaultFont}

procedure MakeDefaultCalibri(var alogfont:tlogFont; asize:integer);
	begin
	FillChar(ALogFont, SizeOf(TLogFont), #0);
	with ALogFont do
		begin
		lfHeight        := asize; 	{40 dans isaplan } { Taille en unite logique ou metre dans ver2}
		lfWeight        := 400;    {Indicate a Normal attribute Bold=700}
		lfItalic        := 0;      {Non-zero value indicates italic   }
		lfUnderline     := 0;      {Non-zero value indicates underline}
		lfOutPrecision  := Out_Stroke_Precis;
		lfClipPrecision := Clip_Stroke_Precis;
		lfQuality       := Default_Quality;
		lfPitchAndFamily:= Variable_Pitch;
		StrCopy(lfFaceName, 'Calibri');
		end; {with}
	end; {MakeDefaultFont}


//To Obtain a mini rainbow-circle-écrit par Denis B et nn pas par cette fille grand menteur tu ment.
procedure Draw_mini_raindow_circle(paintdc:hdc; center:tpoint; rayon:integer);
  var i,j:integer;
      dist:single;
      angulary:real;
      une_couleur:tcolorref;
  begin
  for i:=center.x-rayon to center.x+rayon do for j:=center.y-rayon to center.y+rayon do
    begin
    dist:=utile.distance(center.x,center.y,i,j);
    if dist<rayon then
      begin
      angulary:=utile.angle_degree(center.x,center.y,i,j);
      une_couleur:=hls_rvb.Get_HLS_RGB(angulary,0.5,1);
      Setpixel(paintdc,i,j,une_couleur);
      end;
    end;
  end; {Draw_mini_raindow_circle}

Function Get_MakeDefaultFont(asize:integer):Hfont;
	var alogfont:tlogFont;
	begin
	wutil.MakeDefaultFont(alogfont,asize);
	Get_MakeDefaultFont:=CreateFontIndirect(alogfont);
	end; {Get_MakeDefaultFont}

Function Get_MakeDefaultCalibri(asize:integer):hfont;
  var alogfont:tlogFont;
	begin
  wutil.MakeDefaultCalibri(alogfont,asize);
	Get_MakeDefaultCalibri:=CreateFontIndirect(alogfont);
	end; {Get_MakeDefaultFont}

function StrCat_espace(apc:pchar):pchar;
	begin
	StrCat_espace:=strcat(apc,' ');
	end;

function StrCat_point(apc:pchar):pchar;
	begin
	StrCat_point:=strcat(apc,'.');
	end;

function StrCat_point_espace(apc:pchar):pchar;
	begin
	StrCat_point_espace:=StrCat_espace(StrCat_point(apc));
	end;

(*
Function IsCDROMDrive(wDrive:Word):boolean;
	label no_mscdex;
	var F:BOOL;
	begin
	asm
		mov ax, 1500h      {/* first test for presence of MSCDEX */}
		xor bx, bx
		int 2fh
		mov ax, bx         {/* MSCDEX is not there if bx is zero */}
		or  ax, ax         {/* ...so return FALSE */}
		jz  no_mscdex
		mov ax, 150bh      {/* MSCDEX driver check API */}
		mov cx, wDrive     {/* ...cx is drive index */}
		int 2fh
	no_mscdex:
		mov f,ax
	end; {asm}
	IsCDROMDrive:=f;
	end; {IsCDROMDrive}
*)  

(*
Function Get_Letter_of_first_CDROMDrive(apc:pchar):pchar; {ex d:\}
	var i:word;
	begin
	Get_Letter_of_first_CDROMDrive:=Nil;
	apc[0]:=#0;
	for i:=26 downto 3 do
		if IsCDROMDrive(i) then
			begin
			Get_Letter_of_first_CDROMDrive:=Apc;
			apc[0]:=chr(i+65);
			apc[1]:=':';
			apc[2]:='\';
			apc[3]:=#0;
			end;
	end;
*)  

function Power(a:real;b:integer):real;
	var i:integer;
		 n:real;
	begin
	n:=1.0;
	for i:=1 to b do
		n:=n*a;
	power:=n;
	end;

function Get_Dir_Appli(apc:pchar):pchar;
	var pc:pchar;
	begin
	strpcopy(apc,paramstr(0));
	pc:=StrRScan(apc,'\');
	if pc<>nil then
		begin
		inc(pc);
		pc^:=#0;
		Get_Dir_Appli:=Apc;
		end
	else
		Get_Dir_Appli:=Nil;
	end;

function suppr_quote_string(dans:string):string;
	var i:integer;
		 s:string;
		 c:char;
	begin
	s:='';
	for i:=2 to length(dans) do
		begin
		c:=dans[i];
		if c='"' then
			begin suppr_quote_string:=s; exit; end;
		s:=s+c;
		end;
	suppr_quote_string:=s;
	end;

function suppr_quote_pchar(dans:pchar):pchar;
	var s,t:string;
		 apc:array[0..1024] of char;
	begin
	s:=strpas(dans);
	t:=suppr_quote_string(s);
	strpcopy(apc,t);
	suppr_quote_pchar:=@apc;
	end;

function maxavail:integer;
  var lpBuffer: TMemoryStatus;
  begin
  GlobalMemoryStatus(lpBuffer);
  maxavail:=lpBuffer.dwAvailVirtual;
  end;

procedure afficher_la_taille_memoire;
  var apc,bpc:pc100;
      lpBuffer: TMemoryStatus;
  begin
  GlobalMemoryStatus(lpBuffer);
  with lpBuffer do
    begin
    inttopchar(dwLength,bpc); strcat(strcopy(apc,'sizeof(MEMORYSTATUS'),bpc); box(0,apc);
    inttopchar(dwMemoryLoad,bpc); strcat(strcopy(apc,'percent of memory in use'),bpc); box(0,apc);
    inttopchar(dwTotalPhys,bpc); strcat(strcopy(apc,'bytes of physical memory'),bpc); box(0,apc);
    inttopchar(dwAvailPhys,bpc); strcat(strcopy(apc,'free physical memory bytes'),bpc); box(0,apc);
    inttopchar(dwTotalPageFile,bpc); strcat(strcopy(apc,'bytes of paging file'),bpc); box(0,apc);
    inttopchar(dwAvailPageFile,bpc); strcat(strcopy(apc,'free bytes of paging file'),bpc); box(0,apc);
    inttopchar(dwTotalVirtual,bpc); strcat(strcopy(apc,'user bytes of address space'),bpc); box(0,apc);
    inttopchar(dwAvailVirtual,bpc); strcat(strcopy(apc,'// free user bytes'),bpc); box(0,apc);
    end;
  end; //afficher_la_taille_mémoire

function get_file_size(filename:string):longint;
  var int_FileHandle,iBytesRead: Integer;
  begin
  int_FileHandle:=FileOpen(FileName,fmOpenRead or fmShareCompat);
  get_file_size:=FileSeek(int_FileHandle,0,2);
  FileClose(int_FileHandle);
  end; {get_file_size}

procedure Cursor_Bouge_DE_Rien;
	var aPoint: TPoint;
	begin
	GetCursorPos(apoint);
	inc(Apoint.x);
	SetCursorPos (Apoint.x,Apoint.y);
	dec(Apoint.x);
	SetCursorPos (Apoint.x,Apoint.y);
	end; {Cursor_Bouge_DE_Rien}

function supprimer_car_underscore(adc:hdc; chaine:pchar; taille:word; var width:word):integer;
	var i,j:integer;
		 tempopc,retempo:pc100;
     SIZE:Tsize;
		 P:pchar;
		 Q:char;
	begin
	strcopy(tempopc,chaine);
	strcopy(retempo,chaine);
	P:=Strpos(retempo,kpc_ampersand);
	if P<>nil then
		begin
		inc(p);
		Q:=P^;
		P^:=#0;
		GetTextExtentPoint(adc,retempo,strlen(retempo),size);
    supprimer_car_underscore:=size.Cx;
		p^:=Q;
    GetTextExtentPoint(adc,p,1,size);
		width:=size.Cx;
		j:=0;
		for i:=0 to strlen(tempopc) do
			begin
			if tempopc[i]<>kpc_ampersand[0] then
				begin
				chaine[j]:=tempopc[i];
				inc(j);
				end;
			end;
		end
	else
		supprimer_car_underscore:=-1;
	end; {supprimer_car_underscore}

procedure Tranche_de_camenbert_par_teinte(dc:hdc; x,y,xx,yy:integer; angle_depart,angle_arriver:real);
  var abrush:hbrush;
      apencil:hpen;
      acolor_hls:tcolorref;
      ax,ay,dx,dy:integer;
  begin
  hls_rvb.hls_to_tcolorref(angle_depart*360/utile.deuxpi,0.5,1,acolor_hls);
  apencil:=SelectObject(dc,Getstockobject(NULL_PEN));
  abrush:=selectobject(dc,CreateSolidBrush(acolor_hls));
  ax:=(x+xx) div 2;
  ay:=(y+yy) div 2;
  dx:=(xx-x) div 2;
  dy:=(yy-y) div 2;
  Pie(dc,x,y,xx,yy,
    ax+round(cos(angle_depart)*dx),
    ay-round(sin(angle_depart)*dy),
    ax+round(cos(angle_arriver)*dx),
    ay-round(sin(angle_arriver)*dy));
  deleteObject(Selectobject(dc,abrush));
  Selectobject(dc,apencil);
	end;

procedure Soft_circle(paintdc:hdc; x,y,r:integer);
	var i,j:integer;
			un_angle:real;
	begin
	for i:=-r to r do for j:=-r to r do
		if utile.idistance(0,0,i,j)<=r then
			setpixel(paintdc,x+i,y+j,hls_rvb.Get_HLS_RGB(utile.angle_degree(0,0,i,j),0.5,1));
	end; {Soft_circle}

procedure Soft_rectangle_rectangulaire(paintdc:hdc; Rect:trect; couleur:tcolorref);
	begin
	with rect do Soft_rectangle(paintdc,left,top,right,bottom,couleur);
	end;

procedure Soft_interro(adc:hdc; var un_rectangle:trect);
	var afont:hfont;
		 dw_size:tsize;
	begin
	with un_rectangle do
		begin
		afont:=selectObject(adc,wutil.Get_MakeDefaultFont(12));
		GettextExtentPoint(adc,wutil.kpc_interro,strlen(wutil.kpc_interro),dw_size);
		un_rectangle.right:=un_rectangle.left+dw_size.cx+4;
		un_rectangle.bottom:=un_rectangle.top+dw_size.cy;
		rectangle(adc,left,top,right,bottom);
		textout(adc,left+2,top,wutil.kpc_interro,strlen(wutil.kpc_interro));
		deleteobject(selectObject(adc,afont));
		end;
	end;


{Fonctionne sur une variation de 20 pixels - copyright Denis Bertin}
procedure Soft_rectangle(paintdc:hdc; x,y,xx,yy:integer; couleur:tcolorref);
	var i,max,diff:integer;
      apencil:hpen;
      h,l,s:real;
      une_autre_couleur:tcolorref;
  begin
  {pour conserver sa teinte et changer sa luminosité}
  hls_rvb.tcolorref_to_hls(couleur,h,l,s);
  max:=(yy+y) div 2;
  diff:=yy-y;
  for i:=y to max do
    begin
    hls_rvb.hls_to_tcolorref(h,1.0-math.max(0,(i-y)/diff),s,une_autre_couleur);
    apencil:=Selectobject(Paintdc,CreatePen(PS_SOLID,1,une_autre_couleur));
    moveto(paintdc,x,i);
    lineto(paintdc,xx,i);
    DeleteObject(Selectobject(Paintdc,apencil));
    end;
  for i:=max to yy do
    begin
    apencil:=Selectobject(Paintdc,CreatePen(PS_SOLID,1,couleur));
    moveto(paintdc,x,i);
    lineto(paintdc,xx,i);
    DeleteObject(Selectobject(Paintdc,apencil));
    end;
  end; {Soft_rectangle}

{Draw_Random_Rect - Copyright Denis Bertin}
procedure Draw_Random_Rect(paintdc:hdc; Rect_bouton_palette_fine:trect);
  var i,j:integer;
      une_couleur:tcolorref;
  begin
  with Rect_bouton_palette_fine do
    for i:=left to right do
      for j:=top to bottom do
        begin
        une_couleur:=rgb(random(255),random(255),random(255));
        Setpixel(paintdc,i,j,une_couleur);
        end;
  end; {Draw_Random_Rect}

procedure Draw_Rainbow_Rect(paintdc:hdc; Rect_bouton_palette_fine:trect);
  var i,j:integer;
      une_couleur:tcolorref;
  begin
  with Rect_bouton_palette_fine do
    for i:=left to pred(right) do
      for j:=top to pred(bottom) do
        begin
        hls_rvb.hls_to_tcolorref(360.0*(i-left)/(right-left),0.5,1.0,une_couleur);
        Setpixel(paintdc,i,j,une_couleur);
        end;
  end; {Draw_Rainbow_Rect}

procedure Add_Dot_delimitor_each_tree_car(in_pc,out_pc:pchar);
  var i,counter:integer;
      pc_this_car:pc10;
      pc_temp_invert:wutil.pc1024;
  begin
  counter:=0;
  strcopy(pc_temp_invert,'');
  for i:=pred(strlen(in_pc)) downto 0 do
    begin
    inc(counter);
    if counter=4 then
      begin
      counter:=0;
      strcat(pc_temp_invert,kpc_dot);
      end;       
    pc_this_car[0]:=in_pc[i];
    pc_this_car[1]:=#0;
    strcat(pc_temp_invert,pc_this_car);
    end;
  strcopy(out_pc,'');
  for i:=pred(strlen(pc_temp_invert)) downto 0 do
    begin
    pc_this_car[0]:=pc_temp_invert[i];
    pc_this_car[1]:=#0;
    strcat(out_pc,pc_this_car);
    end;
  end; {Add_Dot_delimitor_each_tree_car}

procedure Draw_a_grid_in_this_window(awindow:hwnd; paintdc:hdc; quelle_couleur:tcolorref);
  var i,j:integer;
      arect:trect;
  begin
  GetClientRect(awindow,arect);
  for i:=10 to arect.right-5 do
    begin
    if i mod 2=0 then
      begin
      for j:=0 to 10 do
        SetPixel(paintdc,i,round(arect.Bottom-10-j/10*(arect.Bottom-10)),quelle_couleur);
      end;
    end;
    for i:=10 to arect.right-5 do
      if (i-10) mod 20=0 then
        for j:=arect.Bottom-10 downto 10 do
          if j mod 2 = 0 then
            SetPixel(paintdc,i,j,quelle_couleur);
  end; {Draw_a_grid_in_this_window}

Function is_drive_removable(lettre:char):boolean;
  var ret:integer;
      apc:pc100;
  begin
  is_drive_removable:=false;
  apc[0]:=lettre;
  apc[1]:=':';
  apc[2]:='\';
  apc[3]:=#0;
  ret:=GetDriveType(apc);
  case ret of
    0:;
    DRIVE_REMOVABLE:is_drive_removable:=true;
    DRIVE_FIXED:is_drive_removable:=false;
    DRIVE_REMOTE:is_drive_removable:=false;
    end; {case}
  end; {is_drive_removable}


var a : integer;

begin
//afficher_la_taille_memoire;
a:=maxavail;
init_internationnale;
end.
