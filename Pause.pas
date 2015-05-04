unit Pause;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, jpeg, ExtCtrls;

type
  TForm3 = class(TForm)
    xpmnfst1: TXPManifest;
    btn1: TButton;
    img1: TImage;
    btn3: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  Menu, Main, Lev;

{$R *.dfm}

procedure TForm3.btn1Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.btn3Click(Sender: TObject);
begin
  Halt;
  Form1.Destroy;
  Form2.Destroy;
  Form4.Destroy;
end;

procedure TForm3.btn2Click(Sender: TObject);
begin
  Form3.Hide;
  Form1.Destroy;
  Form2.Show;
end;

end.
