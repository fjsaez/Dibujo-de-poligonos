unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, System.Types, UtilDibujo;

type
  TFPrinc = class(TForm)
    PB1: TPaintBox;
    Panel: TPanel;
    SBAbrir: TSpeedButton;
    OpenDlg: TOpenDialog;
    CBNumPtos: TCheckBox;
    SBar: TStatusBar;
    SpeedButton1: TSpeedButton;
    SBLista: TSpeedButton;
    procedure SBAbrirClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PB1Paint(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CBNumPtosClick(Sender: TObject);
    procedure SBListaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure DibujarRejilla;
    procedure LimpiarPaintBox;
    procedure InvertirCoordenadas(Canv: TCanvas);
  public
    { Public declarations }
  end;

var
  FPrinc: TFPrinc;
  Prm: TParametros;

implementation

uses ListaCoords,About;

{$R *.dfm}

procedure TFPrinc.LimpiarPaintBox;
begin
  PB1.Canvas.Brush.Color:=clWhite;
  PB1.Canvas.Brush.Style:=bsClear;
  PB1.Canvas.FillRect(PB1.Canvas.ClipRect);
end;

procedure TFPrinc.InvertirCoordenadas(Canv: TCanvas);
var
  Org,Ext: TPoint;
begin
  Org:=Point(0,ClientHeight);
  Ext:=Point(1,-1);
  SetMapMode(Canv.Handle,mm_Anisotropic);
  SetWindowOrgEx(Canv.Handle,Org.X,Org.Y,nil);
  SetViewportExtEx(Canv.Handle,ClientWidth,ClientHeight,nil);
  SetWindowExtEx(Canv.Handle,Ext.X*ClientWidth,Ext.Y*ClientHeight,nil);
end;

procedure TFPrinc.CBNumPtosClick(Sender: TObject);
begin
  Poligono.PegarImagen(PB1.Canvas,CBNumPtos.Checked);
end;

procedure TFPrinc.DibujarRejilla;
var
  X1,Y1,X2,Y2,         //rango de coords donde se enmarcarán los dibujos
  PosX,PosY,           //variables de prueba solamente
  Intervalo,Mayor,InicioX,InicioY: integer;
begin
  if Poligono.PoliAncho>Poligono.PoliAlto then Mayor:=Poligono.PoliAncho
                                          else Mayor:=Poligono.PoliAlto;
  //esto es una prueba mientras se me ocurre algo mejor. mejorar este método:
  Intervalo:=0;
  if (Mayor>=50) and (Mayor<=100) then Intervalo:=10;
  if (Mayor>100) and (Mayor<=500) then Intervalo:=100;
  if (Mayor>500) and (Mayor<=1000) then Intervalo:=500;
  if (Mayor>1000) and (Mayor<=10000) then Intervalo:=1000;
  if (Mayor>10000) then Intervalo:=2000;
  //las esquinas del cuadro:
  X1:=Poligono.MargenX div 2;
  Y1:=Poligono.MargenY;
  X2:=Poligono.AnchoPaintBox-(Poligono.MargenX div 2);
  Y2:=Poligono.AltoPaintBox;
  //las fuentes y color de líneas:
  PB1.Canvas.Pen.Color:=clSilver;
  PB1.Canvas.Font.Size:=7;
  PB1.Canvas.Font.Color:=clBlue;
  //se determina el punto donde comienzan a trazarse las verticales:
  InicioX:=Poligono.PoliMenorX;
  while InicioX mod Intervalo <> 0 do InicioX:=InicioX-1;
  PosX:=Poligono.CoordGeoACanvas(InicioX,1);
  //se busca la coord Y inicial:
  while Poligono.CoordGeoACanvas(InicioX-Intervalo,1)>X1 do
  begin
    InicioX:=InicioX-Intervalo;
    PosX:=Poligono.CoordGeoACanvas(InicioX,1);
  end;
  //se trazan las líneas verticales:
  while PosX<X2 do
  begin
    PB1.Canvas.MoveTo(PosX,Y2);
    PB1.Canvas.LineTo(PosX,Y1);
    PB1.Canvas.TextOut(PosX-(PB1.Canvas.TextWidth(IntToStr(InicioX)) div 2),
                       Y1,IntToStr(InicioX));
    PB1.Canvas.TextOut(PosX-(PB1.Canvas.TextWidth(IntToStr(InicioX)) div 2),
             Y2+PB1.Canvas.TextHeight(IntToStr(InicioX)),IntToStr(InicioX));
    InicioX:=InicioX+Intervalo;
    PosX:=Poligono.CoordGeoACanvas(InicioX,1);
  end;
  //se determina el punto donde comienzan a trazarse las horizontales:
  InicioY:=Poligono.PoliMenorY;
  while InicioY mod Intervalo<>0 do InicioY:=InicioY-1;
  PosY:=Poligono.CoordGeoACanvas(InicioY,2);
  //se busca la coord X inicial:
  while Poligono.CoordGeoACanvas(InicioY-Intervalo,2)>Y1 do
  begin
    InicioY:=InicioY-Intervalo;
    PosY:=Poligono.CoordGeoACanvas(InicioY,2);
  end;
  //se trazan las líneas horizontales:
  while PosY<Y2 do
  begin
    PB1.Canvas.MoveTo(X1,PosY);
    PB1.Canvas.LineTo(X2,PosY);
    PB1.Canvas.TextOut(X1-(PB1.Canvas.TextWidth(IntToStr(InicioY)))-2,
      PosY+(PB1.Canvas.TextHeight(IntToStr(InicioY)) div 2),IntToStr(InicioY));
    PB1.Canvas.TextOut(X2+2,PosY+(PB1.Canvas.TextHeight(IntToStr(InicioY)) div 2),
                       IntToStr(InicioY));
    InicioY:=InicioY+Intervalo;
    PosY:=Poligono.CoordGeoACanvas(InicioY,2);
  end;
  //el marco:
  PB1.Canvas.Pen.Color:=clBlack;
  PB1.Canvas.Rectangle(X1,Y1,X2,Y2);
end;

procedure ExtraeCSV(Lista: TStringList; var VLista: array of TCoord);
var
  I,J,TotReg,Cont,TamCad: integer;
begin
  TotReg:=Lista.Count;
  for I:=0 to TotReg-1 do
  begin
    TamCad:=Length(Lista[I]);
    Cont:=1;
    while Copy(Lista[I],Cont,1)<>';' do
    begin
      VLista[I].E:=VLista[I].E+Copy(Lista[I],Cont,1);
      Cont:=Cont+1;
    end;
    for J:=Cont+1 to TamCad do VLista[I].N:=VLista[I].N+Copy(Lista[I],J,1);
  end;
end;

procedure TFPrinc.FormResize(Sender: TObject);
begin
  SBar.Panels[0].Text:=' Resolución de pantalla: '+IntToStr(Screen.Width)+' x '+
                       IntToStr(Screen.Height);
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  Panel.Color:=$FDE9D9;
end;

procedure TFPrinc.PB1Paint(Sender: TObject);
var
  I: integer;
begin
  if Assigned(Poligono) then
  begin
    InvertirCoordenadas(PB1.Canvas);
    LimpiarPaintBox;
    DibujarRejilla;
    with PB1.Canvas do
    begin
      //dibujo y relleno del polígono:
      PB1.Canvas.Brush.Color:=clSkyBlue;
      PB1.Canvas.Brush.Style:=bsDiagCross;
      PB1.Canvas.Pen.Color:=clBlack;
      PB1.Canvas.Polygon(Poligono.PtoDib);
      InvertirCoordenadas(Poligono.ImgSNum.Canvas);
      Poligono.CopiarImagen(PB1.Canvas,Poligono.ImgSNum.Canvas);
      //numeración de los puntos:
      if CBNumPtos.Checked then
      begin
        PB1.Canvas.Font.Color:=clRed;
        PB1.Canvas.Font.Size:=7;
        for I:=0 to Poligono.TotalPuntos-1 do
          TextOut(Poligono.PtoDib[I].X,Poligono.PtoDib[I].Y,' V'+IntToStr(I+1));
        InvertirCoordenadas(Poligono.ImgCNum.Canvas);
        Poligono.CopiarImagen(PB1.Canvas,Poligono.ImgCNum.Canvas);
      end;
    end;
  end;
end;

procedure TFPrinc.SBAbrirClick(Sender: TObject);
var
  CSV: TStringList;
  I,TotReg: integer;
begin
  OpenDlg.Execute();
  if OpenDlg.FileName<>'' then
  begin
    try
      Caption:=Application.Title+'  -  '+OpenDlg.FileName;
      CBNumPtos.Checked:=true;
      SetLength(Lista,0);
      FreeAndNil(Poligono);
      CSV:=TStringList.Create;
      CSV.LoadFromFile(OpenDlg.FileName);
      TotReg:=CSV.Count;
      SetLength(Lista,TotReg);
      ExtraeCSV(CSV,Lista);
      //se cargan los valores del registro-parámetro:
      PB1.Invalidate;  // 'limpia' el paintbox
      PB1.Canvas.ClipRect.Width:=PB1.Width;
      PB1.Canvas.ClipRect.Height:=PB1.Height;
      Prm.AnchoPBox:=PB1.Width;
      Prm.AltoPBox:=PB1.Height;
      Prm.TotalPuntos:=TotReg;
      SetLength(Prm.Coord,TotReg);
      for I:=0 to TotReg-1 do
      begin
        Prm.Coord[I].X:=StrToInt(Lista[I].E);
        Prm.Coord[I].Y:=StrToInt(Lista[I].N);
      end;
      Poligono:=TPoligono.CrearPoligono(Prm);
      CBNumPtos.Enabled:=true;
      SBLista.Enabled:=true;
      SBar.Panels[1].Text:=' Resolución área de dibujo: '+
      IntToStr(Poligono.AnchoPantalla)+' x '+IntToStr(Poligono.AltoPantalla);
      SBar.Panels[2].Text:=' X Menor: '+IntToStr(Poligono.PoliMenorX)+
                           ' / X Mayor: '+IntToStr(Poligono.PoliMayorX)+
                           ' / Ancho: '+IntToStr(Poligono.PoliAncho);
      SBar.Panels[3].Text:=' Y Menor: '+IntToStr(Poligono.PoliMenorY)+
                           ' / Y Mayor: '+IntToStr(Poligono.PoliMayorY)+
                           ' / Alto: '+IntToStr(Poligono.PoliAlto);
      SBar.Panels[4].Text:=' Total vértices: '+IntToStr(Poligono.TotalPuntos);
    finally
      CSV.Free;
    end;
  end;
end;

procedure TFPrinc.SBListaClick(Sender: TObject);
begin
  MostrarVentana(TFListaCoords);
end;

procedure TFPrinc.SpeedButton1Click(Sender: TObject);
begin
  MostrarVentana(TAboutBox);
end;

end.      //387
