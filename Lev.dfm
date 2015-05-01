object Form4: TForm4
  Left = 754
  Top = 311
  Width = 416
  Height = 539
  Caption = 'Levels'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btn2: TButton
    Left = 139
    Top = 120
    Width = 105
    Height = 42
    Caption = 'Level 1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tempus Sans ITC'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 0
    OnClick = btn2Click
  end
  object btn1: TButton
    Left = 139
    Top = 184
    Width = 105
    Height = 42
    Caption = 'Level 2'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tempus Sans ITC'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
    OnClick = btn1Click
  end
  object xpmnfst1: TXPManifest
    Left = 368
    Top = 24
  end
end
