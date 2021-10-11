unit u_thread_art_police;

interface

uses
  Classes,  // ajout pour TThread
  Windows,  // ajout pour la macro RGB
  Graphics, // ajout pour les couleurs
  Extctrls, // ajout pour le compossant Image
  Sysutils, // ajout pour inttostr
  comctrls, // ajout pour TProgressBar
  stdctrls, // ajout pour TLabel
  Math,		// ajout pour max
  U_remplissage,
  u_object_sup,
  hls_rvb,
  Thread,
	Smooth,
	Soft;

type T_Sqrt = Single;

const K_blanc=$FFFFFF;
	   K_resolution_max=2800;
	   K_max_T_sqrt:T_Sqrt=k_resolution_max*k_resolution_max;
		K_Precission=10;

type TAP_actif = (TAP_Total,TAP_Ombre);
	  Tarray_sqrt = array[0..k_resolution_max,0..k_resolution_max] of T_Sqrt;
     T_array_ligne_blanche = array[0..k_resolution_max] of boolean;

var V_max_interval:		Integer;
    V_tableau_interval: U_remplissage.T_tab_couleur;
    Tab_distance:			Tarray_sqrt;

type

  Thread_art_police = class(Thread_progress)
  public
    constructor create(anactivite:TAP_actif;
								aImage1,aImage2:Timage;
                     	aProgressBar:TProgressBar;
                        aLabel:TLabel);
  private
    { Déclarations privées }
    activite:TAP_actif;
    Image1,Image2:Timage;
    color:tcolor;
    bm1,bm2:T_Bitmap;
  protected
    procedure Execute; override;
    procedure Inverse_affichage_image1_image2;
    procedure Image1_Update;
    procedure Image2_Update;
    //...Calcul.....................
    procedure Cherche_les_distances;
    procedure Cherche_les_distances_methode_2;
    procedure Calcul_les_couleurs;
    function  Rechercher_le_point_blanc_le_plus_proche(i,j:integer):T_Sqrt;
	  function  Distance(a,b,x,y:integer):T_Sqrt;
    procedure Calcul_de_l_ombre;
  end;

implementation

uses u_main;

{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure Thread_art_police.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end; }


(*****************************************************************************)
{                        Thread_art_police                                    }
(*****************************************************************************)

constructor Thread_art_police.Create( anactivite:TAP_actif;
													aImage1,aImage2:Timage;
													aProgressBar:TProgressBar;
                         					aLabel:TLabel);
	begin
	 activite:=anactivite;
   Self.Image1:=aImage1;
   Self.Image2:=aImage2;
	 inherited Create(False,aProgressBar,aLabel);
   priority:=tpHigher;
   end;

procedure Thread_art_police.Execute;
	var aSF:Smooth_follow;
		 aST:Soft_follow;
		 adoucir:Type_adoucir;
	begin
  	{ Placez le code du thread ici}
	//self.Cherche_les_distances;
	 bm1:=nil;
	 bm2:=nil;
	 try
		bm1:=T_Bitmap.create_from_image(image1);
		bm2:=T_Bitmap.create_from_image(image2);
		 case activite of
			TAP_Total:
				begin
				if false then self.Cherche_les_distances_methode_2;
        Cherche_les_distances;
				Synchronize(Inverse_affichage_image1_image2);
        self.Calcul_les_couleurs;
				self.Calcul_de_l_ombre;
				Form_main.bool_calcul_is_ok:=true;
				end;
			 TAP_Ombre:
				begin
				 self.Calcul_de_l_ombre;
				 end;
			 end; {case}

		if true then bm2.Copy_to_image(Image2);

//AUGMENTER
	 if Form2_remplissage.CheckBox_augmenter_bord.Checked then
		 begin
		 aSF:=Smooth_follow.create(bm2,self);
		 if aSF.make(k_blanc,
			 StrToInt(Form2_remplissage.Edit_augmenter_bord.Text)) then
				aSF.bm2.Copy_to_image(Image2);
		 aSF.free;
		 end;

//ADOUCIR
	 if Form2_remplissage.CheckBox_adoucir.checked then
		begin
		adoucir:=TA_9;
		if Form2_remplissage.CheckBox_adoucir_simple.checked then
			adoucir:=TA_5
		else if Form2_remplissage.CheckBox_adoucir_mini.checked then
			adoucir:=TA_4;

		bm2.free;
		bm2:=T_Bitmap.create_from_image(image2);

		aST:=Soft_follow.create(bm2,self,adoucir);
		if aST.make then
			aST.bm2.Copy_to_image(Image2);
		aST.free;
		end;
	 
   finally
    bm2.free;
   	bm1.free;
   	end;
	end;

procedure Thread_art_police.Inverse_affichage_image1_Image2;
	begin
  Image1.Hide;
 	Image2.Show;
  end;

procedure Thread_art_police.Image1_Update;
	begin
   Image1.Update;
   end;

procedure Thread_art_police.Image2_Update;
	begin
	 Image2.Update;
   end;

procedure Thread_art_police.Cherche_les_distances;
	var i,j:integer;
       distance:T_Sqrt;
	begin
	 if form_main.bool_calcul_is_ok then exit;

	 Form_main.max_distance:=0;
 	{rechercher la distance maxi de ces caractères}
 	for i:=0 to pred(Image1.Width) do
 		begin
      Fi:=i;
		 form_main.tab_ligne_blanche[i]:=true;
      Synchronize(Set_progress_bar);
   	{ rechercher la distance maximum }
      Image1.canvas.Lock;
      Image2.canvas.Lock;
 		for j:=0 to pred(Image1.Height) do
   		begin
         if bm1.Get_pixel(i,j)<>k_blanc then
         //if Image1.canvas.Pixels[i,j]<>K_blanc then
      		begin
				  Form_main.tab_ligne_blanche[i]:=false;
         	distance:=Rechercher_le_point_blanc_le_plus_proche(i,j);
         	tab_distance[i,j]:=distance;
         	if distance > Form_main.max_distance then
					Form_main.max_distance := distance;
          bm1.Set_pixel(i,j,clBlue);
				  bm2.Set_pixel(i,j,clBlue);
         	end
      	else
         	tab_distance[i,j]:=0.0;
      	end; //for j
      Image1.canvas.UnLock;
      Image2.canvas.UnLock;
   	Synchronize(Image1_Update);
   	end; //for i
	end;

procedure Thread_art_police.Cherche_les_distances_methode_2;
	var i,j,nb_point,nb_index:integer;
   	 tab_point:array of tpoint;
       tab_index:array of tpoint;
       dist,min_dist:T_Sqrt;
       bool_ligne_blanche:boolean;

   procedure ajoute_point;
   	begin
    if succ(nb_point)=length(tab_point) then
      setlength(tab_point,length(tab_point)*2);
    inc(nb_point);
		with tab_point[nb_point] do
      begin x:=i; y:=j; end;
    end;

   procedure rechercher_distance_mini;
   	var da,db:integer;
      	 ind1,ind2,k:integer;

      procedure rechercher_index;
      	var k:integer;
         begin
         for k:=0 to nb_index do
            if i<tab_index[k].x then
            	begin
               if k>0 then
               	ind1:=max(0,pred(tab_index[pred(k)].y));
               ind2:=tab_index[k].y;
               exit;
         		end;
         end;

      begin
      ind1:=0; ind2:=nb_point;
      if nb_index>0 then rechercher_index;

      for k:=ind1 to ind2 do
      	begin
         with tab_point[k] do
         	begin
          if true then
            dist:=distance(i,j,x,y)
          else
            begin
				    da:=i-x;
				    db:=j-y;
				    dist:=da*da+db*db;
            end;
          if dist<min_dist then
         	  min_dist:=dist;
			    if min_dist=1 then
         	  exit;
         end;
        end;
      min_dist:=sqrt(min_dist);
      end;

   procedure chercher_affecter_index_point;
   	var k:integer;
      begin
      inc(nb_index);
      tab_index[nb_index].x:=i;
      for k:=0 to nb_point do
         if tab_point[k].x>i then
         	begin
            tab_index[nb_index].y:=k;
            exit;
         	end;
      tab_index[nb_index].y:=nb_point;
      end;

	begin
  nb_point:=-1;
	setlength(tab_point,100);
	if form_main.bool_calcul_is_ok then exit;
  Form_main.max_distance:=0;
 	{rechercher la distance maxi de ces caractères}
 	for i:=1 to Image1.Width-2 do
 		begin
    Fi:=i; Synchronize(Set_progress_bar);
    form_main.tab_ligne_blanche[i]:=true;
		{ rechercher la distance maximum }
 		for j:=1 to Image1.Height-2 do
   		begin
         if bm1.Is_blanc(i,j) then
      		begin
            tab_distance[i,j]:=0.0;
            if not bm1.Is_blanc(i,succ(j)) then
            	ajoute_point //i,j
            //else if Image1.canvas.Pixels[i,pred(j)]<>clWhite then
            else if not bm1.Is_blanc(i,pred(j)) then
            	ajoute_point //i,j
            else if not bm1.Is_blanc(succ(i),j) then
            	ajoute_point //i,j
            //else if Image1.canvas.Pixels[pred(i),j]<>clWhite then
            else if not bm1.Is_blanc(pred(i),j) then
            	ajoute_point //i,j
         	end
      	else
         	begin
            tab_distance[i,j]:=1e10;
				    form_main.tab_ligne_blanche[i]:=false;
            bm1.Set_Pixel(i,j,$000080);
            bm2.Set_Pixel(i,j,$0000FF);
            end;
      	end; //for j
   	end; //for i

   bm1.Copy_to_image(Image1);
   bm2.Copy_to_image(Image2);

	 //2ème passage chercher les indexs
   nb_index:=-1;
   setlength(tab_index,Image1.Width);
   bool_ligne_blanche:=true;
   for i:=1 to Image1.Width-2 do
   	begin
		if form_main.tab_ligne_blanche[i] and
			 form_main.tab_ligne_blanche[succ(i)] then
      	begin
         if not bool_ligne_blanche then
         	chercher_affecter_index_point;
         bool_ligne_blanche:=true;
         end
      else
      	begin
      	bool_ligne_blanche:=false;
         end;
      end;

  	//3ème passage
   for i:=1 to Image1.Width-2 do
 		begin
      Fi:=Image1.Width+i; Synchronize(Set_progress_bar);
		 if not form_main.tab_ligne_blanche[i] then
      	begin
	   	{ rechercher la distance minimum & maximum }
	 		for j:=1 to Image1.Height-2 do
         	if tab_distance[i,j]<>0 then
            begin //point noir
            min_dist:=1e10;
					  rechercher_distance_mini;
            tab_distance[i,j]:=min_dist;
					  if min_dist > Form_main.max_distance then
              Form_main.max_distance := min_dist;
            end; //point noir
      	end; //not ligne_blanche
      end; //for i
   end;

procedure Thread_art_police.Calcul_les_couleurs;
	var i,j:integer;
   	 ecart,ecart_suivant,lim_inf,lim_max:integer;
 	  	 pourcent,multic:T_Sqrt;
	begin
   for i:=0 to pred(Image1.Width) do
 		begin
		if Form_main.bool_calcul_is_ok then Fi:=i else Fi:=Image1.Width*2+i;
		Synchronize(Set_progress_bar);
		Image1.canvas.Lock;
		Image2.canvas.Lock;
    //Traiter cette ligne ?
		if not Form_main.tab_ligne_blanche[i] then
 			for j:=0 to pred(Image1.Height) do
         	begin //j
            if Image1.canvas.Pixels[i,j]<>K_blanc then
   	   		    begin //<>K_blanc
	      	    //Calcul couleur
					    pourcent:=round(100*tab_distance[i,j]/Form_main.max_distance);
	   	        ecart:=max(0,min(V_max_interval,trunc(V_max_interval*pourcent/100)));
   	   	      ecart_suivant:=succ(ecart);
					    lim_inf:=round(100*ecart        /V_max_interval);
	         	  lim_max:=round(100*ecart_suivant/V_max_interval);
		          multic:=100*(pourcent-lim_inf)/(lim_max-lim_inf);

	   	        if multic = 0.0 then
               	Self.color:=rgb(
							    GetRValue(V_tableau_interval[ecart]),
            			GetGValue(V_tableau_interval[ecart]),
							    GetBValue(V_tableau_interval[ecart]))
	         	  else
		            Self.color:=rgb(
							    min(255,round((  GetRValue(V_tableau_interval[ecart_suivant]) -
      		   			  GetRValue(V_tableau_interval[ecart])) * multic / 100 +
         		         GetRValue(V_tableau_interval[ecart]))),

               		min(255,round((  GetGValue(V_tableau_interval[ecart_suivant]) -
              				GetGValue(V_tableau_interval[ecart])) * multic / 100 +
                     	GetGValue(V_tableau_interval[ecart]))),

	               	min(255,round((  GetBValue(V_tableau_interval[ecart_suivant]) -
   	           			GetBValue(V_tableau_interval[ecart])) * multic / 100 +
      	               GetBValue(V_tableau_interval[ecart]))));
              {Image2.canvas.Pixels[i,j]:=Self.color;}
              bm2.Set_Pixel(i,j,Self.color);
         		end; //<>K_blanc
          end; //for j
      Image1.canvas.UnLock;
      Image2.canvas.UnLock;
      Synchronize(Image2_Update);
 		end; // for i
   {bm2.Image_to_BMP(image2);}
	 end; //Calcul_les_couleurs;


// Recherche en agrandissant un rectangle autour du point concerné.
function Thread_art_police.Rechercher_le_point_blanc_le_plus_proche(i,j:integer):T_Sqrt;
 var max,decal,x,xx,y,yy,count,start_decal:integer;
 	  min_dist,dist:T_Sqrt;
 begin
 min_dist := K_max_T_sqrt;
 max:=Math.max(Image1.Height,Image2.Width);
 count:=0;
 start_decal:=1;
 if (i<>0) and (tab_distance[pred(i),j]<>0.0) then
 	start_decal:=math.max(1,round(tab_distance[pred(i),j]-K_Precission));
 for decal:=start_decal to max do
 	begin //decal
   y :=j-decal;
   yy:=j+decal;
   for x:=i-decal to i+decal do
   	  begin //x
      // la ligne haute
   	  if bm1.Is_Blanc(x,y) then
      	begin
			  Dist:=Distance(i,j,x,y);
        if Dist<min_dist then
         	min_dist:=Dist;
        end;

      //la ligne basse
      if bm1.Is_Blanc(x,yy) then
			  begin
			  Dist:=Distance(i,j,x,yy);
        if Dist<min_dist then
          min_dist:=Dist;
        end;
      end; //x

   x :=i-decal;
   xx:=i+decal;
   for y:=j-decal to j+decal do
   	  begin //y
      // la ligne droite
   	  if bm1.Is_Blanc(x,y) then
      	begin
			  Dist:=Distance(i,j,x,y);
        if Dist<min_dist then
         	min_dist:=Dist;
        end;

      //la ligne gauche
      if bm1.Is_Blanc(xx,y) then
      	begin
			  Dist:=Distance(i,j,xx,y);
        if Dist<min_dist then
          min_dist:=Dist;
        end;
      end; //y

   if min_dist <> K_max_T_sqrt then
      begin
		  inc(count);
      if count>=K_Precission then
			  begin
			  result:=min_dist;
			  exit;
			  end;
		  end;
	 end; //decal
	 result:=1.0;
 end; //Rechercher_le_point_blanc_le_plus_proche

function Thread_art_police.distance(a,b,x,y:integer):T_Sqrt;
	var da,db:integer;
	begin
	da:=a-x;
  db:=b-y;
	result:=sqrt(da*da+db*db);
	end;

procedure Thread_art_police.Calcul_de_l_ombre;
	 var i,j,dx,dy,px,py,ax,ay,bx,by,intensite,distance,e:integer;
       rdist,rangle,rintens1,rintens2:single;
       acolor,bcolor:tcolor;
		  hue,lum,sat,lumi,alum:real;
		  Pcolor:^tcolor;
	 begin
	 if not Form2_remplissage.CheckBox_ombre.checked then exit;
   i:=0;
	 val(Form2_remplissage.Edit_ombre_distance.text,distance,E);
	 if e<>0 then
		distance:=1 else distance:=min(100,max(1,distance));

	 val(Form2_remplissage.Edit_ombre_intensite.text,intensite,E);
	 if e<>0 then
		intensite:=50 else intensite:=min(100,max(1,intensite));

	 rdist:=distance;
	 rangle:=Form2_remplissage.ombre_direction*pi/180.0;
	 rintens1:=intensite/100;
	 rintens2:=1-rintens1;

	 bcolor:=Form2_remplissage.color_ombre;
	 hls_rvb.tcolorref_to_hls(bcolor,hue,lum,sat);

	 dx:=round(cos(rangle)*rdist);
	 dy:=round(sin(rangle)*rdist);
	 for j:=0 to pred(Image1.Height) do
		begin
		Fi:=Image1.Width*3+i;
		Synchronize(Set_progress_bar);
		Pcolor:=bm1.ScanLine(j);
		for i:=0 to pred(Image1.Width) do
			begin //i
			 acolor:=Pcolor^;
			 inc(Pcolor);
			 if (acolor and k_blanc)=k_blanc then
				begin //=K_blanc
				 px:=i-dx;
				 if (px>=0) and (px<Image1.Width) then
					begin
					 py:=j-dy;
					 if (py>=0) and (py<Image1.Height) then
						 begin
						 if bm1.Get_pixel(px,py)<>k_blanc then
							begin

							if Form2_remplissage.CheckBox_ombre_arrondir.checked then
								begin
								ax:=px+dx div 2; ay:=py+dy div 2;
								bx:=px+dx div 2; by:=py+dy div 2;
								if (ax<0) or (ax>=Image1.Width)  or
									(ay<0) or (ay>=Image1.Height) or
									(bx<0) or (bx>=Image1.Width)  or
									(by<0) or (by>=Image1.Height) then continue;

								if	not ( (bm1.Get_pixel(ax,ay)=k_blanc) and
									  (bm1.Get_pixel(bx,by)=k_blanc) ) then continue;
								end;

							acolor:=bm2.Get_pixel(px,py);

							if not Form2_remplissage.CheckBox_ombre_combi.checked then
								begin
								lumi:=hls_rvb.get_lumiere_from_tcolor(acolor);
								alum:=lum*rintens1+lumi*rintens2;
								acolor:=hls_rvb.Get_HLS_RGB(hue,alum,sat);
								end
							else
								acolor:=hls_rvb.Get_HLS_RGB(
									max(0,min(255,round( (getRvalue(acolor)*rintens2+
																 getRvalue(bcolor)*rintens1)))),
									max(0,min(255,round( (getGvalue(acolor)*rintens2+
																 getGvalue(bcolor)*rintens1)))),
									max(0,min(255,round( (getBvalue(acolor)*rintens2+
																 getBvalue(bcolor)*rintens1)))));

							 bm2.Set_Pixel(i,j,acolor);
							 end;
						 end;
					 end;
				 end;
			 end; //for i
		end; //for j
   end; //Calcul_de_l_ombre

end.
