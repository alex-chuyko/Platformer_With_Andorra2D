unit Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdDraws, AdClasses, AdTypes, AdSprites, AdPerformanceCounter,
  XPMan, StdCtrls, jpeg, ExtCtrls;

type
  TForm2 = class(TForm)
    btn1: TButton;
    xpmnfst1: TXPManifest;
    btn2: TButton;
    img1: TImage;
    lbl1: TLabel;
    btn3: TButton;
    lbl2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    AdDraw: TAdDraw;
    AdSpriteEngine: TSpriteEngine;
    AdPerCounter: TAdPerformanceCounter;
    AdImageList: TAdImageList;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Main, Lev;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  AdDraw := TAdDraw.Create(self);
  AdDraw.DllName := 'AndorraOGL.dll';
  with AdDraw.Display do
  begin
    Width:= 400;
    Height:= 500;
    DisplayMode:= dmWindowed;
  end;
  if AdDraw.Initialize then
  begin
    AdSpriteEngine:= TSpriteEngine.Create(AdDraw);
    AdPerCounter:= TAdPerformanceCounter.Create;
    AdImageList:= TAdImageList.Create(AdDraw);
    AdImageList.LoadFromFile('sprites.ail');
    AdImageList.Restore;

    with TBackgroundSprite.Create(AdSpriteEngine) do
    begin
      Image:= AdImageList.Find('fon')
    end;
    AdDraw.BeginScene;
      AdSpriteEngine.Draw;
    AdDraw.EndScene;
    AdDraw.Flip;
  end
  else
  begin
    ShowMessage('Error while initializing Andorra 2D. Try to use another display'+
                'mode or another video adapter.');
    halt;
  end;
end;

procedure TForm2.btn1Click(Sender: TObject);
begin
  Form2.Hide;
  Application.CreateForm(TForm4, Form4);
  Form4.Show;
end;

procedure TForm2.btn2Click(Sender: TObject);
begin
  Application.MessageBox('���� ������: �� ��������� ������, �� �����������' + #13 + #10 +
                         '������ �� � ������� ������, ����� ���� � ��������� �� ������.' + #13 + #10 +
                         '����� ����� �����, ���������� �� ���� ����������.' + #13 + #10 + #13 + #10 +
                         '����������:' + #13 + #10 +
                         'W/������� �����   - ������;' + #13 + #10 +
                         'D/������� ������ - ��� ������;' + #13 + #10 +
                         'A/������� �����   - ��� �����;' + #13 + #10 +
                         'Esc                            - �����;' + #13 + #10 + #13 + #10 +
                         '�������� �������������������! :)', 'HELP')
end;

procedure TForm2.btn3Click(Sender: TObject);
begin
  Halt;
  Form1.Destroy;
  Form2.Destroy;
  Form4.Destroy;
end;

end.

