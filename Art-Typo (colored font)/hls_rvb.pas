unit hls_rvb;

interface

uses windows,wutil,SysUtils;

type

	Thls = record
		h,l,s:word;
	end; {record Thls}

{HLS->RGB}
{ih:0..360, il:0..100, is:0..100 -> 	tcolorref}
procedure ihls_to_tcolorref(ih,il,isat:integer; var acolor:tcolorref);
{h:0..360, l:0..1, s:0..1 -> 	tcolorref}
procedure hls_to_tcolorref(h,l,s:real; var acolor:tcolorref);
{h:0..360, l:0..1, s:0..1 -> 	r:0..1, g:0..1, b:0..1}
procedure HLS_to_RGB(h,l,s:real; var r,g,b:real);
{h:0..360, l:0..1, s:0..1 -> cyan:0..1, magenta:0..1, jaune:0..1}
procedure HLS_to_CMY(hue,Lumiere,saturation:real; var cyan,magenta,jaune:real);
{h:0..360, l:0..1, s:0..1 -> 	r:0..1, g:0..1, b:0..1}
function Get_HLS_RGB(h,l,s:real):TColorref;


{RGB->HLS}
{tcolorref  ->  h:0..360, l:0..1, s:0..1}
procedure tcolorref_to_hls(acolor:tcolorref; var h,l,s:real);
{r:0..1, g:0..1, b:0..1   ->  h:0..360, l:0..1, s:0..1}
procedure RGB_to_HLS(r,g,b:real; var h,l,s:real);

function get_lumiere_from_tcolor(une_couleur:TColorref):real;

{RGB->CMYB en pourcent 0.0 - 1.0}
procedure RGB_to_CMYB(RGB_long:TcolorRef; VAR Real_Cyan,Real_Magenta,Real_Yellow,Real_black:real);
{CMYB->RGB en pourcent 0.0 - 1.0}
procedure CMYB_to_RGB(Real_Cyan,Real_Magenta,Real_Yellow,Real_black:real; var RGB_long:TcolorRef);

procedure RGB_to_PChar(RGB_long:TcolorRef; Out_apc:pchar);

implementation

function rmax(a,b:real):real;
	begin
	if a>b then rmax:=a else rmax:=b;
	end;

function rmin(a,b:real):real;
	begin
	if a<b then rmin:=a else rmin:=b;
	end;

{ih:0..360, il:0..100, is:0..100 -> 	tcolorref}
procedure ihls_to_tcolorref(ih,il,isat:integer; var acolor:tcolorref);
	begin
	hls_to_tcolorref(ih,(1.0*il)/100,(1.0*isat)/100,acolor);
	end; {ihls_to_tcolorref}

{h:0..360, l:0..1, s:0..1 -> 	tcolorref}
procedure hls_to_tcolorref(h,l,s:real; var acolor:tcolorref);
	var r,g,b:real;
	begin
	if h>=360 then
    h:=round(h) mod 360;
	HLS_to_RGB(h,l,s,r,g,b);
	acolor:=RGB(round(R*255),round(G*255),round(B*255));
	end; {ihls_to_tcolorref}

function Get_HLS_RGB(h,l,s:real):TColorref;
	var r,g,b:real;
	begin
	while h>360 do h:=h-360;
	HLS_to_RGB(h,l,s,r,g,b);
	Get_HLS_RGB:=RGB(round(R*255),round(G*255),round(B*255));
	end;

procedure HLS_to_CMY(hue,Lumiere,saturation:real; var cyan,magenta,jaune:real);
  const espace = 360;
  var teinte:integer;
  begin
  cyan:=hue/espace*Lumiere;
  teinte:=round(hue+120);
  teinte:=teinte mod 360;
  magenta:=teinte/espace*Lumiere;
  teinte:=round(hue+240);
  teinte:=teinte mod 360;
  jaune:=teinte/espace*Lumiere;
  if false then
    begin
    if hue<120 then
      begin
      cyan:=hue/120;
      magenta:=hue/(2*120);
      jaune:=0;
      end
    else if hue<240 then
      begin
      cyan:=(hue-120)/(2*120);
      magenta:=(hue-120)/120;
      jaune:=0;
      end
    else
      begin
      cyan:=0;
      magenta:=(hue-240)/(2*120);
      jaune:=(hue-240)/120;
      end;
    end;
  end;

(* code C a partir d'une méthode découverte à la bibliothèque de la vilette by db*)
procedure HLS_to_RGB(h,l,s:real; var r,g,b:real);
	var v,m,sv,fract,vsf,mid1,mid2:real;
		 sextant:integer;
	begin
	if h=360 then
    h:=0
  else
    h:=h/360;
	if l<=0.5 then
		v:=l*(1.0+s)
	else
		v:=l+s-l*s;
	if v<=0.0 then
		begin
		r:=0.0; g:=0.0; b:=0.0;
		end
	else
		begin
		m:=l+l-v; sv:=(v-m)/v;
		h:=h*6.0;
		sextant:=trunc(h);
		fract:=h-sextant;
		vsf:=v*sv*fract;
		mid1:=m+vsf;
		mid2:=v-vsf;
		case sextant of
			0:begin r:=v;		  g:=mid1;	b:=m		end;
			1:begin r:=mid2;	g:=v;		  b:=m		end;
			2:begin r:=m;		  g:=v;		  b:=mid1	end;
			3:begin r:=m;		  g:=mid2;	b:=v		end;
			4:begin r:=mid1;	g:=m;		  b:=v		end;
			5:begin r:=v;		  g:=m;		  b:=mid2	end;
			end; {case sextant}
      end;
	end; {HLS_to_RGB}

(* code mixte pascal

procedure HLS_to_RGB(hue,value,sat:real; var r,g,b:real);
	var MinCol:real;
	begin
	MinCol:=value*(1.0-sat);
	if hue<=120.0 then
		begin
		B:=MinCol;
		if hue<=60.0 then
			begin
			R:=Value;
			G:=MinCol+Hue*(Value-MinCol)/(120.0-Hue);
			end
		else
			begin
			G:=Value;
			R:=MinCol+(120.0-Hue)*(Value-MinCol)/Hue;
			end
		end
	else if hue<=240.0 then
		begin
		R:=MinCol;
		if hue<=180.0 then
			begin
			G:=Value;
			B:=MinCol+(Hue-120.0)*(Value-MinCol)/(240.0-Hue);
			end
		else
			begin
			B:=Value;
			G:=MinCol+(240.0-Hue)*(Value-MinCol)/(Hue-120.0);
			end
		end
	else
		begin
		G:=MinCol;
		if hue<=300.0 then
			begin
			B:=Value;
			R:=MinCol+(Hue-240.0)*(Value-MinCol)/(360.0-Hue);
			end
		else
			begin
			R:=Value;
			B:=MinCol+(360.0-Hue)*(Value-MinCol)/(Hue-240.0);
			end
      end;
	end; {HLS_to_RGB}
*)

(* code pascal

procedure HLS_to_RGB(h,l,s:real; var r,g,b:real);
	var mini,maxi:real;

	function val(mini,maxi,nuance:real):real;
		begin
		if nuance<0 then nuance:=nuance+360;
		if nuance<60 then
			val:=mini+(maxi-mini)*nuance/60
		else
			if nuance<180 then
				val:=maxi
			else
				if nuance<240 then
					val:=mini+(maxi-mini)*(240-nuance)/60
				else
					val:=mini;
      end; 

	begin {HLS_to_RGB}
	if l<=0.5 then
		maxi:=l*(1+s)
	else
		maxi:=l+s+l*s;
	mini:=2*l-maxi;
	r:=val(mini,maxi,h);
	g:=val(mini,maxi,h-120);
	b:=val(mini,maxi,h-240);
	end; {HLS_to_RGB}
*)

{tcolorref  ->  h:0..360, l:0..1, s:0..1}
procedure tcolorref_to_hls(acolor:tcolorref; var h,l,s:real);
	begin
	RGB_to_HLS(
		1.0*getrvalue(acolor)/255,
		1.0*getgvalue(acolor)/255,
		1.0*getbvalue(acolor)/255, h,l,s);
   end;

{r:0..1, g:0..1, b:0..1   ->  h:0..360, l:0..1, s:0..1}
procedure RGB_to_HLS(r,g,b:real; var h,l,s:real);
	var v,m,vm,r2,g2,b2:real;
	begin
	v:=rmax(rmax(r,g),b);
	m:=rmin(rmin(r,g),b);

	l:=(m+v) / 2.0; h:=0; s:=0;
	if l<=0 then
		begin
		l:=0;
    exit;
		end;

   vm:=v-m;	s:=vm;
	if s>0.0 then
		begin
		if l<0.5 then
			s:=s/(v+m)
		else
			s:=s/(2.0-v-m);
		end
	else
		exit;
	r2:=(v-r)/vm;	g2:=(v-g)/vm;	b2:=(v-b)/vm;
	if r=v then
		begin
		if g=m then
			h:=5.0+b2
		else
      	h:=1.0-g2
		end
	else if g=v then
		begin
		if b=m then
			h:=1.0+r2
		else
      	h:=3.0-b2
		end
	else
		begin
		if r=m then
			h:=3.0+g2
		else
      	h:=5.0-r2
		end;

	h:=round(h*60) mod 360;
	{h:=h/6;
	h:=h*360;}
	end; {RGB_to_HLS}

function get_lumiere_from_tcolor(une_couleur:TColorref):real;
  var hue,lum,sat:real;
  begin
  hls_rvb.tcolorref_to_hls(une_couleur,hue,lum,sat);
  get_lumiere_from_tcolor:=lum;
  end;

(*
procedure RGB_to_HLS(r,g,b:real; var h,l,s:real);
	var rr,gg,bb,mini,maxi,diff,tot:real;

	begin
	rr:=r; gg:=g; bb:=b;
	maxi:=rmax(rmax(rr,gg),bb);
	mini:=rmin(rmin(rr,gg),bb);
	if mini<>maxi then
		begin
		diff:=maxi-mini;
		rr:=(maxi-rr)/diff;
		gg:=(maxi-gg)/diff;
		bb:=(maxi-bb)/diff;
		end;
	tot:=maxi+mini; l:=tot/2;
	if maxi=mini then
		s:=0
	else
		if l<=0.5 then
			s:=diff/tot
		else
			s:=diff/(2-tot);
	if s=0 then
		h:=0
	else
		if r=maxi then
			h:=2+bb-gg
		else
			if g=maxi then
				h:=4+rr-bb
			else h:=6+gg-rr;
		h:=round(h*60) mod 360;
	end; {RGB_to_HLS}
*)

{RGB->CMYB en pourcent}
procedure RGB_to_CMYB(RGB_long:TcolorRef; VAR Real_Cyan,Real_Magenta,Real_Yellow,Real_black:real);
	var rouge,vert,bleu:real;
	begin
	rouge:=GetRvalue(RGB_long);
	vert:=GetGvalue(RGB_long);
	bleu:=GetBvalue(RGB_long);
	Real_Cyan:=1.0-(rouge/255);
	Real_Magenta:=1.0-(vert/255);
	Real_Yellow:=1.0-(bleu/255);
	Real_black:=wutil.Real_min(wutil.Real_min(Real_Cyan,Real_Magenta),Real_Yellow);
	Real_Cyan:=Real_Cyan-Real_black;
	Real_Magenta:=Real_Magenta-Real_black;
	Real_Yellow:=Real_Yellow-Real_black;
	end; {RGB_to_CMYB}

procedure CMYB_to_RGB(Real_Cyan,Real_Magenta,Real_Yellow,Real_black:real; var RGB_long:TcolorRef);
	begin
	Real_Cyan:=		  wutil.Real_min(1.0,Real_Cyan+Real_black);
	Real_Magenta:=	wutil.Real_min(1.0,Real_Magenta+Real_black);
	Real_Yellow:=	  wutil.Real_min(1.0,Real_Yellow+Real_black);

	RGB_long:=rgb(
		round((1.0-Real_Cyan)*255),
		round((1.0-Real_Magenta)*255),
		round((1.0-Real_Yellow)*255));
	end; {CMYB_to_RGB}

procedure RGB_to_PChar(RGB_long:TcolorRef; Out_apc:pchar);
	var str:pc255;
	const k_2_blanc='  ';
			{$ifdef dis_neo}
			k_R='R '; k_V='G '; k_B='B ';
			{$else}
			k_R='R '; k_V='V '; k_B='B ';
			{$endif}
	begin
	wutil.Inttopchar(GetRValue(RGB_long),Str);
	Strcat(Strcat(Strcopy(Out_apc,k_R),Str),k_2_blanc);
	wutil.Inttopchar(GetGValue(RGB_long),Str);
	Strcat(Strcat(Strcat(Out_apc,k_V),Str),k_2_blanc);
	wutil.Inttopchar(GetBValue(RGB_long),Str);
	Strcat(Strcat(Strcat(Strcat(Out_apc,k_B),Str),k_2_blanc),k_2_blanc);
   end;

(*
var r,g,b:real;
var h,l,s:real;

begin
writeln;
writeln('0,0,1');
RGB_to_HLS(0,0,1,h,l,s);
writeln('h=',h:3:2);
writeln('l=',l:3:2);
writeln('s=',s:3:2);
writeln;
writeln('HLS_to_RGB');
HLS_to_RGB(h,l,s,r,g,b);
writeln('r=',r:3:2);
writeln('g=',g:3:2);
writeln('b=',b:3:2);
*)

end.

