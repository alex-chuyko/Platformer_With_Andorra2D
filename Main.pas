unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdDraws, AdClasses, AdTypes, AdSprites, AdPerformanceCounter, Hero, Enemy,
  ExtCtrls, MMSystem, MPlayer;

type
  TDead = class (TImageSprite)
  end;

type
  TBloks = class (TImageSprite)
  end;

type
  TMonets = class (TImageSprite)
    life: Boolean;
  end;

type
  TExit = class (TImageSprite)
  end;

type
  TKey = class (TImageSprite)
  end;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    AdDraw: TAdDraw;
    AdSpriteEngine: TSpriteEngine;
    AdPerCounter: TAdPerformanceCounter;

    Hero: THero;
    EnemyArray: array of TEnemy;
    enemyCount: Integer;

    keyUp, keyLeft, keyRight: Boolean;

    timeLevel: string;

    procedure Idle(Sender:TObject; var Done: boolean);
    procedure LoadMap(FileName: string);
    { Public declarations }
  end;

var
  Form1: TForm1;
  list: TStringList;
  AdImageList: TAdImageList;
  Start: TDateTime;
  KeyTable: TKey;

implementation

uses
  Menu, Pause, Lev, DateUtils, AdCanvas;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  levelName: string;
begin
  Start:= now;
  AdDraw := TAdDraw.Create(self);
  AdDraw.DllName := 'AndorraOGL.dll';
  with AdDraw.Display do
  begin
    Width:= 800; //800
    Height:= 512; //750
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

    levelName:= 'level' + IntToStr(Form4.flag + 1) + '.txt';
    LoadMap(levelName);

    with TBackgroundSprite.Create(AdSpriteEngine) do
    begin
      Image:= AdImageList.Find('background')
    end;
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
      with AdDraw.Canvas do
      begin
        timeLevel:= TimeToStr(now - Start);  
        //TextOut(5, 5,'FPS: ' + FloatToStr(AdPerCounter.FPS));
        Pen.Color:= Ad_ARGB(255, 255, 255, 255);
        Font:= AdDraw.Fonts.GenerateFont('VCR OSD Mono', 20, [afBold]);
        TextOut(580, 0, 'Time: ' + timeLevel);
        TextOut(5, 0,'Points: ' + IntToStr(Hero.points));
        Pen.Color:= Ad_ARGB(255, 255, 241, 111);
        if not Hero.key then
          TextOut(350, 0, 'KEY -')
        else
          TextOut(350, 0, 'KEY +');
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
  if (Key = VK_LEFT) or (Key = 65) then
  begin
    keyLeft:= True;
    Hero.Image:= AdImageList.Find('hero_back');
  end;

  if (Key = VK_RIGHT) or (Key = 68) then
  begin
    keyRight:= True;
    Hero.Image:= AdImageList.Find('hero');
  end;

  if (Key = VK_UP) or (Key = 87) or (Key = 32) then
    keyUp:= True;

  if Key = 27 then
  begin
    Form3.Show;
    Form3.SetFocus;
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_LEFT) or (Key = 65) then
    keyLeft:= False;

  if (Key = VK_RIGHT) or (Key = 68) then
    keyRight:= False;
    
  if (Key = VK_UP) or (Key = 87) or (Key = 32) then
    keyUp:= False;
end;

procedure TForm1.LoadMap(FileName: string);
var
  Xi, Yi: Integer;
begin
  list:= TStringList.Create;
  list.LoadFromFile('bin\Levels\' + FileName);
  for Yi:= 0 to list.Count - 1 do
    for Xi:= 0 to Length(list.Strings[Yi]) do
      case list.Strings[Yi][Xi] of
        'x':
          begin
            with TBloks.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('blok');
              x:= (Xi - 1) * Width;
              y:= Yi * Height;
            end;
          end;

        'm':
          begin
            with TMonets.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('monets');
              x:= (Xi - 1) * 32;
              y:= Yi * 32;
              AnimSpeed:= 15;
              life:= true;
            end;
          end;

        'e':
          begin
            SetLength(EnemyArray, enemyCount+1);
            EnemyArray[enemyCount]:= TEnemy.Create(AdSpriteEngine);
            with EnemyArray[enemyCount] do
            begin
              Image:= AdImageList.Find('enemy');
              x:= (Xi - 1) * 32;
              y:= Yi * 32;
              AnimSpeed:= 10;
              dx:= 0.05;
              Speed:= 120;
              life:= true;
            end;
            Inc(enemyCount);
          end;

        'p':
          begin
            Hero:= THero.Create(AdSpriteEngine);
            with Hero do
            begin
              Image:= AdImageList.Find('hero');
              x:= (Xi - 1) * 32;
              y:= Yi * 32;
              AnimActive:= False;
              AnimSpeed:= 7;
              Speed:= 150;
              life:= True;
              key:= false;
            end;
          end;

        'w':
          begin
            with TExit.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('doorExit');
              x:= (Xi - 1) * 32;
              y:= Yi * 32;
            end;
          end;
          
        'k':
          begin
            with TKey.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('key');
              x:= (Xi - 1) * 32;
              y:= Yi * 32;
            end;
          end;
      end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Halt;
  Form1.Destroy;
  Form2.Destroy;
  Form3.Destroy;
  Form4.Destroy;
end;

end.
