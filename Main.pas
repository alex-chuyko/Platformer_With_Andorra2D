unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdDraws, AdClasses, AdTypes, AdSprites, AdPerformanceCounter, Hero, Enemy,
  ExtCtrls, UShot;

type
  TDead = class (TImageSprite)
  end;

type
  TBloks = class (TImageSprite)
  end;

type
  TMonets = class (TImageSprite)
  end;

type
  TExit = class (TImageSprite)
  end;

type
  TKey = class (TImageSprite)
  end;

{type
  TEnemy = class (TImageSprite)
    Speed: Integer;
    dx: Double;
    procedure ECollision(Sprite: TSprite);
    procedure EMove;
  end; }

type
  TForm1 = class(TForm)
    img1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure img1Click(Sender: TObject);
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

    procedure Idle(Sender:TObject; var Done: boolean);
    procedure LoadMap(FileName: string);
    { Public declarations }
  end;

var
  Form1: TForm1;
  list: TStringList;
  AdImageList: TAdImageList;
  Shot: TShot;

implementation

uses
  Menu, Pause, Lev, DateUtils;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  levelName: string;
begin
  AdDraw := TAdDraw.Create(self);
  AdDraw.DllName := 'AndorraOGL.dll';
  with AdDraw.Display do
  begin
    Width:= 800; //800
    Height:= 480; //750
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
var
  todey: string;
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
        todey:= TimeToStr(now);
        TextOut(640, 450, 'Time: ' + todey);
        //TextOut(5, 5,'FPS: ' + FloatToStr(AdPerCounter.FPS));
        Pen.Color:= Ad_ARGB(255,0,0,0);
        Font:= AdDraw.Fonts.GenerateFont('Comic Sans MS',15, [afItalic]);
        TextOut(5, 450,'Points: ' + IntToStr(Hero.n));
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
  if (Key = VK_UP) or (Key = 87) then
    keyUp:= True;
  if Key = 27 then
  begin
    Form3.Show;
    Form3.SetFocus;
  end;
  {if Key = VK_CONTROL then
  begin
    {with TShot.Create(AdSpriteEngine) do
    begin
      Image:= AdImageList.Find('ball');
      x:= (Hero.X + Hero.Width);
      y:= Hero.Y + Hero.Height;
      dx:= 0.5;
    end;
    //Shot.DoMove(AdPerCounter.TimeGap);
  end;}
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_LEFT) or (Key = 65) then
    keyLeft:= False;
  if (Key = VK_RIGHT) or (Key = 68) then
    keyRight:= False;
  if (Key = VK_UP) or (Key = 87) then
    keyUp:= False;
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
            end;
          end;
        'e':
          begin
            SetLength(EnemyArray, enemyCount+1);
            EnemyArray[enemyCount]:= TEnemy.Create(AdSpriteEngine);
            with EnemyArray[enemyCount] do
            begin
              Image:= AdImageList.Find('enemy_back');
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
        's':
          begin
            with TShot.Create(AdSpriteEngine) do
            begin
              Image:= AdImageList.Find('bloks');
              x:= (Xi - 1) * Width;
              y:= Yi * Height;
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

procedure TForm1.img1Click(Sender: TObject);
begin
  Halt;
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
