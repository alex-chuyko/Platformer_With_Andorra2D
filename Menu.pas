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
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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

uses Main;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  //Form1.Hide;
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
    //Application.OnIdle := Idle;
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

  {if  then
  begin
    AdPerCounter.Calculate;
    AdDraw.ClearSurface(clBlack);

    AdDraw.BeginScene;
      AdSpriteEngine.Move(AdPerCounter.TimeGap / 1000);
      AdSpriteEngine.Draw;
  AdDraw.EndScene;
  end; }
end;

procedure TForm2.btn1Click(Sender: TObject);
begin
  Form2.Hide;
  Form1.ShowModal;
  Form1.SetFocus;
end;

procedure TForm2.btn2Click(Sender: TObject);
begin
  Halt;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form2.SetFocus;
  if Key = 27 then
  begin
    ShowMessage('OK');
    //Form2.Hide;
    //Form1.ShowModal;
  end;
end;

end.

