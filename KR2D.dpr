program KR2D;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Hero in 'Hero.pas',
  Enemy in 'Enemy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
