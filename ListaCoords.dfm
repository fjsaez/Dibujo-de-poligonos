object FListaCoords: TFListaCoords
  Left = 0
  Top = 0
  Caption = 'Lista de coordenadas'
  ClientHeight = 474
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 433
    Width = 408
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 367
    object Button1: TButton
      Left = 166
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cerrar'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object SGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 408
    Height = 433
    Align = alClient
    Color = clMoneyGreen
    ColCount = 3
    Ctl3D = True
    DefaultColWidth = 130
    FixedColor = clBlue
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnDrawCell = SGridDrawCell
    RowHeights = (
      24)
  end
end
