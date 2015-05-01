unit UShot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdSprites, AdDraws, AdClasses, AdTypes;

type
  TShot = class (TImageSprite)
    dx: Double;
    piv: TImageSprite;
    constructor Create(AParent:TSprite);override;
    procedure DoMove(TimeGap:double);override;
    procedure DoCollision(Sprite:TSprite; var Done:boolean);override;
  public
    AdSpriteEngine: TSpriteEngine;
  end;

implementation

uses
  DateUtils, Main;

{ TShot }

constructor TShot.Create(AParent: TSprite);
begin
  inherited;

end;

procedure TShot.DoCollision(Sprite: TSprite; var Done: boolean);
begin
  inherited;
  if (Sprite is TBloks) then
    Sprite.Destroy;
end;

procedure TShot.DoMove(TimeGap: double);
begin
  inherited;
  {with piv.Create(AdSpriteEngine) do
  begin}
    //piv.Image:= Main.AdImageList.Find('ball');
    //piv.x:= Main.Shot.X;
    //piv.y:= Main.Shot.Y;
  //end;
  //piv.X:= piv.X + dx * TimeGap;
  Collision;
end;

end.
