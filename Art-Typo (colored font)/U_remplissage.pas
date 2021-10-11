unit U_remplissage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,
  Math, ExtCtrls,
  u_math;

const k_lancer_le_calcul = 'Appuyer sur le bouton : Lancer le calcul';
      ks_Filtre = 'Filtre';

type T_tab_couleur = array [0..5] of Tcolor;

var nb_etape:integer;
	  tab_couleur : T_tab_couleur = (clYellow,clRed,clBlue,clGreen,clFuchsia,clTeal);
	  copy_tab_couleur : T_tab_couleur;
    list_tab_couleur : array of T_tab_couleur;
	  List_nbr_etape   : array of integer;

type
  TForm2_remplissage = class(TForm)
    Button1: TButton;
	  PageControl1: TPageControl;
	  TabSheet1: TTabSheet;
    UpDown1: TUpDown;
    Label_nb_couleur: TLabel;
    Edit_nb_couleur: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    ColorDialog1: TColorDialog;
    Image_preview: TImage;
    Label_color_hexa: TLabel;
    TabSheet2: TTabSheet;
    ListBox1: TListBox;
    Edit_hexa_color: TEdit;
    Timer1: TTimer;
    TabSheet3: TTabSheet;
    TabSheet_ombre: TTabSheet;
    Image_lum_position: TImage;
    Label_ombre_distance: TLabel;
    Edit_ombre_distance: TEdit;
    Label_ombre_couleur: TLabel;
	  Label_ombre_attenuation: TLabel;
	  Image_Ombre_couleur: TImage;
	  Edit_ombre_intensite: TEdit;
    Label_ombre_pixel: TLabel;
    Label_ombre_pourcent: TLabel;
    Label_lum_position: TLabel;
    Label_lum_intensite: TLabel;
    Edit_lum_coef: TEdit;
    Label_lum_coef_pourcent: TLabel;
    UpDown2: TUpDown;
    Image_lum_couleur: TImage;
    Label_lum_couleur: TLabel;
    Image_ombre_direction: TImage;
    Label_ombre_direction: TLabel;
    CheckBox_ombre: TCheckBox;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    Button2: TButton;
    CheckBox_lumiere: TCheckBox;
    CheckBox_ombre_combi: TCheckBox;
    TabSheet_Filtre: TTabSheet;
    CheckBox_ombre_arrondir: TCheckBox;
    CheckBox_augmenter_bord: TCheckBox;
    Edit_augmenter_bord: TEdit;
	  Label_augmenter_bord: TLabel;
	  CheckBox_adoucir: TCheckBox;
	  CheckBox_Adoucir_Simple: TCheckBox;
    CheckBox_adoucir_mini: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
	  procedure Image6Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image5MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image6MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image_previewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure TabSheet1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image_previewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image3DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image4DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image5DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image6DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image2EndDrag(Sender, Target: TObject; X, Y: Integer);
	  procedure Image3EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image4EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image5EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image6EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image_previewEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TabSheet_ombreShow(Sender: TObject);
    procedure Image_ombre_directionMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Edit_ombre_intensiteChange(Sender: TObject);
    procedure Image_Ombre_couleurClick(Sender: TObject);
    procedure CheckBox_ombreClick(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure Image_lum_positionMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image_lum_positionMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image_lum_positionMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure Image_lum_couleurClick(Sender: TObject);
	  procedure CheckBox_lumiereClick(Sender: TObject);
    procedure CheckBox_augmenter_bordClick(Sender: TObject);
    procedure CheckBox_adoucirClick(Sender: TObject);
    procedure CheckBox_adoucir_miniClick(Sender: TObject);
    procedure CheckBox_Adoucir_SimpleClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure Colorier_bouton_image;
    procedure Dessine_une_image(var image:Timage; index:integer);
    procedure Choose_une_couleur(index:integer);

	 procedure Affiche_preview;
    procedure Affiche_preview_Canvas(Const acanvas:Tcanvas;
										awidth,aheight,nb_interval:integer;
                              aClientRect: TRect;
                              show_cadre_blanc:boolean);

    procedure Decode_couleur(index:integer);
    procedure Affiche_code_hexa(acolor:Tcolor);
    procedure Drag_from(i:integer;Target: TObject);
    procedure Paint_Image_ombre_direction;
    function  Calcul_rayon_image_direction:integer;
    procedure Deplacer_la_lumiere(X,Y: Integer);
  public
    { Déclarations publiques }
    color_draw_preview:tcolor; //la couleur de drag'n drop de la preview
    color_ombre:tcolor;
    ombre_direction:integer;
    abm_lumiere:tbitmap;
    lum_pos_mouse_down:boolean;
    lum_pos:tpoint;
    lum_color:tcolor;
  end;

procedure init_tableau_remplissage_par_default;

var Form2_remplissage: TForm2_remplissage;

implementation

{$R *.DFM}
{$R lumiere}

uses u_main;

(************** Start of dialogue function *************)

Procedure TForm2_remplissage.FormCreate(Sender: TObject);
 var i:integer;
 begin
 nb_etape:=2;

 //gestion de la lumière
 lum_pos.X:=10;
 lum_pos.Y:=10;
 lum_color:=clYellow;
 abm_lumiere:=TBitmap.Create;
 abm_lumiere.LoadFromResourceName(HInstance,'LUMIERE');

 //abm_lumiere.LoadFromFile('C:\Program Files\Projects\colored_font\lumiere.bmp');

 //gestion de l'ombre
 color_ombre:=$4040DD;
 ombre_direction:=45;
 CheckBox_ombreClick(Sender);
 PageControl1.ActivePageIndex:=0;

 Label_color_hexa.Hide;
 Edit_hexa_color.Hide;
 Edit_nb_couleur.text:='2';
 UpDown1.position:=2;
 UpDown1.max:=6;
 UpDown1.min:=2;
 Colorier_bouton_image;
 ColorDialog1.CustomColors.Add('colorA=A0A0A0');
 ColorDialog1.CustomColors.Add('colorB=B0B0B0');
 ColorDialog1.CustomColors.Add('colorC=C0C0C0');
 ColorDialog1.CustomColors.Add('colorD=D0D0D0');
 ColorDialog1.CustomColors.Add('colorE=E0E0E0');
 ColorDialog1.CustomColors.Add('colorF=C1C1FF'); //super rose
 ColorDialog1.CustomColors.Add('colorG=8080ff'); //rouge clair

 // min pour éviter les erreurs entre la longeur des couleur et le nb d'étapes
 for i:=1 to min(length(list_tab_couleur),length(list_nbr_etape)) do
 	ListBox1.Items.Add(inttostr(i));

 Edit_augmenter_bord.Visible := CheckBox_augmenter_bord.Checked;
 Label_augmenter_bord.Visible := CheckBox_augmenter_bord.Checked;

 end;

procedure TForm2_remplissage.FormDestroy(Sender: TObject);
begin
abm_lumiere.free;
inherited;
end;

procedure init_tableau_remplissage_par_default;
 begin
 setLength(list_tab_couleur,12);
 setLength(list_nbr_etape,12);

 //1
 List_nbr_etape[0]:=3;
 list_tab_couleur[0][0] := clBlack;
 list_tab_couleur[0][1] := clYellow;
 list_tab_couleur[0][2] := clBlue;
 //2
 List_nbr_etape[1]:=3;
 list_tab_couleur[1][0] := clGreen;
 list_tab_couleur[1][1] := clYellow;
 list_tab_couleur[1][2] := clGreen;
 //3
 List_nbr_etape[2]:=5;
 list_tab_couleur[2][0] := clRed;
 list_tab_couleur[2][1] := clYellow;
 list_tab_couleur[2][2] := clRed;
 list_tab_couleur[2][3] := clYellow;
 list_tab_couleur[2][4] := clRed;
 //4
 List_nbr_etape[3]:=5;
 list_tab_couleur[3][0] := $808080;
 list_tab_couleur[3][1] := clYellow;
 list_tab_couleur[3][2] := clRed;
 list_tab_couleur[3][3] := clYellow;
 list_tab_couleur[3][4] := $808080;
 //5
 List_nbr_etape[4]:=3;
 list_tab_couleur[4][0] := $2888CC;
 list_tab_couleur[4][1] := clWhite;
 list_tab_couleur[4][2] := $D0A000;
 //6
 List_nbr_etape[5]:=5;
 list_tab_couleur[5][0] := $98461A;
 list_tab_couleur[5][1] := $FBD8C5;
 list_tab_couleur[5][2] := $CEAB9C;
 list_tab_couleur[5][3] := $6C2E16;
 list_tab_couleur[5][4] := $EFDBCD;
 //7
 List_nbr_etape[6]:=5;
 list_tab_couleur[6][0] := $1A4698;
 list_tab_couleur[6][1] := $C5D8FB;
 list_tab_couleur[6][2] := $9CABCE;
 list_tab_couleur[6][3] := $162E6C;
 list_tab_couleur[6][4] := $CDDBEF;
 //8
 List_nbr_etape[7]:=5;
 list_tab_couleur[7][0] := $A8A8D8;
 list_tab_couleur[7][1] := $000080;
 list_tab_couleur[7][2] := $D5D5EF;
 list_tab_couleur[7][3] := $C1C1FF; //super rose
 list_tab_couleur[7][4] := $000080;
 //9
 List_nbr_etape[8]:=6;
 list_tab_couleur[8][0] := clRed;
 list_tab_couleur[8][1] := clYellow;
 list_tab_couleur[8][2] := clGreen;
 list_tab_couleur[8][3] := clAqua;
 list_tab_couleur[8][4] := clFuchsia;
 list_tab_couleur[8][5] := clBlue;
 //10
 List_nbr_etape[9]:=5;
 list_tab_couleur[9][0] := clWhite;
 list_tab_couleur[9][1] := $8080ff;
 list_tab_couleur[9][2] := clWhite;
 list_tab_couleur[9][3] := $8080ff;
 list_tab_couleur[9][4] := clWhite;
 //11
 List_nbr_etape[10]:=3;
 list_tab_couleur[10][0] := clAqua;
 list_tab_couleur[10][1] := clFuchsia;
 list_tab_couleur[10][2] := clYellow;
 //12
 List_nbr_etape[11]:=5;
 list_tab_couleur[11][0] := $C00095;
 list_tab_couleur[11][1] := $447FFF;
 list_tab_couleur[11][2] := clYellow;
 list_tab_couleur[11][3] := $FFFFC0;
 list_tab_couleur[11][4] := $FF8080;
 end;


procedure TForm2_remplissage.UpDown1Click(Sender: TObject; Button: TUDBtnType);
 begin
 Edit_nb_couleur.text:=inttostr(UpDown1.position);
 nb_etape:=UpDown1.position;
 Colorier_bouton_image;
 end;

procedure TForm2_remplissage.Button2Click(Sender: TObject);
 begin
 Close;
 end;

procedure TForm2_remplissage.Button1Click(Sender: TObject);
 begin
 Close;
 end;

procedure TForm2_remplissage.Image1Click(Sender: TObject);
 begin
 Self.Choose_une_couleur(1);
 end;

procedure TForm2_remplissage.Image2Click(Sender: TObject);
 begin
 Self.Choose_une_couleur(2);
 end;

procedure TForm2_remplissage.Image3Click(Sender: TObject);
 begin
 Self.Choose_une_couleur(3);
 end;

procedure TForm2_remplissage.Image4Click(Sender: TObject);
 begin
 Self.Choose_une_couleur(4);
 end;

procedure TForm2_remplissage.Image5Click(Sender: TObject);
 begin
 Self.Choose_une_couleur(5);
 end;

procedure TForm2_remplissage.Image6Click(Sender: TObject);
 begin
 Self.Choose_une_couleur(6);
 end;

procedure TForm2_remplissage.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 Self.Decode_couleur(1);
 end;

procedure TForm2_remplissage.Image2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 Self.Decode_couleur(2);
 end;

procedure TForm2_remplissage.Image3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 Self.Decode_couleur(3);
 end;

procedure TForm2_remplissage.Image4MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
  Self.Decode_couleur(4);
 end;

procedure TForm2_remplissage.Image5MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 Self.Decode_couleur(5);
 end;

procedure TForm2_remplissage.Image6MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 Self.Decode_couleur(6);
 end;


procedure TForm2_remplissage.Image_previewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 Self.Affiche_code_hexa(Image_preview.canvas.Pixels[X,Y]);
 end;

procedure TForm2_remplissage.TabSheet1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
 end;


(***********************************************)
(**************** PRIVATE **********************)
(***********************************************)

procedure TForm2_remplissage.Colorier_bouton_image;
	begin
   IF UpDown1.position<6 then Image6.hide else Image6.show;
   IF UpDown1.position<5 then Image5.hide else Image5.show;
   IF UpDown1.position<4 then Image4.hide else Image4.show;
	 IF UpDown1.position<3 then Image3.hide else Image3.show;

	Self.Dessine_une_image(Image1,1);
   Self.Dessine_une_image(Image2,2);
   Self.Dessine_une_image(Image3,3);
   Self.Dessine_une_image(Image4,4);
   Self.Dessine_une_image(Image5,5);
   Self.Dessine_une_image(Image6,6);
   Self.Affiche_preview;
   end;

procedure TForm2_remplissage.Dessine_une_image(var image:Timage; index:integer);
 begin
 Image.Canvas.Brush.Color:=tab_couleur[pred(index)];
 Image.Canvas.pen.color:=clWhite;
 Image.Canvas.rectangle(Image.Clientrect);
 end;

procedure TForm2_remplissage.Choose_une_couleur(index:integer);
 begin
 ColorDialog1.Color:=tab_couleur[pred(index)];
 if ColorDialog1.execute then
 	begin
	tab_couleur[pred(index)]:= ColorDialog1.Color;
	Colorier_bouton_image;
   end;
 end;

procedure TForm2_remplissage.Affiche_preview;
	begin
   Self.Affiche_preview_Canvas(Image_preview.canvas,
										Image_preview.Width,
                              Image_preview.Height,
                              UpDown1.position,
                              Image_preview.Clientrect,true);
   end; {Affiche_preview}

 procedure TForm2_remplissage.Affiche_preview_Canvas(const acanvas:Tcanvas;
										awidth,aheight,nb_interval:integer;
                              aClientRect: TRect;
                              show_cadre_blanc:boolean);

 var i,max_interval,ecart,ecart_suivant,lim_inf,lim_max:integer;
     pourcent,multic:Single;
	begin
   with acanvas do
   	begin
      for i:=0 to aWidth do
      	begin
         pourcent:=round(100*i/aWidth);
         max_interval:=pred(nb_interval); //UpDown1.position;
         ecart:=max(0,min(max_interval,trunc(max_interval*pourcent/100)));
         ecart_suivant:=succ(ecart);
         lim_inf:=round(100*ecart        /max_interval);
         lim_max:=round(100*ecart_suivant/max_interval);
         multic:=100*(pourcent-lim_inf)/(lim_max-lim_inf);

         pen.color:=rgb(
					min(255,round((  GetRValue(tab_couleur[ecart_suivant]) -
              				GetRValue(tab_couleur[ecart])) * multic / 100 +
                        GetRValue(tab_couleur[ecart]))),

					 min(255,round((  GetGValue(tab_couleur[ecart_suivant]) -
              				GetGValue(tab_couleur[ecart])) * multic / 100 +
                        GetGValue(tab_couleur[ecart]))),

               min(255,round((  GetBValue(tab_couleur[ecart_suivant]) -
              				GetBValue(tab_couleur[ecart])) * multic / 100 +
                        GetBValue(tab_couleur[ecart]))));

         moveto(aClientRect.left+i,aClientRect.top);
         lineto(aClientRect.left+i,aheight); //Image_preview.height);
      	end; //i
      if show_cadre_blanc then
      	begin
      	Brush.Style:=bsClear;
   		pen.color:=clWhite;
 			rectangle(aClientrect); //Image_preview.Clientrect);
         end;
   	end; //with
   end; {Affiche_preview_Canvas}

procedure TForm2_remplissage.Decode_couleur(index:integer);
 begin
 Self.Affiche_code_hexa(tab_couleur[pred(index)]);
 end;

procedure TForm2_remplissage.Affiche_code_hexa(acolor:Tcolor);
 begin
 Edit_hexa_color.text:=inttohex(GetRValue(acolor),2)+
 							  inttohex(GetGValue(acolor),2)+
                       inttohex(GetBValue(acolor),2);
 Label_color_hexa.show;
 Edit_hexa_color.show;
 end;

procedure TForm2_remplissage.ListBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
 begin
 with (Control as TListBox).Canvas do
	begin
   brush.color:=clWhite;
   FillRect(Rect);
   brush.color:=clBlue;
   pen.style:=psClear;
   if (odSelected in State) then
   	begin
      Polygon([Point(2, rect.top), Point(12, rect.top+10),
		    Point(2, rect.top+20), Point(2, rect.top)]);
      end;
   pen.style:=psSolid;
   end;

 inc(rect.left,20);
 dec(rect.right,24);

 //copy le tableau des définitions des couleurs dans un tampon.
 copy_tab_couleur := tab_couleur;
 tab_couleur := list_tab_couleur[Index mod Length(list_tab_couleur)];

 Self.Affiche_preview_Canvas((Control as TListBox).Canvas,
										Rect.right,
                              Rect.Bottom-2,
                              List_nbr_etape[index mod Length(List_nbr_etape)],
										 Rect,false);

 //remplace le tableau des définitions des couleurs par le tampon.
 tab_couleur:=copy_tab_couleur;
end;

procedure TForm2_remplissage.ListBox1Click(Sender: TObject);
begin
if ListBox1.ItemIndex<0 then exit;
tab_couleur:=list_tab_couleur[ListBox1.ItemIndex mod Length(list_tab_couleur)];
UpDown1.position:=List_nbr_etape[ListBox1.ItemIndex mod Length(List_nbr_etape)];
Edit_nb_couleur.text:=inttostr(UpDown1.position);
nb_etape:=UpDown1.position;
if Form_main.bool_calcul_is_ok then
	begin
	 if Form_main.Button1.enabled then
		Form_main.Button1Click(Sender)
	 else
		begin
		Timer1.enabled:=true;
		 end;
	 end
else
	begin
	 Form_main.StatusBar1.Color:=clyellow;
	 Form_main.StatusBar1.SimpleText:=k_lancer_le_calcul;
	 messagebeep(0); //MB_ICONEXCLAMATION);
	 end;
end;

procedure TForm2_remplissage.PageControl1Change(Sender: TObject);
	begin
	if PageControl1.ActivePageIndex=0 then
		Colorier_bouton_image;
	end;

procedure TForm2_remplissage.Timer1Timer(Sender: TObject);
	begin
	if Form_main.bool_calcul_is_ok then
		begin
		 if Form_main.Button1.enabled then
			begin
			 Form_main.Button1Click(Sender);
			 Timer1.enabled:=false;
			 end;
		 end
	 else
		Timer1.enabled:=false;
	end;

procedure TForm2_remplissage.Image_previewMouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if (Button=mbLeft) or (Button=mbRight) then
	begin
	 Image_preview.BeginDrag(True);
	 self.color_draw_preview:=Image_preview.Canvas.pixels[X,Y];
	 end;
end;

procedure TForm2_remplissage.Image_previewEndDrag(Sender, Target: TObject;
	X, Y: Integer);
begin
Drag_from(-1,Target);
end;

procedure TForm2_remplissage.Image1DragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:= (source = Image_preview) or (source is timage);
end;

procedure TForm2_remplissage.Image2DragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:= (source = Image_preview) or (source is timage);
end;

procedure TForm2_remplissage.Image3DragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:= (source = Image_preview) or (source is timage);
end;

procedure TForm2_remplissage.Image4DragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:= (source = Image_preview) or (source is timage);
end;

procedure TForm2_remplissage.Image5DragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:= (source = Image_preview) or (source is timage);
end;

procedure TForm2_remplissage.Image6DragOver(Sender, Source: TObject; X,
	Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:= (source = Image_preview) or (source is timage);
end;

procedure TForm2_remplissage.Drag_from(i:integer; Target: TObject);
	var acolor:tcolor;
	begin
	if i>=0 then
		acolor:=tab_couleur[i]
	else
		acolor:=Self.color_draw_preview;

	if 	  target = Image1 then tab_couleur[0]:=acolor
	else if target = Image2 then tab_couleur[1]:=acolor
	else if target = Image3 then tab_couleur[2]:=acolor
	else if target = Image4 then tab_couleur[3]:=acolor
	else if target = Image5 then tab_couleur[4]:=acolor
	else if target = Image6 then tab_couleur[5]:=acolor;
	Colorier_bouton_image;
	end;

procedure TForm2_remplissage.Image1EndDrag(Sender, Target: TObject; X,Y: Integer);
	begin
	Drag_from(0,Target);
	end;

procedure TForm2_remplissage.Image2EndDrag(Sender, Target: TObject; X,Y: Integer);
	begin
	Drag_from(1,Target);
	end;

procedure TForm2_remplissage.Image3EndDrag(Sender, Target: TObject; X,Y: Integer);
	begin
	Drag_from(2,Target);
	end;

procedure TForm2_remplissage.Image4EndDrag(Sender, Target: TObject; X,Y: Integer);
	begin
	Drag_from(3,Target);
	end;

procedure TForm2_remplissage.Image5EndDrag(Sender, Target: TObject; X,Y: Integer);
	begin
	Drag_from(4,Target);
	end;

procedure TForm2_remplissage.Image6EndDrag(Sender, Target: TObject; X,Y: Integer);
	begin
	Drag_from(5,Target);
	end;

procedure TForm2_remplissage.Image1MouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	if button=mbright then
		image1.BeginDrag(false,3);
	end;

procedure TForm2_remplissage.Image2MouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	if button=mbright then
		image2.BeginDrag(false,3);
	end;

procedure TForm2_remplissage.Image3MouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	if button=mbright then
		image3.BeginDrag(false,3);
	end;

procedure TForm2_remplissage.Image4MouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	if button=mbright then
		image4.BeginDrag(false,3);
	end;

procedure TForm2_remplissage.Image5MouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	if button=mbright then
		image5.BeginDrag(false,3);
	end;

procedure TForm2_remplissage.Image6MouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	if button=mbright then
		image6.BeginDrag(false,3);
	end;

procedure TForm2_remplissage.Paint_Image_ombre_direction;
	var intensite,rayon,ax,ay,bx,by,E:Integer;
	begin
	 with Image_ombre_direction.canvas do
		begin
		 pen.color:=clWhite;
		 pen.width:=1;
		 pen.style:=psSolid;
		 brush.color:=clSilver;
		 rectangle(Image_ombre_direction.Clientrect);

		 with Image_ombre_direction.Clientrect do
			begin
			 pen.width:=3;
			 pen.color:=clBlack;
			 rayon:=min(right,bottom) div 2-6;
			 dec(rayon,6);
			 moveto(right div 2,bottom div 2);
			 ax:=round(right div 2+cos(ombre_direction*pi/180)*rayon);
			 ay:=round(bottom div 2+sin(ombre_direction*pi/180)*rayon);
			 lineto(ax,ay);
			 bx:=round(right div 2+cos((5+ombre_direction)*pi/180)*(rayon-5));
			 by:=round(bottom div 2+sin((5+ombre_direction)*pi/180)*(rayon-5));
			 lineto(bx,by);
			 lineto(ax,ay);
			 bx:=round(right div 2+cos((-5+ombre_direction)*pi/180)*(rayon-5));
			 by:=round(bottom div 2+sin((-5+ombre_direction)*pi/180)*(rayon-5));
			 lineto(bx,by);
			 pen.width:=1;
			 pen.color:=clWhite;
			 brush.color:=clWhite;
			 ellipse(right div 2-5,bottom div 2-5,right div 2+5,bottom div 2+5);
			 //affichage d'une ligne pour l'intensité
			 Val(Edit_ombre_intensite.text, intensite, E);
			 if E<>0 then
				intensite:=0
			 else
				intensite:=max(0,round(intensite/100*rayon));
			 if intensite<>0 then
				begin
				moveto(right div 2,bottom div 2);
				ax:=round(right div 2+cos(ombre_direction*pi/180)*intensite);
				ay:=round(bottom div 2+sin(ombre_direction*pi/180)*intensite);
				lineto(ax,ay);
				ellipse(ax-1,ay-1,ax+2,ay+2);
				end;
			 end;
		 end;

	 with Image_Ombre_couleur.Canvas do
		begin
		 pen.width:=1;
		 pen.color:=clWhite;
		 brush.color:=self.color_ombre;
		 rectangle(Image_Ombre_couleur.Clientrect);
      end;
   end; //Paint_Image_ombre_direction

procedure TForm2_remplissage.TabSheet_ombreShow(Sender: TObject);
	begin
	Paint_Image_ombre_direction;
	end;

procedure TForm2_remplissage.Image_ombre_directionMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);

	var center:tpoint;
		 dist,rayon:real;

   begin
	with Image_ombre_direction.Clientrect do
		begin
   	center.x:=right div 2;
   	center.y:=bottom div 2;
		 rayon:=Calcul_rayon_image_direction;
   	end;

   ombre_direction:=-round(angle_degree(center.x,center.y,x,y));
   dist:=distance(center.x,center.y,x,y);
   Edit_ombre_intensite.text:=inttostr(min(100,round(dist*100/rayon)));
	Paint_Image_ombre_direction;
	end;

function TForm2_remplissage.Calcul_rayon_image_direction:integer;
	begin
   with Image_ombre_direction.Clientrect do
   	result:=min(right,bottom) div 2-6;
   end;

procedure TForm2_remplissage.Edit_ombre_intensiteChange(Sender: TObject);
	begin
	Paint_Image_ombre_direction;
	end;

procedure TForm2_remplissage.Image_Ombre_couleurClick(Sender: TObject);
	var acolor:tcolor;
        begin
   acolor:=self.color_ombre;
	ColorDialog1.Color:=self.color_ombre;
	if ColorDialog1.execute then
		begin
   	self.color_ombre:=ColorDialog1.Color;
   	self.Paint_Image_ombre_direction;
      if acolor<>self.color_ombre then
      	begin
			 Form_main.Paint_ombre(self);
			 end;
		end;
	end;

procedure TForm2_remplissage.CheckBox_ombreClick(Sender: TObject);
	begin
	Label_ombre_distance.enabled:=CheckBox_ombre.checked;
	Edit_ombre_distance.enabled:=CheckBox_ombre.checked;
	Label_ombre_pixel.enabled:=CheckBox_ombre.checked;
	Label_ombre_attenuation.enabled:=CheckBox_ombre.checked;
	Edit_ombre_intensite.enabled:=CheckBox_ombre.checked;
	Label_ombre_pourcent.enabled:=CheckBox_ombre.checked;
	Label_ombre_couleur.enabled:=CheckBox_ombre.checked;
	Label_ombre_direction.enabled:=CheckBox_ombre.checked;
	CheckBox_ombre_combi.enabled:=CheckBox_ombre.checked;
	if CheckBox_ombre.checked then
		begin
		Image_ombre_direction.show;
		Image_Ombre_couleur.show;
		end
	else
		begin
		Image_ombre_direction.hide;
		Image_Ombre_couleur.hide;
		end;
	end;

procedure TForm2_remplissage.TabSheet3Show(Sender: TObject);
	 begin
	 with Image_lum_couleur.canvas do
		begin
		pen.width:=1;
		pen.color:=clBlack;
		brush.color:=lum_color;
		rectangle(Image_lum_couleur.Clientrect);
		end;

	 with Image_lum_position.canvas do
		begin
		pen.width:=1;
		pen.color:=clBlack;
		brush.color:=clWhite;
		rectangle(Image_lum_position.Clientrect);
		with lum_pos do
			draw(X,Y,abm_lumiere);
		end;
	end;


procedure TForm2_remplissage.Image_lum_positionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	Self.lum_pos_mouse_down:=true;
	Self.deplacer_la_lumiere(X,Y);
end;

procedure TForm2_remplissage.Image_lum_positionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	begin
	Self.lum_pos_mouse_down:=false;
	end;

procedure TForm2_remplissage.Image_lum_positionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
	begin
	Self.deplacer_la_lumiere(X,Y);
	end;

procedure TForm2_remplissage.deplacer_la_lumiere(X,Y: Integer);
	begin
	if lum_pos_mouse_down then
		begin
   	lum_pos.X:=max(1,min(X-abm_lumiere.Width  div 2,
   		Image_lum_position.Width-abm_lumiere.Width-1));
   	lum_pos.Y:=max(1,min(Y-abm_lumiere.Height div 2,
   		Image_lum_position.Height-abm_lumiere.Height-1));
		Self.TabSheet3Show(nil);
   	end;
	end;

procedure TForm2_remplissage.Image_lum_couleurClick(Sender: TObject);
	begin
	ColorDialog1.Color:=lum_color;
 	if ColorDialog1.execute then
 		begin
		Lum_color:=ColorDialog1.Color;
		Self.TabSheet3Show(Sender);
   	end;
	end;

procedure TForm2_remplissage.CheckBox_lumiereClick(Sender: TObject);
	begin
	Label_lum_position.enabled:=CheckBox_lumiere.checked;
	Label_lum_intensite.enabled:=CheckBox_lumiere.checked;
	Edit_lum_coef.enabled:=CheckBox_lumiere.checked;
	Label_lum_coef_pourcent.enabled:=CheckBox_lumiere.checked;
	UpDown2.enabled:=CheckBox_lumiere.checked;
	Image_lum_couleur.visible:=CheckBox_lumiere.checked;
	Label_lum_couleur.enabled:=CheckBox_lumiere.checked;
	Image_lum_position.visible:=CheckBox_lumiere.checked;
	end;

procedure TForm2_remplissage.CheckBox_augmenter_bordClick(Sender: TObject);
begin
Edit_augmenter_bord.Visible := CheckBox_augmenter_bord.Checked;
Label_augmenter_bord.Visible := CheckBox_augmenter_bord.Checked;
end;

procedure TForm2_remplissage.CheckBox_adoucirClick(Sender: TObject);
begin
CheckBox_Adoucir_Simple.Visible := CheckBox_adoucir.Checked;
CheckBox_adoucir_mini.Visible := CheckBox_adoucir.Checked;
end;

procedure TForm2_remplissage.CheckBox_adoucir_miniClick(Sender: TObject);
begin
if CheckBox_adoucir_mini.Checked then
	CheckBox_Adoucir_Simple.checked:=false;
end;

procedure TForm2_remplissage.CheckBox_Adoucir_SimpleClick(Sender: TObject);
begin
if CheckBox_Adoucir_Simple.checked then
	CheckBox_adoucir_mini.Checked:=false;
end;

end.
