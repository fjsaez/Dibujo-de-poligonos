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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PB1: TPaintBox
    Left = 0
    Top = 42
    Width = 726
    Height = 410
    Cursor = crCross
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
    OnMouseMove = PB1MouseMove
    OnPaint = PB1Paint
    ExplicitLeft = 64
    ExplicitTop = 173
    ExplicitWidth = 630
    ExplicitHeight = 249
  end
  object Panel: TPanel
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
      Left = 40
      Top = 10
      Width = 81
      Height = 22
      Caption = 'Abrir CSV'
      OnClick = SBAbrirClick
    end
    object SpeedButton1: TSpeedButton
      Left = 691
      Top = 10
      Width = 23
      Height = 22
      Hint = 'Acerca...'
      Anchors = [akRight, akBottom]
      Caption = ';-D'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SBLista: TSpeedButton
      Left = 144
      Top = 10
      Width = 121
      Height = 22
      Caption = 'Lista de coordenadas'
      Enabled = False
      OnClick = SBListaClick
    end
    object CBNumPtos: TCheckBox
      Left = 520
      Top = 13
      Width = 129
      Height = 17
      Caption = 'Numeraci'#243'n de puntos'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 0
      Visible = False
      OnClick = CBNumPtosClick
    end
    object ChBPuntero: TCheckBox
      Left = 303
      Top = 13
      Width = 106
      Height = 17
      Caption = 'Puntero del rat'#243'n'
      TabOrder = 1
      Visible = False
      OnClick = ChBPunteroClick
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
        Width = 220
      end
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 100
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
