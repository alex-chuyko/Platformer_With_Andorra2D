unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdDraws, AdClasses, AdTypes, AdSprites, AdPerformanceCounter, Hero;

type
  TBloks = class (TImageSprite)
  end;

type
  TMonets = class (TImageSprite)
  end;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    AdDraw: TAdDraw;
    AdSpriteEngine: TSpriteEngine;
    AdPerCounter: TAdPerformanceCounter;
    AdImageList: TAdImageList;
    Hero: THero;

    ///////InputMandler///////

      keyUp, keyDown, keyLeft, keyRight: Boolean;

    ///
    procedure Idle(Sender:TObject;var Done:boolean);
    procedure LoadMap(FileName: string);
    { Public declarations }
  end;

var
  Form1: TForm1;
  list: TStringList;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  AdDraw := TAdDraw.Create(self);
  AdDraw.DllName := 'AndorraOGL.dll';
  with AdDraw.Display do
  begin
    Width:= 800;
    Height:= 608;
    DisplayMode:= dmWindowed;
  end;
  if AdDraw.Initialize then
  begin
    Application.OnIdle := Idle;
    AdSpriteEngine:= TSpriteEngine.Create(AdDraw);
    AdPerCounter:= TAdPerformanceCounter.Create;
    AdImageList:= TAdImageList.Create(AdDraw);
    AdImageList.LoadFromFile('sprites.ail');
    AdImageList.Restore;

    LoadMap('level1.txt');

    {with TBackgroundSprite.Create(AdSpriteEngine) do
    begin
      Image:= AdImageList.Find('fon')
    end; }
  end
  else
  begin
    ShowMessage('Error while initializing Andorra 2D. Try to use another display'+
                'mode or another video adapter.');
    halt;
  end;
end;

procedure TForm1.Idle(Sender: TObject; var Done: boolean);
begin
  if AdDraw.CanDraw then
  begin
    AdPerCounter.Calculate;
    AdDraw.ClearSurface(clBlack);

    AdDraw.BeginScene;
      AdSpriteEngine.Move(AdPerCounter.TimeGap / 1000);
      AdSpriteEngine.Draw;
      AdSpriteEngine.Dead;
      //AdImageList.Find('bloks').Draw(AdDraw, 0, 0, 0);
      with AdDraw.Canvas do
      begin
        TextOut(5, 5,'FPS: ' + FloatToStr(AdPerCounter.FPS));
        Release;
      end;
    AdDraw.EndScene;

    AdDraw.Flip;
  end;
  Done := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  AdPerCounter.Free;
  AdImageList.Free;
  AdDraw.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_LEFT then
  begin
    //Hero.dx:= -4;
    keyLeft:= True;
  end;
  if Key = VK_RIGHT then
  begin
    //Hero.dx:= 4;
    keyRight:= True;
  end;
  if Key = VK_UP then
  begin
    keyUp:= True;
    //if Hero.onGround then
       // begin
        //  Hero.dy:= -1;
        //  Hero.onGround:= False;
        //end
  end;
  if Key = VK_DOWN then
  begin
    keyDown:= True;
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_LEFT then
    keyLeft:= False;
  if Key = VK_RIGHT then
    keyRight:= False;
  if Key = VK_UP then
    keyUp:= False;
  if Key = VK_DOWN then
    keyDown:= False;
end;

procedure TForm1.LoadMap(FileName: string);
var
  Xi, Yi: Integer;
begin
  list:= TStringList.Create;
  list.LoadFromFile('Levels\' + FileName);
  for Yi:= 0 to list.Count - 1 do
    for Xi:= 0 to Length(list.Strings[Yi]) do
      case list.Strings[Yi][Xi] of
        'x':
          begin
            with TBloks.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('bloks');
              x:= (Xi - 1) * Width;
              y:= Yi * Height;
            end;
          end;
        'm':
          begin
            with TMonets.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('monets');
              x:= (Xi - 1) * Width;
              y:= Yi * Height;
            end;
          end;
        'p':
          begin
            Hero:= THero.Create(AdSpriteEngine);
            with Hero do
            begin
              Image:= AdImageList.Find('bad_hero');
              x:= (Xi - 1) * 32;
              y:= Yi * 32;
              AnimActive:= False;
              AnimSpeed:= 7;
              Speed:= 150;
            end;
          end;
      end;
end;

end.
