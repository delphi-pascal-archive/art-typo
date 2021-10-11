unit u_main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons,
  Math, Menus,   							// ajout au standard
  Clipbrd,       							// ajout gestion du presse papier
  U_remplissage, 							// ajout d'une fiche
  U_thread_art_police;		

type

  TForm_main = class(TForm)
    Button1: TButton;
    Edit_text: TEdit;
    Image1: TImage;
    ProgressBar1: TProgressBar;
    Image2: TImage;
    Button_police: TButton;
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    menu_Fichier: TMenuItem;
    menu_Quitter: TMenuItem;
    menu_Option: TMenuItem;
    menu_Police: TMenuItem;
    menu_Aide: TMenuItem;
    menu_Apropos: TMenuItem;
    menu_Edition: TMenuItem;
    menu_Copier: TMenuItem;
    menu_Remplissage: TMenuItem;
    Label_pourcent: TLabel;
    Label_texte: TLabel;
    StatusBar1: TStatusBar;
    Button_remplissage: TButton;
    Image3: TImage;
    SpeedButton_copier: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button_policeClick(Sender: TObject);
    procedure menu_QuitterClick(Sender: TObject);
    procedure menu_PoliceClick(Sender: TObject);
    procedure Edit_textChange(Sender: TObject);
    procedure menu_CopierClick(Sender: TObject);
    procedure Button_remplissageClick(Sender: TObject);
    procedure menu_RemplissageClick(Sender: TObject);
    procedure ThreadDone(Sender: TObject);
    procedure Paint_ombre(Sender: TObject);
    procedure SpeedButton_copierClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure afficher_le_text_en_noir_et_blanc(bool_effacer_couleur:boolean);
    procedure afficher_le_text_en_couleur;
  public
    { Déclarations publiques }
    bool_calcul_is_ok:boolean; // le calcul des distances est bon
    max_distance:T_Sqrt;
    tab_ligne_blanche:T_array_ligne_blanche;
    start_GetTickCount:cardinal;
  end;

var Form_main: TForm_main;

implementation

{$R *.DFM}

procedure TForm_main.FormCreate(Sender: TObject);
 var ax:integer;
 begin
 //initialisation du tableau des tableau des remplissages
 U_remplissage.init_tableau_remplissage_par_default;
 V_tableau_interval := U_remplissage.list_tab_couleur[0];
 V_max_interval     := pred(U_remplissage.List_nbr_etape[0]);
{
 ax:=GetSystemMetrics(SM_CXSCREEN);
 if ax>=1280 then
 	begin
   self.width:=1200;
   Image1.Width:=1184;
   Image1.Left:=5;
   Image3.Left:=1160;
   Edit_text.width:=770;
   self.ProgressBar1.left:=40;
   ProgressBar1.Width:=self.width-ProgressBar1.left-11;
   end
 else if ax>=1024 then
 	begin
   self.width:=980;
   Image1.Width:=964;
   Image1.Left:=5;
   Image3.Left:=940;
   Edit_text.width:=550;
   self.ProgressBar1.left:=40;
   ProgressBar1.Width:=self.width-ProgressBar1.left-11;
   end
 else if ax=640 then
 	begin
   self.width:=620;
   self.Height:=420;
   Image1.Width:=610;
   Image1.Left:=2;
   Image1.top:=36;
   Image1.Height:=320;
	 ProgressBar1.left:=40;
	 ProgressBar1.Top:=359;
	 ProgressBar1.Width:=572;
	 Label_pourcent.top:=360;
	 Edit_text.width:=196;
	 Image3.Left:=582;
	 end;

 Image2.top    := Image1.Top;
 Image2.Height := Image1.Height;
 Image2.Width  := Image1.Width;
 Image2.Left	:= Image1.Left;
}
 FontDialog1.font.height := 105;
 FontDialog1.font.name   := 'Arial';
 FontDialog1.font.style  := [fsBold];
 Label_pourcent.Hide;
 ProgressBar1.Hide;
 Image2.Hide;
 bool_calcul_is_ok:=false;
 end;

procedure TForm_main.Button1Click(Sender: TObject);
 begin
 Self.ProgressBar1.Position:=0;
 Self.Label_pourcent.caption:='';
 Self.Button1.enabled:=false;
 Self.Button_police.enabled:=false;
 Self.Menu_Copier.enabled:=false;
 Self.Menu_Police.enabled:=false;
 Self.SpeedButton_copier.enabled:=false;
 Self.start_GetTickCount:=GetTickCount;
 Self.Afficher_le_text_en_noir_et_blanc(true);
 Self.Afficher_le_text_en_couleur;
 end;

procedure TForm_main.Button_policeClick(Sender: TObject);
 begin
 Self.Menu_PoliceClick(Sender);
 end;

procedure TForm_main.menu_QuitterClick(Sender: TObject);
 begin
 close;
 end;

procedure TForm_main.menu_PoliceClick(Sender: TObject);
 begin
 if FontDialog1.Execute then
   begin
   bool_calcul_is_ok:=false;
   Afficher_le_text_en_noir_et_blanc(false);
   end;
 end;

procedure TForm_main.Edit_textChange(Sender: TObject);
 begin
 bool_calcul_is_ok:=false;
 Afficher_le_text_en_noir_et_blanc(false);
 end;

procedure TForm_main.Button_remplissageClick(Sender: TObject);
 begin
 Self.menu_RemplissageClick(Sender);
 end;


procedure TForm_main.menu_RemplissageClick(Sender: TObject);
 begin
 Form2_remplissage.Show;
 end;

(***********************************************)
(**************** PRIVATE **********************)
(***********************************************)

procedure TForm_main.Afficher_le_text_en_noir_et_blanc(bool_effacer_couleur:boolean);
	var th,tw,ax,ay:integer;
	begin
	 with Image1.canvas do
		begin
		Pen.Color := clWhite;
		Brush.Color := clWhite;
		rectangle(0,0,Image1.Width,Image1.Height);
		font:=FontDialog1.font;
		tw := textwidth(Edit_text.text);
		th := textheight(Edit_text.text);
		ax := (Image1.Width-tw)  div 2;
		ay := (Image1.Height-th) div 2;
		textout(ax,ay, Edit_text.text);
		moveto(0,0);
		lineto(pred(Image1.Width),0);
		lineto(pred(Image1.Width),pred(Image1.Height));
		lineto(0,pred(Image1.Height));
		lineto(0,0);
		end;
   if bool_effacer_couleur then
    	with Image2.canvas do
   		begin
	      Pen.Color := clWhite;
			  Brush.Color := clWhite;
      	rectangle(0,0,Image2.Width,Image2.Height);
      	end;
   Image1.Show;
   Image2.Hide;
   end; {TForm1.Afficher_le_text_en_noir_et_blanc}

procedure TForm_main.Afficher_le_text_en_couleur;
 begin
 if bool_calcul_is_ok then
		ProgressBar1.Max:= Image1.Width
 else
		begin
		ProgressBar1.Max:= Image1.Width*3;
		if Form2_remplissage.CheckBox_ombre.checked then
			ProgressBar1.Max:=ProgressBar1.Max+Image1.Height;
		end;

 ProgressBar1.Show;
 Label_pourcent.Show;
 StatusBar1.Hide;

 {Copier les définitions des couleurs de remplissages actuel}
 V_tableau_interval := U_remplissage.tab_couleur;
 V_max_interval     := pred(U_remplissage.nb_etape);

 with Thread_art_police.Create(TAP_Total,Image1,Image2,
	ProgressBar1,Label_pourcent) do
		OnTerminate := ThreadDone;

 end; //Afficher_le_text_en_couleur


procedure TForm_main.menu_CopierClick(Sender: TObject);
var
	AFormat  : Word;
	AData    : THandle;
	APalette : HPALETTE;
begin
	with Image2 do
	begin
	  Picture.SaveToClipBoardFormat(AFormat,AData,APalette);
	  ClipBoard.SetAsHandle(AFormat,AData);
	end;
end;

procedure TForm_main.ThreadDone(Sender: TObject);
	var TickCount:cardinal;
	begin
   ProgressBar1.Hide;
   Label_pourcent.Hide;
   StatusBar1.Show;
	 TickCount:=GetTickCount - start_GetTickCount;
   StatusBar1.Color:=clBtnFace;
   StatusBar1.SimpleText:=
        ' Temps de calcul '+inttostr(round(TickCount/1000))+
 	' secondes et '+ inttostr(round(frac(TickCount/1000)*1000))+
        ' millisecondes.';
   Self.Button1.enabled:=true;
   Self.Button_police.enabled:=true;
   Self.Menu_Copier.enabled:=true;
   Self.Menu_Police.enabled:=true;
   Self.SpeedButton_copier.enabled:=true;
   end;

procedure TForm_main.Paint_ombre(Sender: TObject);
   begin
   if Form_main.bool_calcul_is_ok then
   	begin
   	with Thread_art_police.Create(TAP_Ombre,Image1,Image2,
      	     ProgressBar1,Label_pourcent) do
 	     	OnTerminate := ThreadDone;
        end;
   end;


procedure TForm_main.SpeedButton_copierClick(Sender: TObject);
   begin
   self.menu_CopierClick(Sender);
   end;

end.

