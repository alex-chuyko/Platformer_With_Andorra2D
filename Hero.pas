unit Hero;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdSprites, MmSystem;

type
  THero = class(TImageSprite)
    private
    protected

    public
      life: Boolean;
      points: Integer;
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

uses
  Main, Enemy, Lev;

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
            if (list[Round(Form1.hero.y) div 32][j + 1] = 'x') or ((list[Round(Form1.hero.y) div 32][j + 1] = 'w') and (not Form1.Hero.key)) then
              Form1.Hero.x:= j * 32 + Form1.Hero.Width;
        if (Form1.Hero.dx > 0) then
          for j:= (Round(Form1.Hero.x) div 32) to (Round(Form1.Hero.x + Form1.Hero.Width) div 32) do
            if (list[Round(Form1.hero.y) div 32][j + 1] = 'x') or ((list[Round(Form1.hero.y) div 32][j + 1] = 'w') and (not Form1.Hero.key)) then
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
end;

procedure THero.DoCollision(Sprite: TSprite; var Done: boolean);
var
  flag: Boolean;
  i, j: integer;
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

  if (Sprite is TMonets) and (TMonets(Sprite).life) then
  begin
    TMonets(Sprite).Dead;
    TMonets(Sprite).life:= false;
    points:= points + 10;
  end;

  if (Sprite is TEnemy) then
  begin
    flag:= false;
    if dy > 0 then
    begin
      TEnemy(Sprite).Dead;
      TEnemy(Sprite).life:= false;
      dy:= -0.4;
      points:= points + 5;
      flag:= true;
    end;
  end;

  if Sprite is TEnemy then
  begin
    if (not flag) and (TEnemy(Sprite).life) then
    begin
      dx:= 0;
      dy:= 0;
      Form1.keyRight:= false;
      Application.MessageBox(PChar('GAME OVER! :(' + #13 + #10 + 'Ваш результат:  ' + IntToStr(points) + ' очков' + #13 + #10 +
                                   'Затраченное время: ' + Form1.timeLevel), PChar('GAME OVER'), MB_MODEMASK);
      Form1.Destroy;
      Application.CreateForm(TForm4, Form4);
      Form4.ShowModal;
      Form1.Hero.Dead;
      Form1.Hero.life:= false;
    end;
  end;

  if (Sprite is TExit) and (key) then
  begin
    dx:= 0;
    dy:= 0;
    Form1.keyRight:= false;
    Application.MessageBox(PChar('Поздравляем! Вы прошли уровень!' + #13 + #10 + 'Ваш результат:  ' + IntToStr(points) + ' очков'+ #13 + #10 +
                                 'Затраченное время: ' + Form1.timeLevel), PChar('Уровень пройден!'), MB_MODEMASK);
    Form1.Destroy;
    Application.CreateForm(TForm4, Form4);
    if Form4.flag = 0 then
      Form4.btn1.Enabled:= true;
    Form4.ShowModal;
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

  if life then
  begin
    with Form1.Hero do
    begin
      X:= X + dx * Form1.AdPerCounter.TimeGap;

      Done:= True;
      MyCollision(Done);

      if (not onGround) then
        dy:= dy + 0.0007 * Form1.AdPerCounter.TimeGap;
      y:= y + dy * Form1.AdPerCounter.TimeGap;
      onGround:= False;

      Done:= False;
      MyCollision(Done);
      
      dx:= 0;
    end;
  end
  else
    Form1.Destroy;

  with Form1 do
  begin
    if (Form1.Hero.X > 385) and (Form1.Hero.X < 2337) then
      AdSpriteEngine.x:= - Self.X - Self.Width / 2 + AdDraw.Width / 2;
  end;

  Collision;
end;

end.
