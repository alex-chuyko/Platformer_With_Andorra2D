unit Enemy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdSprites;

type
  TEnemy = class (TImageSprite)
  public
    Speed: Integer;
    life: Boolean;
    dx: Double;
    procedure DoMove(TimeGap:double);override;
    constructor Create(AParent:TSprite);override;
    procedure DoCollision(Sprite:TSprite; var Done:boolean);override;
  end;

implementation

uses Main, Hero;

{ TEnemy }

constructor TEnemy.Create(AParent: TSprite);
begin
  inherited;

end;

procedure TEnemy.DoCollision(Sprite: TSprite; var Done: boolean);
begin
  inherited;
  if (Sprite is TBloks) and ((list[Round(Sprite.Y + 1) div 32][Round(Sprite.X) div 32 + 1] = 'x') or (list[Round(Sprite.Y + 1) div 32][Round(Sprite.X) div 32 - 1] = 'x')) then
  begin
    dx:= dx * (-1);
    if dx > 0 then
      Image:= AdImageList.Find('enemy_back')
    else
      Image:= AdImageList.Find('enemy');
  end;
end;

procedure TEnemy.DoMove(TimeGap: double);
begin
  inherited;
  x:= x + dx * Form1.AdPerCounter.TimeGap;
  Collision;
end;

end.

