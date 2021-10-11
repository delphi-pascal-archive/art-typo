unit Smooth;

interface

uses  Windows,
		Graphics,
      comctrls,
		extctrls,
      Classes,
      u_object_sup,
      Thread;

const k_dir:array[1..9] of tpoint =
			( (x:-1;y:1), (x:0;y:1), (x:1;y:1),
           (x:-1;y:0), (x:0;y:0), (x:1;y:0),
           (x:-1;y:-1), (x:0;y:-1), (x:1;y:-1));

type TSmooth = procedure(x,y:integer; var nb:integer) of object;

type
  Smooth_follow = class(Tobject)
    protected
    	Thread_Progress:Thread_progress;
  	 public
	    ok:boolean;
   	 bm1,bm2:T_Bitmap;
    constructor Create(abitmap:T_bitmap; aThread:Thread_progress);
    destructor  Destroy; override;
    function 	 Init_bm:boolean;
    function 	 Make(acolor_vide:tcolor; adistance:integer):boolean;
    procedure   Smooth_line(xx,yy:integer; var nb:integer);
    procedure   Smooth_all(x,y:integer; var nb:integer);
    private
    	action:TSmooth;
      r,v,b,w,h:integer;
      color_vide:tcolor;
      distance:integer;
  end;

implementation

constructor Smooth_follow.Create(abitmap:T_bitmap; aThread:Thread_progress);
	begin
   bm1:=abitmap;
   Thread_Progress:=aThread;
   ok:=init_BM;
	 action:=Smooth_all;
	 //action:=Smooth_line;
   w:=bm1.width;
   h:=bm1.height;
   end;

destructor Smooth_follow.Destroy;
	begin
   bm2.free;
	inherited;
   end;

function Smooth_follow.init_bm:boolean;
	begin
   init_bm:=false;
   bm2:=nil;
   try
   	bm2:=T_Bitmap.create_size(bm1.width,bm1.height);
      init_bm:=true;
   finally end
   end;

function Smooth_follow.Make(acolor_vide:tcolor; adistance:integer):boolean;
	var i,j,nb:integer;
       acolor:tcolor;
	begin
   result:=false;
   if not ok then exit;
   color_vide:=acolor_vide;
   distance:=adistance;

   Thread_Progress.ProgressBar.max:=pred(w);

   for i:=0 to pred(w) do
      begin //0

      if Thread_Progress<>nil then
      	begin
			Thread_Progress.Fi:=i;
         Thread_Progress.Set_synchro_progress_bar;
         end;

   	for j:=0 to pred(h) do
      	begin //1
         acolor:=bm1.Get_pixel(i,j);
         if acolor=color_vide then
         	begin //2 vide
            nb:=1;
            r:=getrvalue(acolor);
            v:=getgvalue(acolor);
            b:=getbvalue(acolor);
            action(i,j,nb);
            if nb<>1 then
            	bm2.set_pixel(i,j,rgb(round(r/nb),round(v/nb),round(b/nb)));
            end //2 vide
         else
         	bm2.set_pixel(i,j,acolor);
         end; //1
		end; //0
	result:=true;
	end;

procedure Smooth_follow.Smooth_line(xx,yy:integer; var nb:integer);
	var i,m,n:integer;
       acolor:tcolor;
	begin
   bm1.secure:=true;
   for i:=1 to 9 do
   	if i<>5 then
      	begin
      	with k_dir[i] do begin m:=x+xx; n:=y+yy; end;

			if bm1.Get_pixel_color(m,n,acolor) then
            if acolor<>color_vide then
  	         	if bm1.nb_Point_next_color(m,n,color_vide)<4 then
     	         	begin
        	         inc(nb);
  	      	   	inc(r,getrvalue(acolor));
   	      	   inc(v,getgvalue(acolor));
  	   	      	inc(b,getbvalue(acolor));
                  end;
         end;
   end; //Smooth_follow.Smooth_line

procedure Smooth_follow.Smooth_all(x,y:integer; var nb:integer);
   var m,n:integer;
   	 acolor:tcolor;
	begin
   bm1.secure:=true;
	for m:=x-distance to x+distance do
		for n:=y-distance to y+distance do
         if (m<>x) and (n<>y) and
            bm1.Get_pixel_color(m,n,acolor) and
            (acolor<>k_blanc) and
             bm1.point_next_to_color(m,n,color_vide) then
      	    	begin //3
	  	      	inc(nb);
   		      inc(r,getrvalue(acolor));
  	   		   inc(v,getgvalue(acolor));
     	   		inc(b,getbvalue(acolor));
            	end; //3

   end; //Smooth_follow.Smooth_all

end.
