unit Lev;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TForm4 = class(TForm)
    xpmnfst1: TXPManifest;
    btn2: TButton;
    btn1: TButton;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    flag: integer;
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Main, Menu, Pause;

{$R *.dfm}

procedure TForm4.btn2Click(Sender: TObject);
begin
  Form4.Hide;
  Form1.Destroy;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form1.SetFocus;
end;

procedure TForm4.btn1Click(Sender: TObject);
begin
  flag:= 1;
  Form4.Hide;
  Form1.Destroy;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form1.SetFocus;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Halt;
  Form1.Destroy;
  Form2.Destroy;
  Form3.Destroy;
  Form4.Destroy;
end;

end.
