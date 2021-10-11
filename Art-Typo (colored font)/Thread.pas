unit Thread;

interface

uses Classes,   // ajout pour TThread
		comctrls, // ajout pour TProgressBar
		stdctrls, // ajout pour TLabel
		graphics, // ajout pour Tcolor
		sysutils;

type

 Thread_progress = class(TThread)
	 Fi:integer;
	 ProgressBar:TProgressBar;
	 Label_Pc:TLabel;
	 constructor Create(CreateSuspended:Boolean;
							  aProgressBar:TProgressBar;
							  aLabel:TLabel);
	 procedure Set_progress_bar; {Fi}
	 procedure Set_synchro_progress_bar;
	 end;

implementation

constructor Thread_progress.Create(CreateSuspended:Boolean;
												aProgressBar:TProgressBar;
												aLabel:TLabel);
	begin
	inherited Create(CreateSuspended);
	ProgressBar:=aProgressBar;
	Label_Pc:=aLabel;
	end;

procedure Thread_progress.Set_progress_bar; {Fi}
	begin
	if ProgressBar<>nil then
		begin
		ProgressBar.Position:=Fi;
		if Label_Pc<>nil then
			begin
			Label_Pc.Caption:=inttostr(
				round(100.0*ProgressBar.Position/ProgressBar.Max))+' %';
			Label_Pc.Refresh;
			end;
		end;
	end;

procedure Thread_progress.Set_synchro_progress_bar;
	begin
	Synchronize(Set_progress_bar);
	end;

end.
