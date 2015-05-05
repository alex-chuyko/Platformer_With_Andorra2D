program Platgamrix;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Hero in 'Hero.pas',
  Enemy in 'Enemy.pas',
  Menu in 'Menu.pas' {Form2},
  Pause in 'Pause.pas' {Form3},
  Lev in 'Lev.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
