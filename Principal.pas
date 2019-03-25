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
    ChBPuntero: TCheckBox;
    procedure SBAbrirClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PB1Paint(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CBNumPtosClick(Sender: TObject);
    procedure SBListaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PB1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ChBPunteroClick(Sender: TObject);
  private
    { Private declarations }
    procedure DibujarRejilla;
    procedure LimpiarPaintBox;
    procedure InvertirCoordenadas(Canv: TCanvas; Alto,PosY: integer);
    //procedure ObtenerRangoCoord(Rng: TRango);
  public
    { Public declarations }
  end;

var
  FPrinc: TFPrinc;
  Prm: TParametros;
  PtoGeo: TPoint;
  Rango: TRango;

implementation

uses ListaCoords,About;

{$R *.dfm}

procedure TFPrinc.LimpiarPaintBox;
begin
  PB1.Canvas.Brush.Color:=clWhite;
  PB1.Canvas.Brush.Style:=bsClear;
  PB1.Canvas.FillRect(PB1.Canvas.ClipRect);
end;

procedure TFPrinc.InvertirCoordenadas(Canv: TCanvas; Alto,PosY: integer);
var
  aHandle : HDC;
begin
  aHandle:=Canv.Handle;
// set Mapmode
  SetMapMode(aHandle,MM_ANISOTROPIC);
  SetWindowExtEx(aHandle,10000,-10000,nil);
  SetViewportExtEx(aHandle,10000,10000,nil);
  SetViewportOrgEx(aHandle,0,(PosY*2)+Alto-1,nil);
end;

procedure TFPrinc.CBNumPtosClick(Sender: TObject);
begin
  Poligono.PegarImagen(PB1.Canvas,CBNumPtos.Checked);
end;

procedure TFPrinc.ChBPunteroClick(Sender: TObject);
begin
  if not ChBPuntero.Checked then
  begin
    SBar.Panels[4].Text:='';
    SBar.Panels[5].Text:='';
    SBar.Panels[4].Width:=0;
    SBar.Panels[5].Width:=0;
  end;
end;

procedure TFPrinc.DibujarRejilla;
var
  EsqIzq,EsqDer,Inicio,Posc: TPoint;
  Intervalo,Mayor: integer;
begin
  if Poligono.PoliAncho>Poligono.PoliAlto then
    Mayor:=Poligono.PoliAncho
  else Mayor:=Poligono.PoliAlto;
  //esto es una prueba mientras se me ocurre algo mejor. mejorar este método:
  Intervalo:=10;
  if (Mayor>=50) and (Mayor<=100) then Intervalo:=10;
  if (Mayor>100) and (Mayor<=500) then Intervalo:=100;
  if (Mayor>500) and (Mayor<=1000) then Intervalo:=200;
  if (Mayor>1000) and (Mayor<=5000) then Intervalo:=500;
  if (Mayor>5000) and (Mayor<=10000) then Intervalo:=1000;
  if (Mayor>10000) then Intervalo:=2000;
  //las esquinas del cuadro:
  EsqIzq:=Poligono.EsqIzq;
  EsqDer:=Poligono.EsqDer;
  //las fuentes y color de líneas:
  PB1.Canvas.Pen.Color:=clSilver;
  PB1.Canvas.Font.Size:=7;
  PB1.Canvas.Font.Color:=clBlue;
  //se determina el punto donde comienzan a trazarse las verticales:
  Inicio.X:=Poligono.PoliMenor.X;
  while Inicio.X mod Intervalo <> 0 do Inicio.X:=Inicio.X-1;
  Posc.X:=Poligono.CoordGeoACanvas(Inicio.X,1);
  //se busca la coord Y inicial:
  while Poligono.CoordGeoACanvas(Inicio.X-Intervalo,1)>EsqIzq.X do
  begin
    Inicio.X:=Inicio.X-Intervalo;
    Posc.X:=Poligono.CoordGeoACanvas(Inicio.X,1);
  end;
  //se trazan las líneas verticales:
  while Posc.X<EsqDer.X do
  begin
    PB1.Canvas.MoveTo(Posc.X,EsqDer.Y);
    PB1.Canvas.LineTo(Posc.X,EsqIzq.Y);
    PB1.Canvas.TextOut(Posc.X-(PB1.Canvas.TextWidth(Inicio.X.ToString) div 2),
                       EsqIzq.Y,Inicio.X.ToString);
    PB1.Canvas.TextOut(Posc.X-(PB1.Canvas.TextWidth(Inicio.X.ToString) div 2),
      EsqDer.Y+PB1.Canvas.TextHeight(Inicio.X.ToString),Inicio.X.ToString);
    Inicio.X:=Inicio.X+Intervalo;
    Posc.X:=Poligono.CoordGeoACanvas(Inicio.X,1);
  end;
  //se determina el punto donde comienzan a trazarse las horizontales:
  Inicio.Y:=Poligono.PoliMenor.Y;
  while Inicio.Y mod Intervalo<>0 do Inicio.Y:=Inicio.Y-1;
  Posc.Y:=Poligono.CoordGeoACanvas(Inicio.Y,2);
  //se busca la coord X inicial:
  while Poligono.CoordGeoACanvas(Inicio.Y-Intervalo,2)>EsqIzq.Y do
  begin
    Inicio.Y:=Inicio.Y-Intervalo;
    Posc.Y:=Poligono.CoordGeoACanvas(Inicio.Y,2);
  end;
  //se trazan las líneas horizontales:
  while Posc.Y<EsqDer.Y do
  begin
    PB1.Canvas.MoveTo(EsqIzq.X,Posc.Y);
    PB1.Canvas.LineTo(EsqDer.X,Posc.Y);
    PB1.Canvas.TextOut(EsqIzq.X-(PB1.Canvas.TextWidth(Inicio.Y.ToString))-2,
      Posc.Y+(PB1.Canvas.TextHeight(Inicio.Y.ToString) div 2),Inicio.Y.ToString);
    PB1.Canvas.TextOut(EsqDer.X+2,Posc.Y+(PB1.Canvas.TextHeight(Inicio.Y.ToString) div 2),
                       Inicio.Y.ToString);
    Inicio.Y:=Inicio.Y+Intervalo;
    Posc.Y:=Poligono.CoordGeoACanvas(Inicio.Y,2);
  end;
  //el marco:
  PB1.Canvas.Pen.Color:=clBlack;
  PB1.Canvas.Rectangle(EsqIzq.X,EsqIzq.Y,EsqDer.X,EsqDer.Y);
  Poligono.ObtenerRangoCoord(Rango);
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
  SBar.Panels[0].Text:=' Resolución pantalla: '+Screen.Width.ToString+' x '+
                       Screen.Height.ToString;
  SBar.Panels[0].Width:=SBar.Canvas.TextWidth(SBar.Panels[0].Text)+20;
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  Panel.Color:=$FDE9D9;
end;

procedure TFPrinc.PB1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pos: TPoint;
  Ancho: byte;
begin
  Pos.X:=Rango.Inicio.X+Round(X*Rango.Proporcion);
  Pos.Y:=Rango.Fin.Y-Round(Y*Rango.Proporcion);
  SBar.Panels[4].Text:='';
  SBar.Panels[5].Text:='';
  Ancho:=0;
  if ChBPuntero.Checked then
  begin
    SBar.Panels[4].Text:=' Coords geográficas: '+Pos.X.ToString+','+Pos.Y.ToString;
    SBar.Panels[5].Text:=' Coords canvas: '+X.ToString+','+Y.ToString;
    Ancho:=20;
  end;
  SBar.Panels[4].Width:=SBar.Canvas.TextWidth(SBar.Panels[4].Text)+Ancho;
  SBar.Panels[5].Width:=SBar.Canvas.TextWidth(SBar.Panels[5].Text)+Ancho;
end;

procedure TFPrinc.PB1Paint(Sender: TObject);
var
  I: integer;
begin
  if Assigned(Poligono) then
  begin
    LimpiarPaintBox;
    InvertirCoordenadas(PB1.Canvas,PB1.Height,PB1.Top);
    DibujarRejilla;
    //dibujo y relleno del polígono:
    PB1.Canvas.Brush.Color:=clSkyBlue;
    PB1.Canvas.Brush.Style:=bsDiagCross;
    PB1.Canvas.Pen.Color:=clBlack;
    PB1.Canvas.Polygon(Poligono.PtoDib);
    InvertirCoordenadas(Poligono.ImgSNum.Canvas,PB1.Height,PB1.Top);
    Poligono.CopiarImagen(PB1.Canvas,Poligono.ImgSNum.Canvas);
    //numeración de los puntos:
    if CBNumPtos.Checked then
    begin
      PB1.Canvas.Font.Color:=clRed;
      PB1.Canvas.Font.Size:=7;
      for I:=0 to Poligono.TotalPuntos-1 do
        PB1.Canvas.TextOut(Poligono.PtoDib[I].X,Poligono.PtoDib[I].Y,' V'+IntToStr(I+1));
      InvertirCoordenadas(Poligono.ImgCNum.Canvas,PB1.Height,PB1.Top);
      Poligono.CopiarImagen(PB1.Canvas,Poligono.ImgCNum.Canvas);
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
      ChBPuntero.Visible:=true;
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
      SBar.Panels[1].Text:=' Área dibujo: '+
        IntToStr(Poligono.AnchoPantalla)+' x '+IntToStr(Poligono.AltoPantalla);
      SBar.Panels[2].Text:=' Dimensiones polígono: '+
        IntToStr(Poligono.PoliAncho)+' x '+IntToStr(Poligono.PoliAlto)+' ';
      SBar.Panels[3].Text:=' Vértices: '+IntToStr(Poligono.TotalPuntos);
      for I:=1 to 3 do
        SBar.Panels[I].Width:=SBar.Canvas.TextWidth(SBar.Panels[I].Text)+20;
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

end.      //387    298
