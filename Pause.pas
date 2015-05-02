unit Pause;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, jpeg, ExtCtrls;

type
  TForm3 = class(TForm)
    xpmnfst1: TXPManifest;
    btn1: TButton;
    btn2: TButton;
    img1: TImage;
    btn3: TButton;
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
  Menu, Main;

{$R *.dfm}

procedure TForm3.btn1Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.btn2Click(Sender: TObject);
begin
  Halt;
end;

procedure TForm3.btn3Click(Sender: TObject);
begin
  Form3.Close;
  Form1.Hide;
  Form2.ShowModal;
end;

end.
