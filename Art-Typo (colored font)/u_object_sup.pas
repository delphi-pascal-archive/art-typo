unit u_object_sup;

interface

uses graphics, // pour Tbitmap
	  extctrls, // pour TImage
     Sysutils; // pour sysutil

const memory_assigned_once = true;
      k_blanc=$ffffff;

type

	T_Bitmap = class(TBitmap)
      public
      secure:boolean;
      fail:boolean;
      Constructor Create_size(width,height:integer);
		  Constructor Create_from_image(var image:timage);
      Destructor 	Destroy; override;
      Procedure   copy_to_bm(abm:tbitmap);
   	  Procedure   Copy_to_image(var image:timage);
      Procedure   Image_to_BMP(var image:timage);
   	  Function 	Get_pixel(x,y:integer):Tcolor;
      Function  Get_pixel_color(x,y:integer; var acolor:Tcolor):boolean;
   	  Procedure Set_Pixel(x,y:integer; acolor:tcolor);
   	  function 	Scanline(Row: Integer): Pointer; overload;
      Function 	Is_blanc(x,y:integer):boolean;
      Function 	Point_next_to_color(m,n:integer;color_vide:tcolor):boolean;
      Function 	nb_Point_next_color(m,n:integer;color_vide:tcolor):integer;
   private
   	SL:array of pointer;
	end;

implementation

Constructor T_Bitmap.Create_size(width,height:integer);
	begin
   inherited create;
   Self.secure:=false;
   Self.fail:=false;
   Self.Width :=Width;
   Self.Height:=Height;
   Self.PixelFormat:=pf32bit;
   if memory_assigned_once then
   	setlength(SL,Height);
   end;

Constructor T_Bitmap.Create_from_image(var image:timage);
	begin
   Create_size(Image.Width,Image.Height);
   Self.Image_to_BMP(image);
   end;

Destructor T_Bitmap.Destroy;
	begin
   if memory_assigned_once then
   	begin
   	setlength(SL,0);
   	self.SL:=nil;
      end;
   inherited;
   end;

Procedure T_Bitmap.copy_to_bm(abm:tbitmap);
	begin
	Self.Canvas.Draw(0,0,abm);
   end;

Procedure T_Bitmap.Image_to_BMP(var image:timage);
	begin
   Self.Canvas.Draw(0,0,Image.Picture.graphic);
   end;

procedure T_Bitmap.Copy_to_image(var image:timage);
	begin
   Image.Canvas.Draw(0,0,self);
   end;

Function T_Bitmap.Get_pixel(x,y:integer):Tcolor;
	var Pcolor:^Tcolor;
   {$ifdef debug} s_color:string; {$endif debug}
	begin
   if secure then
   	begin
   	if (x<0) or (x>=width) or (y<0) or (y>=height) then
   		begin
      	result:=0;
      	Self.fail:=true;
         exit;
      	end;
      Self.fail:=false;
      end;

   Pcolor:=self.ScanLine(y);
   inc(Pcolor,x);
	 result:=Pcolor^ and k_blanc;
   {$ifdef debug} s_color:=inttohex(result,8); {$endif debug}
   end;

Function T_Bitmap.Get_pixel_color(x,y:integer; var acolor:Tcolor):boolean;
	var Pcolor:^Tcolor;
   {$ifdef debug} s_color:string; {$endif debug}
	begin
   if (x<0) or (x>=width) or (y<0) or (y>=height) then
     	result:=false
   else
   	begin
      Pcolor:=self.ScanLine(y);
	   inc(Pcolor,x);
		acolor:=Pcolor^ and k_blanc;
	   {$ifdef debug} s_color:=inttohex(result,8); {$endif debug}
      result:=true;
      end;
   end;

Procedure T_Bitmap.Set_Pixel(x,y:integer; acolor:tcolor);
	var Pcolor:^Tcolor;
   {$ifdef debug} s_color:string; {$endif debug}
	begin
   {$ifdef debug} s_color:=inttohex(acolor,8); {$endif debug}
   Pcolor:=self.ScanLine(y);
   inc(Pcolor,x);
   Pcolor^:=acolor;
   end;

function T_Bitmap.Scanline(Row:Integer): Pointer;
	begin
   if memory_assigned_once then
   	begin
   	if SL[Row]=nil then
   		SL[Row]:=inherited Scanline[Row];
   	result:=SL[Row];
      end
   else
		inherited Scanline[Row];
   end;

Function T_Bitmap.Is_blanc(x,y:integer):boolean;
	begin
	result:=Get_pixel(x,y) = $ffffff;
  end;

Function T_Bitmap.Point_next_to_color(m,n:integer;color_vide:tcolor):boolean;
	var acolor:Tcolor;
	begin
   result:=true;
   if Get_pixel_color(succ(m),n,acolor) and (acolor=color_vide) then exit;
   if Get_pixel_color(pred(m),n,acolor) and (acolor=color_vide) then exit;
  	if Get_pixel_color(m,succ(n),acolor) and (acolor=color_vide) then exit;
   if Get_pixel_color(m,pred(n),acolor) and (acolor=color_vide) then exit;
  	if Get_pixel_color(succ(m),succ(n),acolor) and (acolor=color_vide) then exit;
  	if Get_pixel_color(pred(m),pred(n),acolor) and (acolor=color_vide) then exit;
  	if Get_pixel_color(pred(m),succ(n),acolor) and (acolor=color_vide) then exit;
   if Get_pixel_color(pred(m),pred(n),acolor) and (acolor=color_vide) then exit;
   result:=false;
   end;

Function T_Bitmap.nb_Point_next_color(m,n:integer;color_vide:tcolor):integer;
	var acolor:Tcolor;
	begin
   result:=0;
   if Get_pixel_color(succ(m),n,acolor) and (acolor=color_vide) then inc(result);
   if Get_pixel_color(pred(m),n,acolor) and (acolor=color_vide) then inc(result);
  	if Get_pixel_color(m,succ(n),acolor) and (acolor=color_vide) then inc(result);
   if Get_pixel_color(m,pred(n),acolor) and (acolor=color_vide) then inc(result);
  	if Get_pixel_color(succ(m),succ(n),acolor) and (acolor=color_vide) then inc(result);
  	if Get_pixel_color(pred(m),pred(n),acolor) and (acolor=color_vide) then inc(result);
  	if Get_pixel_color(succ(m),pred(n),acolor) and (acolor=color_vide) then inc(result);
   if Get_pixel_color(pred(m),succ(n),acolor) and (acolor=color_vide) then inc(result);
   end;

end.
