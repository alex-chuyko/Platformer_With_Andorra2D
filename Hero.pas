unit Hero;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,AdSprites;

type
  THero = class(TImageSprite)
    private
    protected

    public
      dx: Double;
      dy: Double;
      maxJump: Integer;
      Speed: integer;
      SpeedG: integer;
      onGround: Boolean;
      procedure Ground(Sprite: TSprite);
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
    end;
  {if Sprite is TBloks then
  begin
    if (Form1.keyRight) then
      x:= TBloks(Sprite).x - Self.Width + 0.5
    else
    if (Form1.keyLeft) then
      x:= TBloks(Sprite).x + TBloks(Sprite).Width - 0.5
    else
    if (Form1.keyUp) then
      y:= TBloks(Sprite).Y + TBloks(Sprite).Height
    else
    if not onGround then
      y:= TBloks(Sprite).Y - Self.Height;
  end;}

end;

procedure MyCollision(flag: Boolean);
var
  i, j: integer;
begin
  //ShowMessage(IntToStr(Round(Form1.hero.y) div 32)+ ' --- ' + IntToStr(Round(Form1.Hero.x) div 32));
  if flag then
    for j:= (Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x + Form1.Hero.Width) div 32) do
    begin
      //ShowMessage(IntToStr(i)+ ' --- ' + IntToStr(j));
      if (list[Round(Form1.hero.y) div 32][j + 1] = 'x') then
      begin
        if (Form1.Hero.dx < 0) and (flag = True) then
          Form1.Hero.x:= j * 32 + 32;
        if (Form1.Hero.dx > 0) and (flag = true) then
          Form1.Hero.x:= j * 32 - Form1.Hero.Width;

      end;
    end;
  if not flag then
    for i:= (Round(Form1.hero.y) div 32) to (Round(Form1.hero.y + Form1.Hero.Height) div 32) do
      if (list[i][Round(Form1.hero.x) div 32] = 'x') then
      begin
        if (Form1.Hero.dy < 0) and (flag = false) then
        begin
          Form1.Hero.y:= i * 32 + 32;
          Form1.Hero.dy:= 0;
        end;
        if (Form1.Hero.dy > 0) and (flag = false) then
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
  if (Form1.keyRight) and (x < Form1.AdDraw.Width - Form1.Hero.Width) then
    begin
      Form1.Hero.dx:= 0.2;
      //AnimStart:= 0;
      //AnimStop:= 6;
      //x:= x + Speed * TimeGap;
      //Form1.Hero.Ground(Form1.Hero);
    end;
      if (Form1.keyUp) {and (y > 0) and (onGround) and (list[Round(y) div 32 + 1][Round(x) div 32 + 1] = 'x')} then
        if Form1.Hero.onGround then
        begin
          Form1.Hero.dy:= -1;
          Form1.Hero.onGround:= False;
          //y:= y - (Speed {+ 10000) * TimeGap;
        //Form1.Hero.Ground(Form1.Hero);
        end;

  if (not Form1.keyLeft) and (not Form1.keyRight) then
    AnimActive:= false;

  with Form1.Hero do
  begin
    X:= X + dx * Form1.AdPerCounter.TimeGap;
    Done:= True;
    MyCollision(Done);
    if (not onGround) then // and (y < (list.Count+1) * 32) then
      dy:= dy + 0.003 * Form1.AdPerCounter.TimeGap;
    y:= y + dy * Form1.AdPerCounter.TimeGap;
    Done:= False;
    MyCollision(Done);
    dx:= 0;
  end;

  with Form1 do
  begin
    if Form1.Hero.X > 385 then
      AdSpriteEngine.x:= - Self.X - Self.Width / 2 + AdDraw.Width / 2;
    //AdSpriteEngine.Y:= - Self.Y - Self.Height / 2 + AdDraw.Height / 2;
  end;

  {if (list[Round(y) div 32 + 1][Round(x) div 32] <> 'x') then
    onGround:= False
  else
    onGround:= True;
  if not onGround then
  begin
    Form1.Hero.y:= Form1.Hero.y + (Speed - 50) * TimeGap;

  end; }

  //Collision;
end;

procedure THero.Ground(Sprite: TSprite);
begin
  inherited;
  if Collision = 0 then
  begin
    Y:= Y + 0.1 * Form1.AdPerCounter.TimeGap;
    //Collision;
  end;
end;

end.
