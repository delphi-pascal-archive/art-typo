unit uregedit;

{Une unité écrite par denis bertin et réutilisée pour vérifier comment sous vista}
{ce module doit reconnaitre les clés de la base de registre qui été préconiser par microsoft à la place des fichiers Ini}
{Améliorer pour afficher un dialogue avec les icônes des programme associé a une extension par denis bertin 02.04.2010}
{Améliorer pour afficher seulement les icônes associés à la base de registre après l'exportation d'un fichier image
 et Suppr des éléments non associé qui sont rester dans la base de registre. (c) denis bertin. le 07.04.2011}
{Améliorer pour afficher la liste des executables associé à la base de registre avec un rayon bleu le 14.05.2011 by db}
{Améliorer pour utiliser aussi le logiciel Labography quand il est reconnu dans la base de registre auteur du code denis bertin le 20.1.2016}
{Reconnaissance des fichiers SVG du logiciel Inkscape quand il est reconnu dans la base de registre auteur du code denis bertin le 24.1.2016}
{Spécificité aussi du logiciel internet-explorer - l'affichage conditionnelle des guillemets dans l'ouverture des small icone}

interface

uses Windows,Messages,wutil,classes,Registry;

const k_denis_draw = 'denisdraw';

{An unit extracted from wproche for the vincent'preview by denis Bertin 28.08.2008}
{Improve to chose a file association in a dialog box by denis Bertin 29.03.2010}

function  Open_fichier_avec_extension(awindow:hwnd; ext,fichier:pchar):boolean;
procedure Ouvrir_avec_textpad(ma_fenetre:hwnd);

function get_exe_name_avec_extension(ext:pchar):string;
function Get_exe_name_with_denomination(une_denomination:pchar):string;
function get_directory_avec_extension(ext:pchar):string;

function open_processing_auto_cle:string;
procedure lunch_processing_auto_cle(awindow:hwnd; fichier:pchar);

function open_and_enum_key(quel_cle:pchar; stringlist:Classes.TStringlist):integer;

procedure Creer_cette_cle_dans_le_root(nom_cle:string);
function RegCreatekeyRoot(lpAppName,lpKeyName:pchar):boolean;
function RegWritePrivateProfileString(lpAppName,lpKeyName,lpString:pchar):boolean;
function RegWritePrivateProfileIntRoot(lpAppName,lpKeyName:pchar;nValue:integer):boolean;
function RegWritePrivateProfileInt(lpAppName,lpKeyName:pchar;nValue:integer):boolean;
function RegWritePrivateProfileHex(lpAppName,lpKeyName:pchar;nValue:integer):boolean;
function RegGetPrivateProfileStringRoot(lpAppName,lpKeyName,lpDefault,lpReturnedString:pchar; nSize:integer):integer;
function RegGetPrivateProfileString(lpAppName,lpKeyName,lpDefault,lpReturnedString:pchar; nSize:integer):integer;
function RegGetPrivateProfileInt(lpAppName,lpKeyName:pchar; nDefault:integer):integer;
function RegGetPrivateProfileHex(lpAppName,lpKeyName:pchar; nDefault:integer):integer;
function RegGetPrivateProfileIntRoot(lpAppName,lpKeyName:pchar; nDefault:integer):integer;

implementation

uses u_object,forms,sysutils,wproche,utile,ShellAPI,
			k_erreur,wmenuk,utilisation,haide,hls_rvb,g_base;

const k_taille_font_regedit = 32;
			K_Gimp_Usage = 'GIMP';
			K_MSPAINT = 'MSPAINT';
      K_INKSCAPE = 'inkscape';
      K_INTERNET = 'internet';
      K_Labography = 'labography';
			K_Paint_Dot_Net_Usage = 'PAINTDOTNET';
      K_Paint_SHOP_PRO = 'Corel PaintShop Pro';
			K_Adobe_photoshop = 'Adobe Photoshop';
			K_Paint_shop_pro_cinq = 'Psp.exe';
			K_PAINTER = 'PAINTE';
			K_PSP = 'Psp';
			K_circle = 'circle';
      K_Explorer = 'explorer';

function open_fichier_avec_extension(awindow:hwnd; ext,fichier:pchar):boolean;
	var a_jpeg_key,a_prog_key,a_shell_key:HKEY;
      pc_jpeg,pc_prog,pc_remplacer:array[0..1024] of char;
			pc_show_filename_file_associated:pc1024;
			longeur,maxlen_remplacer:integer;
			p,q:pchar;
	begin
	result:=false;
	if RegOpenKey(HKEY_CLASSES_ROOT,ext,a_jpeg_key)=ERROR_SUCCESS then
		begin {ouverture de la clé jpeg}
		longeur:=pred(Sizeof(pc_jpeg));
		if RegQueryValue(a_jpeg_key,nil,pc_jpeg,longeur)=ERROR_SUCCESS then
			begin
			if RegOpenKey(HKEY_CLASSES_ROOT,pc_jpeg,a_prog_key)=ERROR_SUCCESS then
				begin
				if (RegOpenKey(a_prog_key,'shell\edit\command',a_shell_key)=ERROR_SUCCESS)
				or (RegOpenKey(a_prog_key,'shell\open\command',a_shell_key)=ERROR_SUCCESS) then
					begin
					longeur:=pred(Sizeof(pc_prog));
					if RegQueryValue(a_shell_key,nil,pc_prog,longeur)=ERROR_SUCCESS then
						begin
						p:=sysutils.strpos(pc_prog,'.exe');
						if p=nil then p:=sysutils.strpos(pc_prog,'.EXE');
						if p<>nil then
							begin
							 p:=strpos(pc_prog,'%1');
							if p<>nil then
								begin
								maxlen_remplacer:=pred(sizeof(pc_remplacer));
								loadstring(k_erreur.Ask_Voulez_vous_ouvrir_ce_fichier_avec_le_logiciel_associer,pc_show_filename_file_associated,pred(sizeof(pc_show_filename_file_associated)));
								SysUtils.StrLFmt(pc_remplacer,maxlen_remplacer,pchar(@pc_show_filename_file_associated),[pc_jpeg]);
								if k_erreur.MessageBox_PC(awindow,pc_remplacer,MB_YESNO+MB_ICONQUESTION)=IDYES then
									begin
									if awindow<>0 then
										updatewindow(awindow);
									q:=p; dec(q);
									if q^='"' then
										begin
										p^:=#0;
										strcat(strcat(pc_prog,fichier),'"');
										end
									else
										begin
										p^:=#0;
										strcat(strcat(strcat(pc_prog,' "'),fichier),'"');
										end;
									{$ifdef debug}if application.MessageBox(pc_prog,z_open_file.string_previsualisation,MB_YESNO)=IDYES then {$endif debug}
										result:=winexec(pc_prog,sw_show)>=32;
									end
								end
							else
								begin
								maxlen_remplacer:=pred(sizeof(pc_remplacer));
								loadstring(k_erreur.Ask_Voulez_vous_ouvrir_ce_fichier_avec_le_logiciel_associer,pc_show_filename_file_associated,pred(sizeof(pc_show_filename_file_associated)));
								SysUtils.StrLFmt(pc_remplacer,maxlen_remplacer,pchar(@pc_show_filename_file_associated),[pc_jpeg]);
								if k_erreur.MessageBox_PC(awindow,pc_remplacer,MB_YESNO+MB_ICONQUESTION)=IDYES then
									begin
									if awindow<>0 then
										updatewindow(awindow);
									//Exception pour paint shop pro suppr chaine /dde
									p:=strpos(pc_prog,'/dde');
									if p<>nil then
										p^:=#0;
									strcat(strcat(strcat(pc_prog,' "'),fichier),'"');
									{$ifdef debug} if application.MessageBox(pc_prog,z_open_file.string_previsualisation,MB_YESNO)=IDYES then {$endif debug}
										result:=winexec(pc_prog,sw_show)>=32;
									end;
								end;
							end;
						end;
						RegCloseKey(a_shell_key);
					end;
					RegCloseKey(a_prog_key);
					end;
					end;
				RegCloseKey(a_jpeg_key);
			end;  {ouverture de la clé jpeg}
	end; {open_fichier_avec_extension}

function get_exe_name_with_denomination(une_denomination:pchar):string;
	var a_key_runable,a_shell_key_runable:HKEY;
			longeur:integer;
			pc_shell_runable:pc1024;
			pc_application:pc1024;
			p:pchar;
	begin
	result:='';
	strcat(strcat(strcopy(pc_application,'Applications'),'\'),une_denomination);
	if RegOpenKey(HKEY_CLASSES_ROOT,pc_application,a_key_runable)=ERROR_SUCCESS then
		begin {ouverture de la clé}
		if (RegOpenKey(a_key_runable,'shell\edit\command',a_shell_key_runable)=ERROR_SUCCESS)
		or (RegOpenKey(a_key_runable,'shell\open\command',a_shell_key_runable)=ERROR_SUCCESS) then
			begin
			longeur:=pred(Sizeof(pc_shell_runable));
			if RegQueryValue(a_shell_key_runable,nil,pc_shell_runable,longeur)=ERROR_SUCCESS then
				begin
				p:=strpos(pc_shell_runable,' /dde'); if p <> nil then p^:=#0;
				result:=strpas(pc_shell_runable);
				end;
			end;
		end;  {ouverture de la clé}
	end; {get_exe_name_avec_denomination}

function get_exe_name_avec_extension(ext:pchar):string;
	var a_key,a_prog_key,a_shell_key:HKEY;
			pc_cle,pc_prog:array[0..1024] of char;
			longeur:integer;
	begin
	result:='';
	if RegOpenKey(HKEY_CLASSES_ROOT,ext,a_key)=ERROR_SUCCESS then
		begin {ouverture de la clé extension}
		longeur:=pred(Sizeof(pc_cle));
		if RegQueryValue(a_key,nil,pc_cle,longeur)=ERROR_SUCCESS then
			begin
			if RegOpenKey(HKEY_CLASSES_ROOT,pc_cle,a_prog_key)=ERROR_SUCCESS then
				begin
				if (RegOpenKey(a_prog_key,'shell\edit\command',a_shell_key)=ERROR_SUCCESS)
				or (RegOpenKey(a_prog_key,'shell\open\command',a_shell_key)=ERROR_SUCCESS) then
					begin
					longeur:=pred(Sizeof(pc_prog));
					if RegQueryValue(a_shell_key,nil,pc_prog,longeur)=ERROR_SUCCESS then
						begin
						result:=strpas(pc_prog);
						end;
					end;
				end;
			end;
		end; {ouverture de la clé extension}
	end; {get_exe_name_avec_extension}

function get_directory_avec_extension(ext:pchar):string;
	var s_directory:string;
			pc_directory:array[0..1024] of char;
			p:pchar;
	begin
	result:='';
	s_directory:=get_exe_name_avec_extension(ext);
	if s_directory<>'' then
		begin
		strpcopy(pc_directory,s_directory);
		p:=strrscan(pc_directory,'\');
		if p<>nil then
			begin
      inc(p);
			p^:=#0;
      result:=strpas(pc_directory);
      end;
    end;
  end;

procedure Ouvrir_avec_textpad(ma_fenetre:hwnd);
  const k_pc_notepad='NOTEPAD.EXE';
  var a_text_pad_hkey:HKEY;
      bool_textpad_present:boolean;
      pc_textpad:array[0..1024] of char;
      len_pc_textpad:Longint;
      a_shell_key:HKEY;
      pc_nom_temporaire:array[0..1024] of char;
      pc_WindowsDirectory:array[0..1024] of char;
      local_string_lancer_notepad:array[0..1024] of char;
  begin
  if wutil.file_existe(pchar(u_object.global_nom_string_du_code_source)) then
    begin
    Bool_textpad_present:=False;
    if RegOpenKey(HKEY_CLASSES_ROOT,'textpad',a_text_pad_hkey)=ERROR_SUCCESS then
        begin
        if RegOpenKey(a_text_pad_hkey,'shell\open\command',a_shell_key)=ERROR_SUCCESS then
          begin
					len_pc_textpad:=sizeof(pc_textpad);
          if RegQueryValue(a_shell_key,nil,pc_textpad,len_pc_textpad)=ERROR_SUCCESS then
						begin
            bool_textpad_present:=TRUE;
            end;
          end;
				end;

      if bool_textpad_present then
        begin //si textpad présent
        strcat(pc_textpad,#32);
        strpcopy(pc_nom_temporaire,u_object.global_nom_string_du_code_source);
        strcat(pc_textpad,pc_nom_temporaire);
        WinExec(pc_textpad,sw_show);
        end   //si textpad présent
      else
        begin //sinon afficher avec notepad
        GetWindowsDirectory(pc_WindowsDirectory,pred(sizeof(pc_WindowsDirectory)));

        strcopy(local_string_lancer_notepad,pc_WindowsDirectory);
        strcat(local_string_lancer_notepad,'\');
        strcat(local_string_lancer_notepad,k_pc_notepad);
				strcat(local_string_lancer_notepad,#32);
        strcat(local_string_lancer_notepad,strpcopy(pc_nom_temporaire,
          u_object.global_nom_string_du_code_source));
				WinExec(local_string_lancer_notepad,sw_show);
        end;
      end
    else
      k_erreur.MessageBox(ma_fenetre,k_erreur.Tell_Ce_document_na_pas_etait_enregistrer,mb_ok+mb_iconstop); {écrit par denis Bertin}
  end; {ouvrir_avec_textpad}

function open_processing_auto_cle:string; {si cette clé est dans le registre}
  var i:integer;
      a_processing_key:hkey;
      il_longeur:integer;
      pc_processing:array[0..1024] of char;
      ss_processing:string;
      p:pchar;
  begin
	result:='';
  if RegOpenKey(HKEY_CLASSES_ROOT,'pde_auto_file\shell\open\command',a_processing_key)=ERROR_SUCCESS then
    begin {ouverture de la clé processing}
    il_longeur:=sizeof(pc_processing);
    if RegQueryValue(a_processing_key,nil,pc_processing,il_longeur)=ERROR_SUCCESS then
      begin
      p:=strrscan(pc_processing,'\');
			if p<>nil then
        begin
        inc(p);
        p^:=#0;
        {supprimer_les_guillemets}
        ss_processing:='';
        for i:=0 to pred(strlen(pc_processing)) do
          begin
          if pc_processing[i]<>'"' then
            ss_processing:=ss_processing+pc_processing[i];
					end;
				result:=ss_processing;
        end;
      end;
    regclosekey(a_processing_key);
    end;  {ouverture de la clé processing}
  end; {open_processing_auto_cle}

procedure lunch_processing_auto_cle(awindow:hwnd; fichier:pchar); {si cette clé est dans le registre}
  var i:integer;
      a_processing_key:HKEY;
      il_longeur:integer;
			pc_processing:array[0..1024] of char;
      ss_processing:string;
			p:pchar;
  begin
  if RegOpenKey(HKEY_CLASSES_ROOT,'pde_auto_file\shell\open\command',a_processing_key)=ERROR_SUCCESS then
    begin
    il_longeur:=sizeof(pc_processing);
    if RegQueryValue(a_processing_key,nil,pc_processing,il_longeur)=ERROR_SUCCESS then
      begin
      p:=strpos(pc_processing,'%');
      if p<>nil then begin p^:=#0; end;
      ss_processing:='';
      for i:=0 to pred(strlen(pc_processing)) do
        begin
				if pc_processing[i]<>'"' then
          ss_processing:=ss_processing+pc_processing[i];
        end;
      {retranformation en pchar}
      strpcopy(pc_processing,ss_processing);
			strcat(strcat(pc_processing,chr(32)),fichier);
      if k_erreur.MessageBox(awindow,k_erreur.Ask_would_you_like_to_open_processing,MB_YESNO or mb_IconQuestion)=IDYES then
        begin
				{$ifdef debug} box(0,pc_processing); {$endif}
        winexec(pc_processing,sw_show);
        end;
      end;
    RegCloseKey(a_processing_key);
    end;
  end;

function open_and_enum_key(quel_cle:pchar; stringlist:Classes.TStringlist):integer;
	var i,ii,index_cle:integer;
			a_htm_hkey,an_openwith_key,atrouve_key:HKey;
			pc:pc1024;
			len_pc:DWORD;
			lg_chaine:longint;
			lpftLastWriteTime:TFileTime;
			nombre_fichier_trouver,longeur_de_ma_requette:integer;
			nom_long_ds_regedit_cle_ouvir_avec:pc1024;
			pc_acar,pc_resultat_de_ma_requette,pca,ss_compare:pc1024;
			a:real;
			tipe:Dword;
			lpType:PDWORD;
			lpcbData:PDWORD;
			ok_ajouter:boolean;
			string_nom_runable:string;
      s_found:string;
      chaine_paint_net:string;
      begin_guillemet:boolean;
			pc_query_Perceived:pc1024;
      une_taille:integer;
      p,pposo:pchar;
      shear:SysUtils.TSearchRec;
      FileAttrs:Integer;
      chemin_complet_string:string;
      filedir:pc1024;
      chaine_corel:string;
			chaine_adobe:string;
			un_acces:string;
			bool_ajouter:boolean;
	begin
	nombre_fichier_trouver:=0;
  stringlist.add('C:\Windows\explorer.exe');
  inc(nombre_fichier_trouver);
  if (strcomp(quel_cle,wmenuk.point_svg)=0) then
    begin
    strcopy(nom_long_ds_regedit_cle_ouvir_avec,'inkscape.svg\shell\Open\command'); {B denis}
    if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
      if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
        {$ifdef debug}
          box(0,pc);
        {$endif debug}
        stringlist.add(pc);
				inc(nombre_fichier_trouver);
        end;
      end;
    end;
	if (strcomp(quel_cle,wmenuk.point_png)=0)
	or (strcomp(quel_cle,wmenuk.point_bmp)=0)
	or (strcomp(quel_cle,wmenuk.point_jpg)=0)
	or (strcomp(quel_cle,wmenuk.point_gif)=0) then
		begin
    strcopy(nom_long_ds_regedit_cle_ouvir_avec,'CorelDraw.Graphic.18\shell\Open\command'); {B denis}
    if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
      if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug} box(0,pc); {$endif debug}
        pposo:=strpos(pc,' -DDE');
        if pposo<>nil then pposo^:=#0;
        {$ifdef debug} box(0,pc); {$endif debug}
        stringlist.add(pc);
				inc(nombre_fichier_trouver);
        end;
      end;
    strcopy(nom_long_ds_regedit_cle_ouvir_avec,'Labography\shell\Open\command'); {B denis}
    if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
      if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug}
          box(0,pc);
        {$endif debug}
        stringlist.add(pc);
				inc(nombre_fichier_trouver);
        end;
      end;
		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'Photoshop.ActionsFile\shell\Open\command'); {B denis}
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug} box(0,pc); {$endif debug}
				chaine_adobe:='';
				for i:=0 to pred(strlen(pc)) do if pc[i]<>'"' then chaine_adobe:=chaine_adobe+pc[i];
				strpcopy(filedir,chaine_adobe);
				p:=strpos(filedir,' %1'); if p<>nil then p^:=#0;
				stringlist.add(filedir);
				inc(nombre_fichier_trouver);
				end;
			end;
		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'PSP5.Image\shell\Open\command'); {denis B}
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug} box(0,pc); {$endif debug}
				chaine_corel:='';
				for i:=0 to pred(strlen(pc)) do if pc[i]<>'"' then chaine_corel:=chaine_corel+pc[i];
				strpcopy(filedir,chaine_corel);
				p:=strpos(filedir,' %1'); if p<>nil then p^:=#0;
				stringlist.add(filedir);
				inc(nombre_fichier_trouver);
				end;
			end;

		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'PaintShopProX4.Psp\shell\Open\command'); {denis}
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug} box(0,pc); {$endif debug}
				chaine_corel:='';
				for i:=0 to pred(strlen(pc)) do if pc[i]<>'"' then chaine_corel:=chaine_corel+pc[i];
				strpcopy(filedir,chaine_corel);
				p:=strpos(filedir,' %1'); if p<>nil then p^:=#0;
				stringlist.add(filedir);
				inc(nombre_fichier_trouver);
				end;
			end;
		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'Paint.NET.1\shell\open\command');
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug} box(0,pc); {$endif debug}
				chaine_paint_net:='';
				begin_guillemet:=true;
				for i:=1 to pred(strlen(pc)) do
					begin
					if (pc[i]='"') and begin_guillemet then
						begin_guillemet:=false
					else
						if begin_guillemet then
							chaine_paint_net:=chaine_paint_net+pc[i];
					end;
				stringlist.add(chaine_paint_net);
				inc(nombre_fichier_trouver);
				end;
			end;

		Strcopy(nom_long_ds_regedit_cle_ouvir_avec,'AtoView\shell\open\command');
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				{$ifdef debug} box(0,pc); {$endif debug}
				p:=strpos(pc,' "%1"');
				if p<>nil then p^:=#0;
				stringlist.add(pc);
				inc(nombre_fichier_trouver);
				end;
			end;

		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'PainterFile\shell\open\command');
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				stringlist.add(strpas(pc));
				inc(nombre_fichier_trouver);
				end;
			end;
		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'GIMP-2.8-gbr\shell\open\command');
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				stringlist.add(strpas(pc));
				inc(nombre_fichier_trouver);
				end;
			end;
		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'PBrush\shell\edit\command');
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				stringlist.add(strpas(pc));
				inc(nombre_fichier_trouver);
				end;
			end;
		strcopy(nom_long_ds_regedit_cle_ouvir_avec,'GIMP-2.0-gbr\shell\open\command');
		if RegOpenKey(HKEY_CLASSES_ROOT,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
			begin
			lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				begin
				stringlist.add(strpas(pc));
				inc(nombre_fichier_trouver);
				end;
			end;
		end;
	if quel_cle[0]=wutil.kpc_dot then
    begin
		s_found:='';
    for i:=1 to pred(strlen(quel_cle)) do s_found:=s_found+quel_cle[i];
    s_found:=s_found+'file\shell\open\command';
    if RegOpenKey(HKEY_CLASSES_ROOT,pchar(s_found),an_openwith_key)=ERROR_SUCCESS then
      begin
			fillchar(pc,sizeof(pc),#0);
      lg_chaine:=pred(sizeof(pc));
			if RegQueryValue(an_openwith_key,nil,pc,lg_chaine)=ERROR_SUCCESS then
				if strpos(pc,'rundll')=nil then
					stringlist.add(strpas(pc));
      end;
    end;
  if RegOpenKey(HKEY_CLASSES_ROOT,quel_cle,a_htm_hkey)=ERROR_SUCCESS then
    begin
    if RegOpenKey(a_htm_hkey,'shell\open\command',an_openwith_key)=ERROR_SUCCESS then
      begin
      len_pc:=pred(sizeof(pc));
      index_cle:=0;
      while RegEnumKeyEx(an_openwith_key,index_cle,pc,len_pc,nil,nil,nil,@lpftLastWriteTime)=ERROR_SUCCESS do
        begin
        stringlist.add(strpas(pc));
        inc(index_cle);
				len_pc:=pred(sizeof(pc));
        inc(nombre_fichier_trouver);
				end;
      end;
		end;

  if RegOpenKey(HKEY_CLASSES_ROOT,quel_cle,a_htm_hkey)=ERROR_SUCCESS then
    begin
    une_taille:=pred(sizeof(pc_query_Perceived));
    if RegQueryValue(a_htm_hkey,'',pc_query_Perceived,une_taille)=ERROR_SUCCESS then
      begin
      {$ifdef debug} box(0,pc_query_Perceived); {$endif debug}
      end;
    end;

  if RegOpenKey(HKEY_CLASSES_ROOT,quel_cle,a_htm_hkey)=ERROR_SUCCESS then
    begin
    une_taille:=pred(sizeof(pc_query_Perceived));
    RegQueryValue(a_htm_hkey,'',pc_query_Perceived,une_taille);
    {$ifdef debug} box(0,pc_query_Perceived); {$endif debug}
    if RegOpenKey(HKEY_CLASSES_ROOT,pc_query_Perceived,a_htm_hkey)=ERROR_SUCCESS then
			begin
      une_taille:=pred(sizeof(pc_query_Perceived));
			if RegQueryValue(a_htm_hkey,'shell\open\command',pc_query_Perceived,une_taille)=ERROR_SUCCESS then
        begin
        {$ifdef debug} box(0,pc_query_Perceived); {$endif debug}
        p:=strpos(pc_query_Perceived,' /dde');
        if p<>nil then
          p^:=#0;
        if true then
					begin
          FileAttrs := faAnyFile;
          chemin_complet_string:='';
          strcopy(filedir,pc_query_Perceived);
          p:=strscan(filedir,'\');
          inc(p);
          p:=strscan(p,'\');
					p^:=#0;
          if SysUtils.findfirst(filedir,FileAttrs,shear) = 0 then {denis B}
            chemin_complet_string:=chemin_complet_string+shear.Name;
					strcopy(filedir,pc_query_Perceived);
          p:=strscan(filedir,'\');
					inc(p);
          p:=strscan(p,'\');
          inc(p);
          p:=strscan(p,'\');
          if p<>nil then
            begin
            p^:=#0;
            if SysUtils.findfirst(filedir,FileAttrs,shear) = 0 then {denis B}
              begin
              chemin_complet_string:=chemin_complet_string+'\'+shear.Name;
              end;
            end;
            strcopy(filedir,pc_query_Perceived);
            p:=strrscan(filedir,'\');
            inc(p); {denis B}
            chemin_complet_string:='C:\'+chemin_complet_string+'\'+strpas(p);
            if wutil.file_existe(pchar(chemin_complet_string)) then
              begin
              stringlist.add(chemin_complet_string);
						  inc(nombre_fichier_trouver);
              end;
            end;
				//Note de l'auteur qui à dit la vérité 'reconnaissance de la version 5 de paint shop pro
        //qui fait le fait croire... Si tu croix chère amis que je ne connait pas ces fonctions.
				end;
      end;
    end;
  result:=nombre_fichier_trouver;
  Strcat(Strcat(StrCopy(nom_long_ds_regedit_cle_ouvir_avec,'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\'),quel_cle),'\OpenWithList');
  if RegOpenKey(HKEY_CURRENT_USER,nom_long_ds_regedit_cle_ouvir_avec,an_openwith_key)=ERROR_SUCCESS then
    begin {à trouver cette clé-cdb}
    longeur_de_ma_requette:=pred(sizeof(pc_resultat_de_ma_requette));
    tipe:=REG_SZ;
    lpType:=@tipe;
		lpcbData:=@longeur_de_ma_requette;
		Strcopy(pca,'a');
		index_cle:=0;
		while RegQueryValueEx(an_openwith_key,pca,nil,lpType,PByte(@pc_resultat_de_ma_requette),lpcbData)=ERROR_SUCCESS do
			begin
			{$ifdef debug} box(0,pc_resultat_de_ma_requette); {$endif}
			tipe:=REG_SZ;
			lpType:=@tipe;
			longeur_de_ma_requette:=pred(sizeof(pc_resultat_de_ma_requette));
			lpcbData:=@longeur_de_ma_requette;
			pca[0]:=chr(ord('a')+ord(index_cle));
			pca[1]:=#0;
			ok_ajouter:=true;
			string_nom_runable:=Get_exe_name_with_denomination(pc_resultat_de_ma_requette);
			if strpos(pchar(string_nom_runable),wutil.kpc_tild)<>nil then
				begin
				FileAttrs := faAnyFile;
				chemin_complet_string:='';
				strcopy(filedir,pchar(string_nom_runable));
				{$ifdef debug} box(0,pchar(string_nom_runable)); {$endif}
				strcopy(filedir,pchar(string_nom_runable));
				p:=strscan(filedir,'\');
				inc(p);
				p:=strscan(p,'\');
				p^:=#0;
				if SysUtils.findfirst(filedir,FileAttrs,shear) = 0 then {denis B}
					chemin_complet_string:=chemin_complet_string+shear.Name;
				strcopy(filedir,pchar(string_nom_runable));
				p:=strscan(filedir,'\');
				inc(p);
				p:=strscan(p,'\');
				inc(p);
				p:=strscan(p,'\');
				p^:=#0;
				if SysUtils.findfirst(filedir,FileAttrs,shear) = 0 then {denis B}
					begin
					chemin_complet_string:=chemin_complet_string+'\'+shear.Name;
					end;
				strcopy(filedir,pchar(string_nom_runable));
				p:=strrscan(filedir,'\');
				inc(p); {denis B}
				chemin_complet_string:='C:\'+chemin_complet_string+'\'+strpas(p);
				if wutil.file_existe(pchar(chemin_complet_string)) then
					begin
					strpcopy(pc_resultat_de_ma_requette,chemin_complet_string);
					string_nom_runable:=chemin_complet_string;
					end;
				end;
			if length(string_nom_runable)=0 then
				ok_ajouter:=false;
			if ok_ajouter then
				begin
				for i:=0 to pred(stringlist.count) do
          begin
          strpcopy(ss_compare,stringlist.Strings[i]);
          if strcomp(ss_compare,pc_resultat_de_ma_requette)=0 then
            ok_ajouter:=false;
          end; {for i}
				end;
			if ok_ajouter then
				begin
				//Vérifier les doublons
				bool_ajouter:=true;
				for ii:=0 to pred(stringlist.Count) do
					begin
					un_acces:=stringlist.Strings[ii];
					if strpos(pchar(un_acces),pc_resultat_de_ma_requette)<>nil then
						bool_ajouter:=false;
					end;
				if bool_ajouter then
					stringlist.add(strpas(pc_resultat_de_ma_requette));
				end;
			inc(index_cle);
			inc(nombre_fichier_trouver);
      end;
   end;
	result:=nombre_fichier_trouver;
  end; {open_htm_key}

const id_list_exe = 200;
      id_static_nom_fichier = 300;
      id_static_nom_runable = 400;

constructor TD_Open_with.Create(AParent:WBase.TWindow; une_stringList:Classes.TStringlist; my_file_to_open_with:pchar);
	begin
	inherited Create(AParent,'D_OPEN_WITH',0);
	Self.ma_stringList:=une_stringList;
	self.Static_mon_nom_fichier:=Wbase.TStatic.Create(Self,id_static_nom_fichier,0); {hid zorglub}
	self.Static_mon_nom_runable:=Wbase.TStatic.Create(Self,id_static_nom_runable,0); {hid zorglub}
	self.List_exe:=Wbase.TListbox.Create(Self,id_list_exe,100,0); {hid zorglub}
	Strcopy(Self.file_to_open_with,my_file_to_open_with);
	Strcopy(Self.Dir_where_the_file_is,pchar(ExtractFilePath(strpas(my_file_to_open_with))));
	end; {TD_Open_with.Create}

procedure TD_Open_with.setupwindow;
	begin
	inherited Setupwindow;
	Self.Rechercher_les_extensions;
	end;

procedure TD_Open_with.Rechercher_les_extensions;
	const k_pc_dot = '.';
	var i,j:integer;
			p,q:pchar;
			apc_exe_name,
				une_extension_en_majuscule,
					nom_du_runable_juste_exe,
						nom_du_runable_bis,
							nom_du_runable_chemin_complet:pc1024;
			pc_nom_runable:pchar;
			pc_nom_du_fichier_a_rechercher:pc1024;
			s_nom_supplementaire:string;
			nom_de_fichier:string;
			file_without_poucent_one:wutil.pc1024;
			Ppourcent:pchar;
			pc_sans_guillemet:string;
	begin
	self.Static_mon_nom_fichier.SetText(Self.file_to_open_with);
	//recherche les occurances similaires - écrit par denis BERTIN
	i:=0;
	while i<Self.ma_stringList.count do
		begin
		Fillchar(apc_exe_name,pred(sizeof(apc_exe_name)),#0);
		strcopy(apc_exe_name,pchar(Self.ma_stringList.strings[i]));
		nom_de_fichier:=extractfileName(strpas(apc_exe_name));
		j:=succ(i);
		while j<Self.ma_stringList.count do
			begin
			strcopy(pc_nom_du_fichier_a_rechercher,pchar(Self.ma_stringList.strings[j]));
			if strpos(pc_nom_du_fichier_a_rechercher,pchar(nom_de_fichier))<>nil then
				begin
				{$ifdef debug} box(0,pc_nom_du_fichier_a_rechercher); {$endif}
				Self.ma_stringList.delete(j);
				end
			else
				inc(j);
			end;
		inc(i);
		end;
	i:=0;
	while i<Self.ma_stringList.count do
		begin
		strcopy(apc_exe_name,pchar(Self.ma_stringList.strings[i]));
		if strpos(apc_exe_name,'dll')<>nil then
			begin
			Self.ma_stringList.delete(i);
			end;
		apc_exe_name[0]:=UPCase(apc_exe_name[0]);
		getmem(pc_nom_runable,1024);
		strcopy(pc_nom_runable,apc_exe_name);
		if strpos(pc_nom_runable,uregedit.K_Gimp_Usage)<>nil then
			begin
			inc(i);
			self.list_exe.AddString(pc_nom_runable);
			end
		else if strpos(pc_nom_runable,uregedit.K_Paint_Dot_Net_Usage)<>nil then
			begin
			inc(i);
			self.list_exe.AddString(pc_nom_runable);
			end
		else if strpos(pc_nom_runable,uregedit.K_MSPAINT)<>nil then
			begin
			inc(i);
			self.list_exe.AddString(pc_nom_runable);
			end
    else if strpos(pc_nom_runable,'explorer.exe')<>nil then
			begin
			inc(i);
			self.list_exe.AddString(pc_nom_runable);
			end
		else
			begin
			if i<Self.ma_stringList.count then
				begin
				strcopy(nom_du_runable_chemin_complet,pchar(Get_exe_name_with_denomination(pchar(Self.ma_stringList.strings[i]))));
				if strlen(nom_du_runable_chemin_complet)<>0 then
					begin
					inc(i);
					p:=strpos(nom_du_runable_chemin_complet,wmenuk.point_exe);
					if p=nil then
						begin
            strcopy(une_extension_en_majuscule,wmenuk.point_exe);
            StrUpper(une_extension_en_majuscule);
            p:=strpos(nom_du_runable_chemin_complet,une_extension_en_majuscule);
            end;
          if p<>nil then
            begin
            inc(p,4);
						if p^='"' then
              begin
              p^:=#0;
							q:=@nom_du_runable_chemin_complet;
              inc(q);
              strcopy(nom_du_runable_bis,q);
              strcopy(nom_du_runable_chemin_complet,nom_du_runable_bis);
							end;
            p^:=#0;
            if sysutils.FileExists(nom_du_runable_chemin_complet) then
              begin
              inc(i);
              self.list_exe.AddString(pc_nom_runable);
              {$ifdef debug} box(self.hwindow,pc_nom_runable); {$endif}
              end
            else
              Self.ma_stringList.delete(i);
            end
          else
            Self.ma_stringList.delete(i);
          end
        else
          begin
					s_nom_supplementaire:=Self.ma_stringList.strings[i];
					{$ifdef debug} box(0,pchar(s_nom_supplementaire)); {$endif}
					self.list_exe.AddString(pchar(s_nom_supplementaire));
					inc(i);
          end;
        end;
      end;
    end; {while}
  enablewindow(Getitemhandle(id_ok),false);
  end; {TD_Open_with.setupwindow}

procedure TD_Open_with.WMCommand(var Msg: TMessage);
  const id_show_directory = 1004;
  var item_selectionner:integer;
      pc_selectionner:pc1024;
			nom_runable:string;
      apc:pc100;
  begin
  inherited WMCommand(Msg);
	case msg.wparam of
    id_show_directory:
      WinExec(pchar('explorer.exe /select,'+strpas(File_to_open_with)),sw_show);
    end; {case de Vierzon}
  if (Loword(Msg.wparam)=id_list_exe) and (Hiword(Msg.wparam)=LBN_DBLCLK) then
    begin {envoie du message OK}
    postmessage(self.hwindow,wm_command,id_ok,0);
    end; {envoie du message OK}
  if (Loword(Msg.wparam)=id_list_exe) and (Hiword(Msg.wparam)=LBN_SelChange) then
    begin {visualisation de l'executable}
    item_selectionner:=self.list_exe.Getselindex;
    if item_selectionner<>-1 then
      begin
      EnableWindow(Getitemhandle(id_ok),true);
      strpcopy(pc_selectionner,Self.ma_stringList.strings[item_selectionner]);
			if strpos(pc_selectionner,uregedit.K_Gimp_Usage)<>nil then
        begin
        {$ifdef debug}
          self.Static_mon_nom_runable.SetText(pc_selectionner);
        {$endif debug}
        end
      else if strpos(pc_selectionner,uregedit.K_Paint_Dot_Net_Usage)<>nil then
        begin
        {$ifdef debug}
          self.Static_mon_nom_runable.SetText(pc_selectionner);
        {$endif debug}
        end
      else
        begin
        nom_runable:=Get_exe_name_with_denomination(pc_selectionner);
        if length(nom_runable)<>0 then
          begin
          {$ifdef debug}
            self.Static_mon_nom_runable.SetText(pchar(nom_runable));
          {$endif debug}
          end;
        end;
      end;
    end; {visualisation de l'executable}
  end; {TD_Open_with.WMCommand}

procedure	TD_Open_with.call_help_content;
  begin
  haide.aide_context(haide.HelpIdFile_Exp_BMP);
  end;

procedure	TD_Open_with.WMMEASUREITEM(var Msg: TMessage);
  var adc:hdc;
		  tm:ttextmetric;
		  afont:hfont;
	begin
	adc:=getdc(hwindow);
	afont:=selectobject(adc,Wutil.Get_MakeDefaultFont(k_taille_font_regedit));
	gettextmetrics(adc,tm);
	Self.hauteur_item:=tm.tmheight+3;
	deleteobject(selectobject(adc,afont));
	releasedc(hwindow,adc);
	PMEASUREITEMSTRUCT(msg.lparam).itemheight:=Self.hauteur_item;
	msg.result:=1;
  end; {TD_Open_with.WMMEASUREITEM}

procedure TD_Open_with.WMDRAWITEM(var Msg: TMessage);
	var afont:hfont;
	begin
	with PDRAWITEMSTRUCT(msg.lparam)^ do
		begin
		savedc(hdc);
		afont:=selectobject(hdc,Wutil.Get_MakeDefaultFont(k_taille_font_regedit));
		if ((itemaction and oda_drawentire)<>0) or
			((itemaction and oda_select)<>0) then
			begin
			set_text_color(PDRAWITEMSTRUCT(msg.lparam));
			Draw_item(PDRAWITEMSTRUCT(msg.lparam));
			end; {draw}
			draw_focus(PDRAWITEMSTRUCT(msg.lparam));
		deleteobject(selectobject(hdc,afont));
		restoredc(hdc,-1);
		end;
	end; {TD_Open_with.WMDRAWITEM}

procedure TD_Open_with.set_text_color(data:PDRAWITEMSTRUCT);
	begin
	with data^ do
		begin
		if (itemstate and ods_selected)<>0 then
			begin
			settextcolor(hdc,g_base.rgb_rouge);
			end
		else
			begin
			settextcolor(hdc,g_base.rgb_bleu);
			end;
		end;
	end; {TD_Open_with.set_text_color}

procedure TD_Open_with.Draw_item(data:PDRAWITEMSTRUCT);
	const 
				pc_gimp = 'Gimp';
				pc_Paint = 'MsPaint';
        pc_Labography = 'Labography';
        pc_Inkscape = 'Inkscape';
				pc_PAINTER = 'PAINTE';
				pc_PaintDotNet = 'PaintDotNet';
				pc_paint_shop_pro = 'Paint Shop Pro';
				pc_Corel_paint_shop_pro = 'Corel Paint Shop Pro';
				pc_Adobe_photoshop = 'Adobe Photoshop';
				Paint_shop_pro_cinq = 'Paint Shop Pro';
				pc_Corel_painter = 'Corel Painter';
				pc_denis_draw = 'Denis Draw';
				k_pc_point_exe = '.exe';
        pc_exporateur_de_window = 'Explorateur';
        pc_Internet = 'Internet explorer';
	var i,distance_du_millieu:integer;
			local_icone:hicon;
			nom_du_runable:pchar;
			nom_du_runable_juste_exe,
				nom_du_runable_bis,
					une_extension_en_majuscule,
          nom_labography,
          nom_inkscape,
          nom_internet:pc1024;
			p,q:pchar;
			position:integer;
			hue,lum,sat:real;
			apencil:hpen;
			une_couleur:tcolorref;
			lumiere:real;
			chaine_gimp:string;
			bool_ajout,bool_encore:boolean;
			pc_doted_exe:pchar;
			pc_exe_with_out_exe:pc1024;
			pc_nom_temporaire_du_shell:pc1024;
			string_without_guillement:string;
			pc_pour_paint_shop_pro_cinq:pc1024;
	begin
	try
	with data^ do
		with rcitem do
			begin
			hls_rvb.tcolorref_to_hls(g_base.rgb_cyan,hue,lum,sat);
			{Pour faire style affichage d'un rayon bleu-cyan comme dans l'affichage des réseaux wifi (c'db)}
			for i:=top to bottom do
				begin
				try
					{pour obtenir un rayon blanc vers le cyan avec un rayon au millieu}
					distance_du_millieu:=(bottom-top) div 2;
					//pour éviter la division par zéro si aucune entrée n'est sélectionnée
					if (bottom-top)<>0 then
						lumiere:=1.0-(abs((distance_du_millieu-(i-top)))/((bottom-top))/2)
					else
						lumiere:=1.0;
					if pred(list_exe.GetCount)<>0 then
						hls_rvb.hls_to_tcolorref((360*data^.itemID) div pred(list_exe.GetCount),lumiere,sat,une_couleur)
					else
						une_couleur:=g_base.RGB_Blanc;
					except
						une_couleur:=g_base.RGB_Blanc;
						end;
				apencil:=SelectObject(hdc,Createpen(PS_Solid,1,une_couleur));
				Moveto(hdc,0,i); LineTo(hdc,right,i);
				DeleteObject(SelectObject(hdc,apencil));
				end;

			//Recherche du pictogramme
			nom_du_runable:=pchar(itemdata);
      strcopy(nom_labography,nom_du_runable);
      strcopy(nom_inkscape,nom_du_runable);
      strcopy(nom_internet,nom_du_runable);
			if strpos(nom_du_runable,uregedit.K_PAINTER)<>nil then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Corel_painter,strlen(pc_Corel_painter),nil);
				local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				strcopy(pc_nom_temporaire_du_shell,nom_du_runable);
				p:=strpos(pc_nom_temporaire_du_shell,'%1');
				if p<>nil then
					begin
					dec(p);
					p^:=#0;
					string_without_guillement:='';
					for i:=0 to pred(strlen(pc_nom_temporaire_du_shell)) do
						if pc_nom_temporaire_du_shell[i]<>'"' then
							string_without_guillement:=string_without_guillement+pc_nom_temporaire_du_shell[i];
					local_icone:=utilisation.get_icon_minuscule(string_without_guillement,false);
					if local_icone<>0 then
						DrawIcon(hdc,2,top+2,local_icone);
					end;
				end
      else if (strpos(nom_du_runable,'psp.exe')<>nil)
			or (strpos(nom_du_runable,'PSP.EXE')<>nil)
      or (strpos(nom_du_runable,uregedit.K_Paint_shop_pro_cinq)<>nil) then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,Paint_shop_pro_cinq,strlen(Paint_shop_pro_cinq),nil);
				strcopy(pc_pour_paint_shop_pro_cinq,nom_du_runable);
				p:=strpos(pc_pour_paint_shop_pro_cinq,'/dde');
				if p<>nil then begin dec(p); p^:=#0; end;
				local_icone:=utilisation.get_icon_minuscule(pc_pour_paint_shop_pro_cinq,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
				end
      else if (strpos(nom_du_runable,'CorelDRAW')<>nil) then {Denis-Bertin le 31.10.2016}
        begin
        SetBkMode(hdc,TRANSPARENT);
        exttextout(hdc,36,succ(top),eto_clipped,@rcitem,'Corel-Draw',10,nil);
        local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
        end
			else if strpos(nom_du_runable,uregedit.K_Adobe_photoshop)<>nil then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Adobe_photoshop,strlen(pc_Adobe_photoshop),nil);
				local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
				end
      else if (strpos(strlower(nom_internet),uregedit.K_INTERNET)<>nil) then
        begin
        SetBkMode(hdc,TRANSPARENT);
        exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Internet,strlen(pc_Internet),nil);
        strcopy(pc_nom_temporaire_du_shell,nom_du_runable);
        p:=strpos(pc_nom_temporaire_du_shell,'"%1"');
				if p<>nil then
					begin
					dec(p);
					p^:=#0;
          local_icone:=utilisation.get_icon_minuscule(pc_nom_temporaire_du_shell,false);
					if local_icone<>0 then
						DrawIcon(hdc,2,top+2,local_icone);
				  end
        else
          begin
          p:=strpos(pc_nom_temporaire_du_shell,'%1');
				  if p<>nil then
					  begin
					  dec(p);
					  p^:=#0;
            local_icone:=utilisation.get_icon_minuscule(pc_nom_temporaire_du_shell,false);
					  if local_icone<>0 then
						  DrawIcon(hdc,2,top+2,local_icone);
				    end;
          end;
        end
      else if strpos(nom_du_runable,uregedit.K_Explorer)<>nil then
        begin
        SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_exporateur_de_window,strlen(pc_exporateur_de_window),nil);
        local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
        end
			else if strpos(nom_du_runable,uregedit.K_Paint_SHOP_PRO)<>nil then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Corel_paint_shop_pro,strlen(pc_Corel_paint_shop_pro),nil);
				local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
				end
			else if (strpos(nom_du_runable,uregedit.K_circle)<>nil)
			or (strpos(strlower(nom_du_runable),k_denis_draw)<>nil) then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_denis_draw,strlen(pc_denis_draw),nil);
				local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
				end
			else if strpos(nom_du_runable,uregedit.K_PSP)<>nil then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_paint_shop_pro,strlen(pc_paint_shop_pro),nil);
				local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
				end
      else if (strpos(strlower(nom_inkscape),uregedit.K_INKSCAPE)<>nil) then
        begin
        SetBkMode(hdc,TRANSPARENT);
        exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Inkscape,strlen(pc_Labography),nil);
        strcopy(pc_nom_temporaire_du_shell,nom_du_runable);
        p:=strpos(pc_nom_temporaire_du_shell,'"%1"');
				if p<>nil then
					begin
					dec(p);
					p^:=#0;
          local_icone:=utilisation.get_icon_minuscule(pc_nom_temporaire_du_shell,false);
					if local_icone<>0 then
						DrawIcon(hdc,2,top+2,local_icone);
				  end;
        end
      else if (strpos(strlower(nom_labography),uregedit.K_Labography)<>nil) then
        begin
        SetBkMode(hdc,TRANSPARENT);
        exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Labography,strlen(pc_Labography),nil);
        strcopy(pc_nom_temporaire_du_shell,nom_du_runable);
        p:=strpos(pc_nom_temporaire_du_shell,'"%1"');
				if p<>nil then
					begin
					dec(p);
					p^:=#0;
          local_icone:=utilisation.get_icon_minuscule(pc_nom_temporaire_du_shell,false);
					if local_icone<>0 then
						DrawIcon(hdc,2,top+2,local_icone);
				  end;
        end
			else if (strpos(nom_du_runable,uregedit.K_MSPAINT)<>nil)
			or (strpos(strupper(nom_du_runable),uregedit.K_MSPAINT)<>nil) then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_Paint,strlen(pc_Paint),nil);
				strcopy(pc_nom_temporaire_du_shell,nom_du_runable);
				p:=strpos(pc_nom_temporaire_du_shell,'"%1"');
				if p<>nil then
					begin
					dec(p);
					p^:=#0;
					string_without_guillement:='';
					for i:=0 to pred(strlen(pc_nom_temporaire_du_shell)) do
						if pc_nom_temporaire_du_shell[i]<>'"' then
							string_without_guillement:=string_without_guillement+pc_nom_temporaire_du_shell[i];
					local_icone:=utilisation.get_icon_minuscule(string_without_guillement,false);
					if local_icone<>0 then
						DrawIcon(hdc,2,top+2,local_icone);
					end
				else
					begin
					local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
					if local_icone<>0 then
						DrawIcon(hdc,2,top+2,local_icone);
					end;
				end
			else if strpos(strupper(nom_du_runable),uregedit.K_Paint_Dot_Net_Usage)<>nil then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_PaintDotNet,strlen(pc_PaintDotNet),nil);
				local_icone:=utilisation.get_icon_minuscule(nom_du_runable,false);
				if local_icone<>0 then
					DrawIcon(hdc,2,top+2,local_icone);
				end
			else if strpos(nom_du_runable,uregedit.K_Gimp_Usage)<>nil then
				begin
				SetBkMode(hdc,TRANSPARENT);
				exttextout(hdc,36,succ(top),eto_clipped,@rcitem,pc_gimp,strlen(pc_gimp),nil);
				//trouver le nom sans guillemet
        chaine_gimp:='';
        bool_ajout:=false;
        bool_encore:=true;
        for i:=0 to strlen(nom_du_runable) do
          begin
          if bool_encore then
            begin
						if nom_du_runable[i]='"' then
              begin
              if not bool_ajout then
                bool_ajout:=True
              else
                 bool_encore:=false;
              end
            else
              if bool_ajout then
                chaine_gimp:=chaine_gimp+nom_du_runable[i];
            end;
          end;
        local_icone:=utilisation.get_icon_minuscule(chaine_gimp,false);
        if local_icone<>0 then
          DrawIcon(hdc,2,top+2,local_icone);
        end //draw gimp
      else
        begin
				SetBkMode(hdc,TRANSPARENT);
				strlower(strcopy(pc_exe_with_out_exe,nom_du_runable));
				pc_doted_exe:=strpos(pc_exe_with_out_exe,k_pc_point_exe);
				if pc_doted_exe<>nil then
					begin
					if pc_doted_exe<>nil then pc_doted_exe^:=#0;
					pc_exe_with_out_exe[0]:=upcase(pc_exe_with_out_exe[0]);
					ExtTextOut(hdc,36,succ(top),eto_clipped,@rcitem,pc_exe_with_out_exe,strlen(pc_exe_with_out_exe),nil);
					end
				else
					begin
					ExtTextOut(hdc,36,succ(top),eto_clipped,@rcitem,pchar(nom_du_runable),strlen(pchar(nom_du_runable)),nil);
					end;
				if (nom_du_runable<>nil) then
					begin
          position:=itemID;
          {avec l'itemID trouver le nom correspondant}
          {$ifdef debug} box(hwindow,nom_du_runable_juste_exe); {$endif debug}
          strcopy(nom_du_runable_juste_exe,pchar(Get_exe_name_with_denomination(pchar(Self.ma_stringList.strings[position]))));
          {$ifdef debug} box(self.hwindow,nom_du_runable_juste_exe); {$endif debug}
          {SUPPR le caractère après l'exe}
          p:=strpos(nom_du_runable_juste_exe,wmenuk.point_exe);
          if p=nil then
            begin
            strcopy(une_extension_en_majuscule,wmenuk.point_exe);
            StrUpper(une_extension_en_majuscule);
            p:=strpos(nom_du_runable_juste_exe,une_extension_en_majuscule);
            end;
          {Pour afficher le pictogramme suivant en utilisant le nom de l'exe}
          if p<>nil then
            begin
            inc(p,4);
            if p^='"' then
              begin
              p^:=#0;
              q:=@nom_du_runable_juste_exe;
              inc(q);
              strcopy(nom_du_runable_bis,q);
              strcopy(nom_du_runable_juste_exe,nom_du_runable_bis);
              end;
            p^:=#0;
            {$ifdef debug} box(hwindow,nom_du_runable_juste_exe); {$endif debug}
            local_icone:=utilisation.get_icon_minuscule(nom_du_runable_juste_exe,false);
            if local_icone<>0 then
              DrawIcon(hdc,2,top+2,local_icone);
            end;
          end;
        end;
			end; {if <> nil}
    except
      end;
    end; {TD_Open_with.Draw_item}

procedure TD_Open_with.draw_focus(data:PDRAWITEMSTRUCT);
	var arect:trect;
	begin
	with data^ do
		begin
		if (itemaction and oda_focus)<>0 then with arect do
			begin
			arect:=rcitem;	inc(left); inc(top);
			dec(bottom);
			dec(right);
			drawfocusrect(hdc,arect);
			end;
		end;
	end; {TD_Open_with.draw_focus}

procedure TD_Open_with.Ok;
	var item_selectionner:integer;
			pc_selectionner:pc1024;
			pc_remplacer:pc1024;
			pc_execution:pc1024;
			pc_filename_dxf:pc1024;
			nom_runable:string;
			maxlen_remplacer:integer;
			pc_fow,p:pchar;
	begin
	inherited Ok;
	item_selectionner:=self.list_exe.Getselindex;
	if item_selectionner<>-1 then
		begin
		strpcopy(pc_selectionner,Self.ma_stringList.strings[item_selectionner]);
		if strpos(pc_selectionner,uregedit.K_PAINTER)<>nil then
			begin
      p:=SysUtils.StrPos(pc_selectionner,'%1');
			if p<>nil then
				begin
				if true then
					begin
					dec(p);
					p^:=#0;
					ShellAPI.ShellExecute(0, Nil,pc_selectionner,
						Self.file_to_open_with,
							pchar(ExtractFileDir(Self.file_to_open_with)),SW_NORMAL);
					end
				end
			end
    else if strpos(strlower(pc_selectionner),uregedit.K_INTERNET)<>nil then {écrit par denis bertin le 24.2.2016}
      begin
      {$ifdef debug} box(0,pc_selectionner); {$endif debug}
      p:=SysUtils.StrPos(pc_selectionner,'"%1"');
      if p<>nil then
        begin
        dec(p);
        p^:=#0;
        strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
        {$ifdef debug} box(0,pc_execution); {$endif debug}
				WinExec(pc_execution,sw_show);
        end
      else
        begin
        p:=SysUtils.StrPos(pc_selectionner,'%1');
        if p<>nil then
          begin
          dec(p);
          p^:=#0;
          strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					  wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
          {$ifdef debug} box(0,pc_execution); {$endif debug}
				  WinExec(pc_execution,sw_show);
          end;
        end;
      end
    else if strpos(pc_selectionner,uregedit.K_Inkscape)<>nil then {écrit par denis bertin le 24.2.2016}
      begin
      {$ifdef debug} box(0,pc_selectionner); {$endif debug}
      p:=SysUtils.StrPos(pc_selectionner,'"%1"');
      if p<>nil then
        begin
        dec(p);
        p^:=#0;
        strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
        {$ifdef debug} box(0,pc_execution); {$endif debug}
				WinExec(pc_execution,sw_show);
        end;
      end
    else if strpos(pc_selectionner,'coreldraw')<>nil then
      begin
      strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
        wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
      {$ifdef debug} box(0,pc_execution); {$endif debug}
      WinExec(pc_execution,sw_show);
      end
    else if strpos(pc_selectionner,uregedit.K_Labography)<>nil then {écrit par denis bertin le 20.1.2016}
      begin
      {$ifdef debug} box(0,pc_selectionner); {$endif debug}
      p:=SysUtils.StrPos(pc_selectionner,'"%1"');
      if p<>nil then
        begin
        dec(p);
        p^:=#0;
        strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
        {$ifdef debug} box(0,pc_execution); {$endif debug}
				WinExec(pc_execution,sw_show);
        end;
      end
		else if strpos(pc_selectionner,uregedit.K_Adobe_photoshop)<>nil then
			begin
			p:=SysUtils.StrPos(pc_selectionner,'.exe');
			if p<>nil then
				begin
				strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
				{$ifdef debug} box(0,pc_execution); {$endif debug}
				WinExec(pc_execution,sw_show);
				end;
			end
		else if strpos(pc_selectionner,'psp.exe') or
    strpos(pc_selectionner,uregedit.K_Paint_SHOP_PRO)<>nil then
			begin
			p:=SysUtils.StrPos(pc_selectionner,'.exe');
			if p<>nil then
				begin
        p:=strpos(pc_selectionner,'/dde');
        if p<>nil then
          begin
          dec(p);
          p^:=chr(0);
          end;
				strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);

				WinExec(pc_execution,sw_show);
				end;
			end
		else if strpos(pc_selectionner,uregedit.K_PSP)<>nil then //K_Paint_SHOP_PRO
			begin
			p:=SysUtils.StrPos(pc_selectionner,'.exe');
			if p<>nil then
				begin
				p:=SysUtils.StrPos(pc_selectionner,'/dde');
				if p<>nil then
					begin {suppr /dde}
					strpcopy(pc_remplacer,pc_selectionner);
					p:=SysUtils.StrPos(pc_remplacer,' /dde');
					if p<>nil then p^:=#0;
					strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_remplacer),
						wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
					WinExec(pc_execution,sw_show);
					end
				else
					begin
					strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
						wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
					WinExec(pc_execution,sw_show);
					end;
				end;
			end
		else if strpos(pc_selectionner,uregedit.K_Circle)<>nil then
			begin
			strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
				wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
			WinExec(pc_execution,sw_show);
			end
		else if strpos(pc_selectionner,uregedit.K_Paint_Dot_Net_Usage)<>nil then
			begin
			p:=SysUtils.StrPos(strupper(pc_selectionner),'.EXE');
			if p<>nil then
				begin
				strcat(strcat(strcat(strcat(strcopy(pc_execution,pc_selectionner),
					wutil.kpc_space),wutil.kpc_quote),Self.file_to_open_with),wutil.kpc_quote);
				WinExec(pc_execution,sw_show);
				end;
			end
    else if strpos(pc_selectionner,uregedit.K_Explorer)<>nil then
      begin
      ShellAPI.ShellExecute(self.hwindow,nil,'explorer',
        pchar('/select,'+strpas(File_to_open_with)),nil,SW_Show); {denis Bertin}
      end
		else if (strpos(pc_selectionner,'mspaint')<>nil)
    or (strpos(pc_selectionner,uregedit.K_MSPAINT)<>nil) then
			begin
			p:=SysUtils.StrPos(pc_selectionner,'%1');
			if p<>nil then
				begin
				if true then
					begin
					dec(p);
					dec(p);
					p^:=#0;
					ShellAPI.ShellExecute(0, Nil,pc_selectionner,
						pchar('"'+strpas(Self.file_to_open_with)+'"'),
							pchar(ExtractFileDir(Self.file_to_open_with)),SW_NORMAL);
					end;
				end;
			end
		else if strpos(pc_selectionner,uregedit.K_Gimp_Usage)<>nil then
			begin
			p:=SysUtils.StrPos(pc_selectionner,'%1');
			if p<>nil then
				begin
				if true then
					begin
					dec(p);
					dec(p);
					p^:=#0;
					ShellAPI.ShellExecute(0, Nil,pc_selectionner,
						pchar('"'+strpas(Self.file_to_open_with)+'"'),
							pchar(ExtractFileDir(Self.file_to_open_with)),SW_NORMAL);
					end
				else
					begin
					inc(p);
					p^:=#115;
					pc_fow:=@Self.file_to_open_with;
					maxlen_remplacer:=pred(sizeof(pc_execution));
					SysUtils.StrLFmt(pc_execution,maxlen_remplacer,pc_selectionner,[pc_fow]);
					WinExec(pc_execution,sw_show);
					end;
				end;
			end
		else
			begin
			nom_runable:=Get_exe_name_with_denomination(pc_selectionner);
			if length(nom_runable)<>0 then
				begin
				p:=SysUtils.StrPos(pchar(nom_runable),'/dde');
				if p<>nil then
					begin {suppr /dde}
					strpcopy(pc_remplacer,nom_runable);
					p:=SysUtils.StrPos(pc_remplacer,'/dde');
					if p<>nil then p^:=#0;
					nom_runable:=strpas(pc_remplacer);
					end; {suppr /dde}
				if strpos(pchar(nom_runable),'acad')<>nil then
					begin
					p:=SysUtils.StrPos(pchar(nom_runable),'%1');
					if p<>nil then
						begin
						strcopy(pc_filename_dxf,pchar(nom_runable));
						p:=SysUtils.StrPos(pc_filename_dxf,'%1');
						if p<>nil then begin dec(p); p^:=#0; end; {retirer le guillemet %1}
						end;
					nom_runable:=strpas(pc_filename_dxf)+' open("'+strpas(strupper(Self.file_to_open_with))+'")';
					end
				else
					begin
					p:=SysUtils.StrPos(pchar(nom_runable),'%1');
					if p<>nil then
						begin
						inc(p);
						p^:=#115;
						maxlen_remplacer:=pred(sizeof(pc_remplacer));
						pc_fow:=@Self.file_to_open_with;
						SysUtils.StrLFmt(pc_remplacer,maxlen_remplacer,pchar(nom_runable),[pc_fow]);
            nom_runable:=strpas(pc_remplacer);
            end
          else
						begin
            //Obtention de la ligne spécifique à window média player qui demande ce paramètre.
						p:=SysUtils.StrPos(pchar(nom_runable),'%L');
            if p<>nil then
              begin
              //box(self.hwindow,pchar(nom_runable));
              inc(p);
              p^:=#115;
              maxlen_remplacer:=pred(sizeof(pc_remplacer));
              pc_fow:=@Self.file_to_open_with;
              SysUtils.StrLFmt(pc_remplacer,maxlen_remplacer,pchar(nom_runable),[pc_fow]);
              nom_runable:=strpas(pc_remplacer);
              end
            else
              nom_runable:=nom_runable+' "'+strpas(Self.file_to_open_with)+'"';
            end;
          end;
        {$ifdef debug} box(self.hwindow,pchar(nom_runable)); {$endif debug}
        WinExec(pchar(nom_runable),sw_show);
        end;
      end;
    end;
	end; {TD_Open_with.TD_Open_with.Ok}

function Ouvrir_avec_de_multiple_programme(parent:wbase.twindow; quel_extension:pchar; quel_fichier:pchar):boolean;
  var une_stringlist:Classes.TStringlist;
      nombre_fichier_trouver:integer;
      un_dialogue_open_with:uregedit.TD_Open_with;
  begin
  result:=false;
  une_stringlist:=Classes.TStringlist.Create;
	nombre_fichier_trouver:=uregedit.open_and_enum_key(quel_extension,une_stringlist);
  if nombre_fichier_trouver=1 then
    begin
    uregedit.open_fichier_avec_extension(parent.hwindow,quel_extension,quel_fichier);
    end
	else if nombre_fichier_trouver>1 then
    begin
		un_dialogue_open_with:=uregedit.TD_Open_with.Create(Parent,une_stringlist,quel_fichier);
		result:=un_dialogue_open_with.Execdialog(parent.hwindow)=id_ok;
		un_dialogue_open_with.free;
		end;
	une_stringlist.free;
	end; {ouvrir_avec_de_multiple_programme}

function RegCreatekeyRoot(lpAppName,lpKeyName:pchar):boolean;
	var registre:TRegistry;
			string_key:string;
	begin
	result:=false;
	registre:=TRegistry.create;
	try
		registre.RootKey:=HKEY_CURRENT_USER;
    string_key:='HKEY_CURRENT_USER\'+uregedit.k_denis_draw;
    Registre.CreateKey(string_key);
    string_key:='HKEY_CURRENT_USER\'+uregedit.k_denis_draw+'\'+pchar(strpas(lpAppName));
    Registre.CreateKey(string_key);
    string_key:='HKEY_CURRENT_USER\'+uregedit.k_denis_draw+'\'+pchar(strpas(lpAppName))+'\'+strpas(lpKeyName);
    Registre.CreateKey(string_key);
	finally
		registre.free;
		result:=true;
		end;
	end;                                    

procedure Creer_cette_cle_dans_le_root(nom_cle:string);
  var registre:TRegistry;
      adresse:string;
  begin
  try
    registre:=TRegistry.create;
	  try
		  registre.RootKey:=HKEY_CLASSES_ROOT;
      adresse:=nom_cle;
      if registre.CreateKey(adresse) then
        begin
        registre.closekey;
        end;
	  finally
		  registre.free;
      end;
  except
    end;
  end; {Creer_cette_cle_dans_le_root}

function RegWritePrivateProfileStringroot(lpAppName,lpKeyName,lpString:pchar):boolean;
	var registre:TRegistry;
			nom_cle:string;
	begin
	result:=false;
	registre:=TRegistry.create;
	try
		registre.RootKey:=HKEY_CURRENT_USER;
		nom_cle:=strpas('\'+k_denis_draw)+'\'+strpas(lpAppName); {'\'+ }
		if registre.openkey(nom_cle,True) then
			registre.WriteString(lpKeyName,lpString);
		registre.closekey;
	finally
		registre.free;
		result:=true;
		end;
	end; {RegWritePrivateProfileStringroot}

function RegWritePrivateProfileString(lpAppName,lpKeyName,lpString:pchar):boolean;
	var registre:TRegistry;
			nom_cle:string;
	begin
  result:=false;
	registre:=TRegistry.create;
	try
		registre.RootKey:=HKEY_CURRENT_USER;
		nom_cle:=strpas('\'+k_denis_draw)+'\'+strpas(lpAppName); {'\'+ }
		if registre.openkey(nom_cle,True) then
			registre.WriteString(lpKeyName,lpString);
		registre.closekey;
    registre.free;
	finally
		result:=true;
		end;
	end; {Reg_WritePrivateProfileString}

function RegWritePrivateProfileIntRoot(lpAppName,lpKeyName:pchar;nValue:integer):boolean;
	var apc_value:wutil.pc1024;
	begin
	Inttopchar(nValue,apc_value);
	RegWritePrivateProfileIntRoot:=RegWritePrivateProfileStringroot(lpAppName,lpKeyName,apc_value);
	end; {RegWritePrivateProfileIntRoot}

function RegWritePrivateProfileInt(lpAppName,lpKeyName:pchar;nValue:integer):boolean;
	var apc_value:wutil.pc1024;
	begin
	Inttopchar(nValue,apc_value);
	RegWritePrivateProfileInt:=RegWritePrivateProfileString(lpAppName,lpKeyName,apc_value);
	end; {RegWritePrivateProfileInt}

function RegWritePrivateProfileHex(lpAppName,lpKeyName:pchar;nValue:integer):boolean;
  var apc_value:wutil.pc1024;
  begin
  strpcopy(apc_value,Hexlongint(nValue));
  RegWritePrivateProfileString(lpAppName,lpKeyName,apc_value);
  end;

function RegGetPrivateProfileStringRoot(lpAppName,lpKeyName,lpDefault,lpReturnedString:pchar; nSize:integer):integer;
	var registre:TRegistry;
			nom_cle,value:string;
	begin
	registre:=TRegistry.create;
	try
		registre.RootKey:=HKEY_CURRENT_USER;
		nom_cle:=strpas('\'+k_denis_draw)+'\'+strpas(lpAppName); {'\'+ }
		if registre.openkey(nom_cle,True) then
			begin
			value:=registre.ReadString(lpKeyName);
			if value<>'' then
				strpcopy(lpReturnedString,value)
			else
				Strcopy(lpReturnedString,lpDefault); {pour affecter la valeur par default}
			end;
		registre.closekey;
	finally
		registre.free;
		result:=strlen(lpReturnedString);
		end;
	end; {RegGetPrivateProfileStringRoot}

function RegGetPrivateProfileString(lpAppName,lpKeyName,lpDefault,lpReturnedString:pchar; nSize:integer):integer;
	var registre:TRegistry;
			nom_cle,value:string;
	begin
	registre:=TRegistry.create;
	try
		registre.RootKey:=HKEY_CURRENT_USER;
		nom_cle:=strpas('\'+k_denis_draw)+'\'+strpas(lpAppName); {'\'+ }  
		if registre.openkey(nom_cle,True) then
			begin
			value:=registre.ReadString(lpKeyName);
			if value<>'' then
				strpcopy(lpReturnedString,value)
			else
				Strcopy(lpReturnedString,lpDefault); {pour affecter la valeur par défaut}
			end;
		registre.closekey;
	finally
		registre.free;
		result:=strlen(lpReturnedString);
		end;
	end;

function RegGetPrivateProfileIntRoot(lpAppName,lpKeyName:pchar; nDefault:integer):integer;
	var pc_value_default:wutil.pc1024;
			pc_return_value:wutil.pc1024;
	begin
  try
  	inttopchar(nDefault,pc_value_default);
    RegGetPrivateProfileIntRoot:=nDefault;
  	RegGetPrivateProfileStringRoot(lpAppName,lpKeyName,pc_value_default,pc_return_value,pred(sizeof(pc_return_value)));
	  if strlen(pc_return_value)=0 then
		  RegGetPrivateProfileIntRoot:=nDefault
  	else
	  	if Is_Pchar_numerique(pc_return_value) then
		  	RegGetPrivateProfileIntRoot:=strtoint(pc_return_value)
		  else
			  RegGetPrivateProfileIntRoot:=nDefault;
  except
    end;
	end;

function RegGetPrivateProfileInt(lpAppName,lpKeyName:pchar; nDefault:integer):integer;
	var pc_value_default:wutil.pc1024;
			pc_return_value:wutil.pc1024;
	begin
	inttopchar(nDefault,pc_value_default);
	RegGetPrivateProfileString(lpAppName,lpKeyName,pc_value_default,pc_return_value,pred(sizeof(pc_return_value)));
	if strlen(pc_return_value)=0 then
		RegGetPrivateProfileInt:=nDefault
	else
		if wutil.Is_Pchar_numerique(pc_return_value) then
			RegGetPrivateProfileInt:=strtoint(pc_return_value)
		else
			RegGetPrivateProfileInt:=nDefault;
	end;

function RegGetPrivateProfileHex(lpAppName,lpKeyName:pchar; nDefault:integer):integer;
  var apc_value:wutil.pc1024;
      pc_return_value:wutil.pc1024; {denis B}
  begin
  strpcopy(apc_value,Hexlongint(nDefault));
  RegGetPrivateProfileString(lpAppName,lpKeyName,apc_value,pc_return_value,pred(sizeof(pc_return_value)));
  if strlen(pc_return_value)=0 then
		RegGetPrivateProfileHex:=nDefault
  else
    if wutil.Is_Pchar_hexadecimal(pc_return_value) then
      RegGetPrivateProfileHex:=wutil.Hexvalue(strpas(pc_return_value))
    else
      RegGetPrivateProfileHex:=nDefault;
  end;


end.
