unit Soft;

interface

uses  Windows,
		Graphics,
		 comctrls,
		extctrls,
		 Classes,
		 u_object_sup,
		 Thread;

const n_dir = 9;

const k_dir:array[1..n_dir] of tpoint =
			( (x:-1;y:1), (x:0;y:1), (x:1;y:1),
				(x:-1;y:0), (x:0;y:0), (x:1;y:0),
				(x:-1;y:-1), (x:0;y:-1), (x:1;y:-1));

const n_dir_simple = 5;

const k_dir_simple:array[1..n_dir_simple] of tpoint =
			( (x:-1;y:0), (x:1;y:0), (x:0;y:0), (x:0;y:-1), (x:0;y:+1));

const n_dir_mini = 4;

const k_dir_mini:array[1..n_dir_mini] of tpoint =
			( (x:0;y:0), (x:1;y:0), (x:0;y:1), (x:1;y:1));


type Type_adoucir = ( TA_9, TA_5, TA_4 );

type TSoft = procedure(x,y:integer) of object;

type
	Soft_follow = class(Tobject)
	  protected
		Thread_Progress:Thread_progress;
		 public
		 ok:boolean;
		 bm1,bm2:T_Bitmap;
	  constructor Create(abitmap:T_bitmap; aThread:Thread_progress;
								anAdoucir:Type_adoucir);
	  destructor  Destroy; override;
	  function 	  Init_bm:boolean;
	  function 	  Make:boolean;
	  procedure   Soft_9(x,y:integer);
	  procedure   Soft_5(x,y:integer);
	  procedure   Soft_4(x,y:integer);
	  private
		action:TSoft;
		w,h:integer;
		Adoucir:Type_adoucir;
	  end;

implementation

constructor Soft_follow.Create(abitmap:T_bitmap; aThread:Thread_progress;
											anAdoucir:Type_adoucir);
	begin
	bm1:=abitmap;
	Thread_Progress:=aThread;
	Adoucir:=anAdoucir;
	ok:=init_BM;
	if ok then
		begin
		case anAdoucir of
			TA_9:action:=Soft_9;
			TA_5:action:=Soft_5;
			TA_4:action:=Soft_4;
		end; {case}
		w:=bm1.width;
		h:=bm1.height;
		end;
	 end;

destructor Soft_follow.Destroy;
	begin
	 bm2.free;
	inherited;
	 end;

function Soft_follow.init_bm:boolean;
	begin
	 init_bm:=false;
	 bm2:=nil;
	 try
		bm2:=T_Bitmap.create_size(bm1.width,bm1.height);
		init_bm:=true;
	 finally end
	 end;

function Soft_follow.Make:boolean;
	var i,j:integer;
	begin
	 result:=false;
	 if not ok then exit;

	 Thread_Progress.ProgressBar.max:=pred(w);

	 for i:=0 to pred(w) do
		 begin //0

		 if Thread_Progress<>nil then
			begin
			Thread_Progress.Fi:=i;
			Thread_Progress.Set_synchro_progress_bar;
			end;

		for j:=0 to pred(h) do
			begin
			action(i,j);
			end; //1
		end; //0
	result:=true;
	end; {Make}

procedure Soft_follow.Soft_9(x,y:integer);
	 var l:integer;
		 acolor:tcolor;
		 ar,ag,ab:integer;
	begin
	bm1.secure:=true;
	ar:=0;
	ag:=0;
	ab:=0;
	for l:=1 to n_dir do
		begin
		acolor:=bm1.canvas.Pixels[x+k_dir[l].x,y+k_dir[l].y];
		ar:=ar+getrvalue(acolor);
		ag:=ag+getgvalue(acolor);
		ab:=ab+getbvalue(acolor);
		end;

	bm2.canvas.Pixels[x,y]:= rgb(
		round(ar/n_dir),
		round(ag/n_dir),
		round(ab/n_dir));
	end; //Soft_follow.Soft_9

procedure Soft_follow.Soft_5(x,y:integer);
	 var l:integer;
		 acolor:tcolor;
		 ar,ag,ab:integer;
	begin
	bm1.secure:=true;
	ar:=0;
	ag:=0;
	ab:=0;
	for l:=1 to n_dir_simple do
		begin
		acolor:=bm1.canvas.Pixels[x+k_dir_simple[l].x,y+k_dir_simple[l].y];
		ar:=ar+getrvalue(acolor);
		ag:=ag+getgvalue(acolor);
		ab:=ab+getbvalue(acolor);
		end;
	bm2.canvas.Pixels[x,y]:= rgb(
		round(ar/n_dir_simple),
		round(ag/n_dir_simple),
		round(ab/n_dir_simple));
	end; //Soft_follow.Soft_5

 procedure Soft_follow.Soft_4(x,y:integer);
	 var l:integer;
		 acolor:tcolor;
		 ar,ag,ab:integer;
	begin
	bm1.secure:=true;
	ar:=0;
	ag:=0;
	ab:=0;
	for l:=1 to n_dir_mini do
		begin
		acolor:=bm1.canvas.Pixels[x+k_dir_mini[l].x,y+k_dir_mini[l].y];
		ar:=ar+getrvalue(acolor);
		ag:=ag+getgvalue(acolor);
		ab:=ab+getbvalue(acolor);
		end;
	bm2.canvas.Pixels[x,y]:= rgb(
		round(ar/n_dir_mini),
		round(ag/n_dir_mini),
		round(ab/n_dir_mini));
	end; {Soft_follow.Soft_4}

end.
