unit Hero;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,AdSprites;

type
  THero = class(TImageSprite)
    private
    protected

    public
      n: Integer;
      dx: Double;
      dy: Double;
      maxJump: Integer;
      Speed: integer;
      SpeedG: integer;
      onGround: Boolean;
      procedure DoMove(TimeGap:double);override;
      constructor Create(AParent:TSprite);override;
      procedure DoCollision(Sprite:TSprite; var Done:boolean);override;
  end;


implementation

uses Main;

{ THero }

constructor THero.Create(AParent: TSprite);
begin
  inherited;

end;

procedure THero.DoCollision(Sprite: TSprite; var Done: boolean);
//var
  //i, j: integer;
begin
  {for i:= (Round(Form1.hero.y) div 32) to (Round(Form1.hero.y + Form1.Hero.Height) div 32) do
    for j:=(Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x + Form1.Hero.Width) div 32) do
    begin
      if (list[i][j] = 'x') then
      begin
        if (Form1.Hero.dx < 0) and (Done) then
          Form1.Hero.x:= j * 32 + 32;
        if (Form1.Hero.dx > 0) and (Done) then
          Form1.Hero.x:= i * 32 - Form1.Hero.width;
        if (Form1.Hero.dy < 0) and (not Done) then
        begin
          Form1.Hero.y:= i * 32 + 32;
          Form1.Hero.dy:= 0;
        end;
        if (Form1.Hero.dy > 0) and (not Done) then
        begin
          Form1.Hero.y:= i * 32 - Form1.Hero.height;
          Form1.Hero.dy:= 0;
          Form1.Hero.onGround:= True;
        end;
      end;
    end; }
  if Sprite is TBloks then
  begin
    if (Form1.keyRight) and (list[Round(Form1.Hero.y + Form1.Hero.Width) div 32][Round(Form1.Hero.X) div 32] = 'x') then
      x:= TBloks(Sprite).x - Self.Width + 0.5
    else
    if (Form1.keyLeft) and (list[Round(Form1.Hero.y) div 32][Round(Form1.Hero.X) div 32] = 'x') then
      x:= TBloks(Sprite).x + TBloks(Sprite).Width - 0.5
    else
    if (Form1.keyUp) and (list[Round(Form1.Hero.y) div 32][Round(Form1.Hero.X - Form1.Hero.Height) div 32] = 'x') then
      y:= TBloks(Sprite).Y + TBloks(Sprite).Height
    else
    if (not onGround) and (list[Round(Form1.Hero.y) div 32][Round(Form1.Hero.X + Form1.Hero.Height) div 32] <> 'x') then
    begin
      y:= TBloks(Sprite).Y - Self.Height;
      onGround:= True;
    end;
  end;
  if Sprite is TMonets then
  begin
      TMonets(Sprite).Dead;
      n:= n + 10;
  end;
  if Sprite is TDead then
  begin
    Form1.Hero.Dead;
    ShowMessage('GAME OVER! :(');
    //dy:= 0;
    //Form1.FormDestroy(Form1);
  end;
end;

procedure MyCollision(flag: Boolean);
var
  i, j: integer;
begin
  if flag then
      begin
        if (Form1.Hero.dx < 0) then
          //for j:= (Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x + Form1.Hero.Width) div 32) do
            if (list[Round(Form1.hero.y) div 32][Round(Form1.Hero.x) div 32 + 1] = 'x') then
              Form1.Hero.x:= Round(Form1.Hero.x);
        if (Form1.Hero.dx > 0) then
          for j:= (Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x + Form1.Hero.Width) div 32) do
            if (list[Round(Form1.hero.y) div 32][j + 1] = 'x') then
              Form1.Hero.x:= j * 32 - Form1.Hero.Width;
      end;

  if not flag then
      begin
        if (Form1.Hero.dy < 0) then
          for i:= (Round(Form1.hero.y - Form1.Hero.Height) div 32) to (Round(Form1.hero.y) div 32) do
            if (list[i][Round(Form1.hero.x) div 32 + 1] = 'x') then
            begin
              Form1.Hero.y:= i * 32 + 32;
              Form1.Hero.dy:= 0;
            end;
        if (Form1.Hero.dy > 0) then
          for i:= (Round(Form1.hero.y) div 32) to (Round(Form1.hero.y + Form1.Hero.Height) div 32) do
            if (list[i][Round(Form1.hero.x) div 32 + 1] = 'x') then
            begin
              Form1.Hero.y:= i * 32 - Form1.Hero.height;
              Form1.Hero.dy:= 0;
              Form1.Hero.onGround:= True;
            end;
      end;
end;

procedure THero.DoMove(TimeGap: double);
var
  i, j: integer;
  Done: Boolean;
begin
  inherited;
  AnimActive:= True;
  if (Form1.keyLeft){ and (x > 0)} then
    begin
      Form1.Hero.dx:= -0.2;
      //x:= x - Speed * TimeGap;
      AnimLoop:= True;
    end;
  if (Form1.keyRight) {and (x < Form1.AdDraw.Width - Form1.Hero.Width)} then
    begin
      Form1.Hero.dx:= 0.2;
      //x:= x + Speed * TimeGap;
    end;
      if (Form1.keyUp) and (y > 0) then
        if Form1.Hero.onGround then
        begin
          Form1.Hero.dy:= -0.32;
          Form1.Hero.onGround:= False;
          //y:= y - (Speed + 10000) * TimeGap;
        end;

  if (not Form1.keyLeft) and (not Form1.keyRight) then
    AnimActive:= false;
    Collision;
  with Form1.Hero do
  begin
    X:= X + dx * Form1.AdPerCounter.TimeGap;
    Done:= True;
    MyCollision(Done);
    if (not onGround) or (list[Round(Form1.Hero.Y) div 32][Round(Form1.Hero.X) div 32] <> 'x')then
      dy:= dy + 0.0007 * Form1.AdPerCounter.TimeGap;
    y:= y + dy * Form1.AdPerCounter.TimeGap;
    onGround:= False;
    Done:= False;
    MyCollision(Done);
    dx:= 0;
    Collision;                     
  end;

  with Form1 do
  begin
    if (Form1.Hero.X > 385) then
      AdSpriteEngine.x:= - Self.X - Self.Width / 2 + AdDraw.Width / 2;
    //AdSpriteEngine.Y:= - Self.Y - Self.Height / 2 + AdDraw.Height / 2;
  end;

  {if (list[Round(Form1.Hero.Y) div 32][Round(Form1.Hero.X + Form1.Hero.Height) div 32] <> 'x') then
    onGround:= False
  else
    onGround:= True;
  if not onGround then
  begin
    Form1.Hero.y:= Form1.Hero.y + (Speed - 50) * TimeGap;

  end; }

  Collision;

  //Form1.Enemy.EMove;
  //Form1.Enemy.ECollision(Form1.Enemy);
end;

end.
