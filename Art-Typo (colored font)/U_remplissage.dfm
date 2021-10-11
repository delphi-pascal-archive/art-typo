object Form2_remplissage: TForm2_remplissage
  Left = 493
  Top = 280
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Remplissage'
  ClientHeight = 293
  ClientWidth = 593
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 443
    Top = 251
    Width = 132
    Height = 31
    Caption = '&Fermer'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 10
    Top = 6
    Width = 572
    Height = 238
    ActivePage = TabSheet1
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Definition'
      OnMouseMove = TabSheet1MouseMove
      object Label_nb_couleur: TLabel
        Left = 10
        Top = 25
        Width = 245
        Height = 20
        Caption = 'Nombre de couleurs intermediaire :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Image1: TImage
        Left = 20
        Top = 79
        Width = 74
        Height = 39
        OnClick = Image1Click
        OnDragOver = Image1DragOver
        OnEndDrag = Image1EndDrag
        OnMouseDown = Image1MouseDown
        OnMouseMove = Image1MouseMove
      end
      object Image2: TImage
        Left = 108
        Top = 79
        Width = 74
        Height = 39
        OnClick = Image2Click
        OnDragOver = Image2DragOver
        OnEndDrag = Image2EndDrag
        OnMouseDown = Image2MouseDown
        OnMouseMove = Image2MouseMove
      end
      object Image3: TImage
        Left = 197
        Top = 79
        Width = 74
        Height = 39
        OnClick = Image3Click
        OnDragOver = Image3DragOver
        OnEndDrag = Image3EndDrag
        OnMouseDown = Image3MouseDown
        OnMouseMove = Image3MouseMove
      end
      object Image4: TImage
        Left = 286
        Top = 79
        Width = 73
        Height = 39
        OnClick = Image4Click
        OnDragOver = Image4DragOver
        OnEndDrag = Image4EndDrag
        OnMouseDown = Image4MouseDown
        OnMouseMove = Image4MouseMove
      end
      object Image5: TImage
        Left = 374
        Top = 79
        Width = 74
        Height = 39
        OnClick = Image5Click
        OnDragOver = Image5DragOver
        OnEndDrag = Image5EndDrag
        OnMouseDown = Image5MouseDown
        OnMouseMove = Image5MouseMove
      end
      object Image6: TImage
        Left = 463
        Top = 79
        Width = 74
        Height = 39
        OnClick = Image6Click
        OnDragOver = Image6DragOver
        OnEndDrag = Image6EndDrag
        OnMouseDown = Image6MouseDown
        OnMouseMove = Image6MouseMove
      end
      object Image_preview: TImage
        Left = 20
        Top = 128
        Width = 517
        Height = 39
        OnEndDrag = Image_previewEndDrag
        OnMouseDown = Image_previewMouseDown
        OnMouseMove = Image_previewMouseMove
      end
      object Label_color_hexa: TLabel
        Left = 478
        Top = 178
        Width = 9
        Height = 19
        Caption = '#'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object UpDown1: TUpDown
        Left = 297
        Top = 10
        Width = 19
        Height = 34
        Min = 2
        Max = 5
        Position = 2
        TabOrder = 0
        Wrap = True
        OnClick = UpDown1Click
      end
      object Edit_nb_couleur: TEdit
        Left = 276
        Top = 10
        Width = 21
        Height = 33
        Hint = 'Entre 2 et 5.'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        Text = '2'
      end
      object Edit_hexa_color: TEdit
        Left = 492
        Top = 177
        Width = 57
        Height = 24
        TabOrder = 2
        Text = '123456'
      end
      object Button2: TButton
        Left = 414
        Top = 15
        Width = 119
        Height = 31
        Caption = 'Ajouter a la liste'
        Enabled = False
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Liste'
      ImageIndex = 1
      object ListBox1: TListBox
        Left = 10
        Top = 10
        Width = 543
        Height = 184
        Style = lbOwnerDrawFixed
        ItemHeight = 20
        TabOrder = 0
        OnClick = ListBox1Click
        OnDrawItem = ListBox1DrawItem
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Lumiere'
      ImageIndex = 2
      OnShow = TabSheet3Show
      object Image_lum_position: TImage
        Left = 10
        Top = 30
        Width = 296
        Height = 168
        OnMouseDown = Image_lum_positionMouseDown
        OnMouseMove = Image_lum_positionMouseMove
        OnMouseUp = Image_lum_positionMouseUp
      end
      object Label_lum_position: TLabel
        Left = 10
        Top = 10
        Width = 51
        Height = 16
        Caption = 'Position:'
      end
      object Label_lum_intensite: TLabel
        Left = 324
        Top = 69
        Width = 52
        Height = 16
        Caption = 'Intensite:'
      end
      object Label_lum_coef_pourcent: TLabel
        Left = 482
        Top = 69
        Width = 12
        Height = 16
        Caption = '%'
      end
      object Image_lum_couleur: TImage
        Left = 394
        Top = 103
        Width = 76
        Height = 26
        OnClick = Image_lum_couleurClick
      end
      object Label_lum_couleur: TLabel
        Left = 324
        Top = 113
        Width = 49
        Height = 16
        Caption = '&Couleur:'
      end
      object Edit_lum_coef: TEdit
        Left = 394
        Top = 59
        Width = 60
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object UpDown2: TUpDown
        Left = 454
        Top = 59
        Width = 19
        Height = 26
        Associate = Edit_lum_coef
        TabOrder = 1
      end
      object CheckBox_lumiere: TCheckBox
        Left = 324
        Top = 20
        Width = 119
        Height = 21
        Caption = 'Lumiere Visible'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = CheckBox_lumiereClick
      end
    end
    object TabSheet_ombre: TTabSheet
      Caption = 'Ombre'
      ImageIndex = 3
      OnShow = TabSheet_ombreShow
      object Label_ombre_distance: TLabel
        Left = 10
        Top = 69
        Width = 56
        Height = 16
        Hint = 'Distance de la projection de l'#39'ombre'
        Caption = '&Distance:'
        ParentShowHint = False
        ShowHint = True
      end
      object Label_ombre_couleur: TLabel
        Left = 10
        Top = 153
        Width = 116
        Height = 16
        Caption = '&Couleur de l'#39'ombre:'
      end
      object Label_ombre_attenuation: TLabel
        Left = 10
        Top = 108
        Width = 52
        Height = 16
        Hint = 
          'Pourcentage indiquant le melange entre la couleur de l'#39'ombre et ' +
          'de la couleur projetee'
        Caption = '&Intensite:'
        ParentShowHint = False
        ShowHint = True
      end
      object Image_Ombre_couleur: TImage
        Left = 138
        Top = 143
        Width = 80
        Height = 26
        Hint = 'Cliquer ici pour afficher un nuancier'
        ParentShowHint = False
        ShowHint = True
        OnClick = Image_Ombre_couleurClick
      end
      object Label_ombre_pixel: TLabel
        Left = 226
        Top = 69
        Width = 36
        Height = 16
        Caption = 'Pixels'
      end
      object Label_ombre_pourcent: TLabel
        Left = 226
        Top = 108
        Width = 12
        Height = 16
        Caption = '%'
      end
      object Image_ombre_direction: TImage
        Left = 295
        Top = 39
        Width = 131
        Height = 131
        Hint = 
          'Cliquer dans ce rectangle pour indiquer une direction ainsi que ' +
          'l'#39'intensite.'
        ParentShowHint = False
        ShowHint = True
        OnMouseDown = Image_ombre_directionMouseDown
      end
      object Label_ombre_direction: TLabel
        Left = 295
        Top = 20
        Width = 56
        Height = 16
        Hint = 
          'Cliquer dans ce rectangle pour indiquer une direction ainsi que ' +
          'l'#39'intensite'
        Caption = 'Direction:'
        ParentShowHint = False
        ShowHint = True
      end
      object Edit_ombre_distance: TEdit
        Left = 138
        Top = 59
        Width = 60
        Height = 21
        Hint = 'Distance de la projection de l'#39'ombre'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '10'
      end
      object Edit_ombre_intensite: TEdit
        Left = 138
        Top = 98
        Width = 60
        Height = 21
        Hint = 
          'Pourcentage indiquant le melange entre la couleur de l'#39'ombre et ' +
          'de la couleur projetee'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = '40'
        OnChange = Edit_ombre_intensiteChange
      end
      object CheckBox_ombre: TCheckBox
        Left = 10
        Top = 30
        Width = 109
        Height = 20
        Caption = 'Ombre &Visible'
        TabOrder = 2
        OnClick = CheckBox_ombreClick
      end
      object UpDown3: TUpDown
        Left = 198
        Top = 59
        Width = 19
        Height = 26
        Associate = Edit_ombre_distance
        Position = 10
        TabOrder = 3
      end
      object UpDown4: TUpDown
        Left = 198
        Top = 98
        Width = 19
        Height = 26
        Associate = Edit_ombre_intensite
        Position = 40
        TabOrder = 4
      end
      object CheckBox_ombre_combi: TCheckBox
        Left = 453
        Top = 118
        Width = 100
        Height = 21
        Hint = 'Entre la couleur de l'#39'ombre et de la couleur projetee.'
        Caption = '&Combinaison'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object CheckBox_ombre_arrondir: TCheckBox
        Left = 453
        Top = 148
        Width = 74
        Height = 21
        Caption = '&Arrondir'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
    end
    object TabSheet_Filtre: TTabSheet
      Caption = 'Filtre'
      ImageIndex = 5
      object Label_augmenter_bord: TLabel
        Left = 236
        Top = 20
        Width = 43
        Height = 16
        Caption = 'pixel(s)'
      end
      object CheckBox_augmenter_bord: TCheckBox
        Left = 10
        Top = 20
        Width = 159
        Height = 21
        Caption = 'Augmenter les bords'
        TabOrder = 0
        OnClick = CheckBox_augmenter_bordClick
      end
      object Edit_augmenter_bord: TEdit
        Left = 187
        Top = 10
        Width = 41
        Height = 21
        Color = clYellow
        TabOrder = 1
        Text = '5'
      end
      object CheckBox_adoucir: TCheckBox
        Left = 10
        Top = 69
        Width = 80
        Height = 21
        Caption = 'Adoucir '
        TabOrder = 2
        OnClick = CheckBox_adoucirClick
      end
      object CheckBox_Adoucir_Simple: TCheckBox
        Left = 118
        Top = 69
        Width = 120
        Height = 21
        Caption = 'Adoucir Simple '
        TabOrder = 3
        Visible = False
        OnClick = CheckBox_Adoucir_SimpleClick
      end
      object CheckBox_adoucir_mini: TCheckBox
        Left = 266
        Top = 69
        Width = 100
        Height = 21
        Caption = 'Adoucir mini'
        TabOrder = 4
        Visible = False
        OnClick = CheckBox_adoucir_miniClick
      end
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen, cdAnyColor]
    Left = 444
    Top = 32
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 220
    OnTimer = Timer1Timer
    Left = 444
    Top = 64
  end
end
