object FPrinc: TFPrinc
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Dibujo de pol'#237'gonos'
  ClientHeight = 471
  ClientWidth = 726
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PB1: TPaintBox
    Left = 0
    Top = 42
    Width = 726
    Height = 410
    ParentCustomHint = False
    Align = alClient
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnPaint = PB1Paint
    ExplicitLeft = 8
    ExplicitTop = 56
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 42
    Align = alTop
    Color = 16776176
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      726
      42)
    object SBAbrir: TSpeedButton
      Left = 64
      Top = 8
      Width = 81
      Height = 22
      Caption = 'Abrir CSV'
      OnClick = SBAbrirClick
    end
    object SpeedButton1: TSpeedButton
      Left = 688
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Acerca...'
      Anchors = [akRight, akBottom]
      Caption = ';-D'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object CBNumPtos: TCheckBox
      Left = 184
      Top = 13
      Width = 129
      Height = 17
      Caption = 'Numeraci'#243'n de puntos'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 0
      OnClick = CBNumPtosClick
    end
  end
  object SBar: TStatusBar
    Left = 0
    Top = 452
    Width = 726
    Height = 19
    Color = clWhite
    Panels = <
      item
        Width = 200
      end
      item
        Width = 230
      end
      item
        Width = 300
      end
      item
        Width = 300
      end
      item
        Width = 150
      end>
    ParentShowHint = False
    ShowHint = True
  end
  object OpenDlg: TOpenDialog
    DefaultExt = '*.csv'
    Filter = 'Archivo CSV|*.csv'
    Title = 'Abrir archivo CSV'
    Left = 88
    Top = 120
  end
end
