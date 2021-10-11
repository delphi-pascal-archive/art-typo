program Projet_Colored_font;

{%ToDo 'Projet_Colored_font.todo'}

uses
  Forms,
  U_main in 'u_main.pas' {Form_main},
  U_remplissage in 'U_remplissage.pas' {Form2_remplissage},
  U_thread_art_police in 'u_thread_art_police.pas',
  U_math in 'u_math.pas',
  Hls_rvb in 'hls_rvb.pas',
  U_object_sup in 'u_object_sup.pas',
  Smooth in 'Smooth.pas',
  Thread in 'Thread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Art Typo';
  Application.CreateForm(TForm_main, Form_main);
  Application.CreateForm(TForm2_remplissage, Form2_remplissage);
  Application.Run;
end.
