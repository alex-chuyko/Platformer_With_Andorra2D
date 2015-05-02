unit Hero;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,AdSprites;

type
  THero = class(TImageSprite)
    private
    protected

    public
      life: Boolean;
      n: Integer;
      dx: Double;
      dy: Double;
      key: Boolean;
      Speed: integer;
      onGround: Boolean;
      procedure DoMove(TimeGap:double);override;
      constructor Create(AParent:TSprite);override;
      procedure DoCollision(Sprite:TSprite; var Done:boolean);override;
  end;


implementation

uses Main, Enemy, Lev;

{ THero }

constructor THero.Create(AParent: TSprite);
begin
  inherited;
  onGround:= true;
end;

procedure MyCollision(flag: Boolean);
var
  i, j: integer;
begin
  if flag then
      begin
        if (Form1.Hero.dx < 0) then
          for j:= (Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x) div 32) do
            if (list[Round(Form1.hero.y) div 32][j + 1] = 'x') then
              Form1.Hero.x:= j * 32 + Form1.Hero.Width;
        if (Form1.Hero.dx > 0) then
          for j:= (Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x + Form1.Hero.Width) div 32) do
            if (list[Round(Form1.hero.y) div 32][j + 1] = 'x') then
              Form1.Hero.x:= j * 32 - Form1.Hero.Width;
      end;

  if not flag then
      begin
        if (Form1.Hero.dy < 0) then
          for i:= (Round(Form1.hero.y) div 32) to (Round(Form1.hero.y) div 32) do
            if (list[i][(Round(Form1.hero.x + Form1.Hero.Width - 1)) div 32 + 1] = 'x') or (list[i][(Round(Form1.hero.x)) div 32 + 1] = 'x') then
            begin
              Form1.Hero.y:= i * 32 + 32;
              Form1.Hero.dy:= 0;
            end;
        if (Form1.Hero.dy > 0) then
          for i:= (Round(Form1.hero.y + Form1.Hero.Height) div 32) to (Round(Form1.hero.y + Form1.Hero.Height) div 32) do
            if (list[i][(Round(Form1.hero.x + Form1.Hero.Width - 1)) div 32 + 1] = 'x') or (list[i][(Round(Form1.hero.x)) div 32 + 1] = 'x') then
            begin
              Form1.Hero.y:= i * 32 - Form1.Hero.height;
              Form1.Hero.dy:= 0;
              Form1.Hero.onGround:= True;
            end;
      end;
  Form1.Hero.Collision;
end;

procedure THero.DoCollision(Sprite: TSprite; var Done: boolean);
begin
  if (Sprite is TBloks) or ((Sprite is TExit) and (not key)) then
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

  if Sprite is TKey then
  begin
    TKey(Sprite).Dead;
    key:= true;
  end;

  if Sprite is TMonets then
  begin
    TMonets(Sprite).Dead;
    n:= n + 10;
  end;

 { if (Sprite is TDead) then//or (Sprite is TEnemy)  then
  begin
    Form1.keyRight:= false;
    Form1.keyUp:= false;
    Form1.keyLeft:= false;
    onGround:= true;
    Form1.Hero.dy:= 0;
    Form1.Hero.dx:= 0;
    ShowMessage('GAME OVER! :(');
    life:= false;
    //Form1.keyRight:= false;
    Form1.Hide;
    Form4.Show;
    Form1.Hero.Dead;
    //Form1.Hero.Dead;
    //Halt;
  end; }
  
  if Sprite is TEnemy then
    TEnemy(Sprite).Dead;

  if (Sprite is TExit) and (key) then
  begin
    Form1.Hero.dx:= 0;
    Form1.Hero.dy:= 0;
    Form4.btn1.Enabled:= true;
    Form1.keyRight:= false;
    Form1.Hide;
    Form4.Show;
    Form1.Hero.Dead;
  end;
end;


procedure THero.DoMove(TimeGap: double);
var
  Done: Boolean;
begin
  inherited;
  AnimActive:= True;
  if (Form1.keyLeft) then
    begin
      Form1.Hero.dx:= -0.2;
      AnimLoop:= True;
    end;
  if (Form1.keyRight) then
    begin
      Form1.Hero.dx:= 0.2;
      AnimLoop:= True;
    end;
      if (Form1.keyUp) and (y > 0) then
        if Form1.Hero.onGround then
        begin
          Form1.Hero.dy:= -0.4;
          Form1.Hero.onGround:= False;
        end;

  if (not Form1.keyLeft) and (not Form1.keyRight) then
    AnimActive:= false;
    //Collision;

  if life then
  begin
    with Form1.Hero do
    begin
      X:= X + dx * Form1.AdPerCounter.TimeGap;
      Done:= True;
      MyCollision(Done);
      if (not onGround)then// or (list[Round(Form1.Hero.Y) div 32][Round(Form1.Hero.X) div 32] <> 'x')then
        dy:= dy + 0.0007 * Form1.AdPerCounter.TimeGap;
      y:= y + dy * Form1.AdPerCounter.TimeGap;
      onGround:= False;
      Done:= False;
      MyCollision(Done);
      dx:= 0;
      //Collision;
    end;
  end
  else
    Halt;

  with Form1 do
  begin
    if (Form1.Hero.X > 385) and (Form1.Hero.X < 2337) then
      AdSpriteEngine.x:= - Self.X - Self.Width / 2 + AdDraw.Width / 2;
  end;

  Collision;
end;

end.
