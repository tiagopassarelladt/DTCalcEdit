object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Demo - DTCalcEdit'
  ClientHeight = 135
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 140
    Top = 19
    Width = 8
    Height = 13
    Caption = '+'
  end
  object Label3: TLabel
    Left = 140
    Top = 62
    Width = 8
    Height = 13
    Caption = '='
  end
  object Button2: TButton
    Left = 309
    Top = 55
    Width = 108
    Height = 25
    Cursor = crHandPoint
    Caption = 'somar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object DTCalcEdit1: TDTCalcEdit
    Left = 13
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    DisplayFormat = '#,##0.00'
    HabilitaValorExtenso = False
    SimboloMoedaVisivel = False
  end
  object DTCalcEdit2: TDTCalcEdit
    Left = 154
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 1
    DisplayFormat = '#,##0.00'
    HabilitaValorExtenso = False
    SimboloMoedaVisivel = False
  end
  object DTCalcEdit3: TDTCalcEdit
    Left = 154
    Top = 57
    Width = 121
    Height = 21
    TabOrder = 3
    DisplayFormat = '#,##0.00'
    HabilitaValorExtenso = True
    SimboloMoedaVisivel = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 96
    Width = 434
    Height = 39
    Align = alBottom
    Color = 16772810
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 4
    StyleElements = [seBorder]
  end
end
