unit UtilDibujo;

interface

uses
  System.Types, Vcl.Graphics, Vcl.Forms;

type
  TRango = record
    Inicio,Fin: TPoint;
    Ancho,Alto: integer;
    Proporcion: single;
  end;

  TCoord = record
    E,N: string;
  end;
 
  //el registro de parámetros:
  TParametros = record
    TotalPuntos,
    AnchoPBox,
    AltoPBox: integer;
    Coord: array of TPoint;
  end;

  TPoligono = class
    TotalPuntos,            //el total de puntos del polígono
    AltoPantalla,           //alto (pixeles) del paintbox-margen Y
    AnchoPantalla,          //ancho (pixeles) del paintbox-margen X
    AnchoPaintBox,          //ancho (pixeles) del paintbox
    AltoPaintBox,           //alto (pixeles) del paintbox
    MedioX,                 //punto de inicio X (pixeles) para centrar polígono
    MedioY,                 //punto de inicio Y (pixeles) para centrar polígono
    PoliAncho,              //el ancho real del polígono
    PoliAlto: integer;      //el alto real del polígono
    FProp: double;          //factor de proporción
    Origen,
    Destino: TRect;
    PoliMayor,              //valor máximo real X e Y del polígono
    PoliMenor,              //valor mínimo real X e Y del polígono
    Margen,                 //margen X e Y de polígono en pantalla
    EsqIzq,                 //rango de coords donde se enmarcarán los dibujos
    EsqDer: TPoint;         //
    ImgCNum,ImgSNum: TBitmap;
    PtoDib: array of TPoint;
    public
      constructor CrearPoligono(Param: TParametros);
      procedure   CopiarImagen(CnvOrg,CnvDst: TCanvas);
      procedure   PegarImagen(Canv: TCanvas; Opc: boolean);
      function    CoordGeoACanvas(Coord: integer; Opc: byte): integer;
      function    CoordCanvasAGeo(Coord: integer; Opc: byte): integer;
      procedure   ObtenerRangoCoord(var Rng: TRango);
    private

  end;

  var
    Lista: array of TCoord;
    Poligono: TPoligono;

  procedure MostrarVentana(AClass: TFormClass);

implementation

procedure MostrarVentana(AClass: TFormClass);
begin
  with AClass.Create(Application) do
    try
      BorderIcons:=[biSystemMenu];
      BorderStyle:=bsSingle;
      //Color:=;
      KeyPreview:=true;
      Position:=poScreenCenter;
      ShowModal;
    finally Free;
  end;
end;

//****** La clase TPoligono *********************//

constructor TPoligono.CrearPoligono(Param: TParametros);
var
  I: integer;
begin
  Margen.X:=50;   // Estos márgenes son para escribir las coordenadas de las
  Margen.Y:=20;    // cuadrículas
  //dimensiones del paintbox donde se dibujará el polígono:
  AnchoPaintBox:=Param.AnchoPBox;
  AltoPaintBox:=Param.AltoPBox;
  AnchoPantalla:=AnchoPaintBox-(Margen.X*2);
  AltoPantalla:=AltoPaintBox-(Margen.Y*2);
  //las esquinas del cuadro:
  EsqIzq.X:=Margen.X-1;
  EsqIzq.Y:=Margen.Y-1;
  EsqDer.X:=AnchoPaintBox-EsqIzq.X-1;
  EsqDer.Y:=AltoPaintBox-EsqIzq.Y-1;
  //se crean los bitmaps para guardar las imágenes temporales de polígonos:
  ImgCNum:=TBitmap.Create;
  ImgSNum:=TBitmap.Create;
  ImgCNum.SetSize(AnchoPaintBox,AltoPaintBox);
  ImgSNum.SetSize(AnchoPaintBox,AltoPaintBox);
  //se determina las coords mayores y menores del listado de puntos (X e Y):
  PoliMayor.X:=0;
  PoliMayor.Y:=0;
  PoliMenor.X:=Param.Coord[0].X;
  PoliMenor.Y:=Param.Coord[0].Y;
  TotalPuntos:=Param.TotalPuntos;
  for I:=0 to TotalPuntos-1 do
  begin
    if PoliMayor.X<Param.Coord[I].X then PoliMayor.X:=Param.Coord[I].X;
    if PoliMayor.Y<Param.Coord[I].Y then PoliMayor.Y:=Param.Coord[I].Y;
    if PoliMenor.X>Param.Coord[I].X then PoliMenor.X:=Param.Coord[I].X;
    if PoliMenor.Y>Param.Coord[I].Y then PoliMenor.Y:=Param.Coord[I].Y;
  end;
  //se determinan las dimensiones del polígono:
  PoliAncho:=PoliMayor.X-PoliMenor.X;
  PoliAlto:=PoliMayor.Y-PoliMenor.Y;
  if PoliAncho>PoliAlto then FProp:=AltoPantalla/PoliAncho
                        else FProp:=AltoPantalla/PoliAlto;
  MedioX:=Round((AnchoPantalla-(PoliAncho*FProp))/2);
  MedioY:=Round((AltoPantalla-(PoliAlto*FProp))/2);
  //se carga el array con las coordenadas de pantalla:
  SetLength(PtoDib,TotalPuntos);
  for I:=0 to Param.TotalPuntos-1 do
  begin
    PtoDib[I].X:=CoordGeoACanvas(Param.Coord[I].X,1);
    PtoDib[I].Y:=CoordGeoACanvas(Param.Coord[I].Y,2);
  end;
end;

procedure TPoligono.CopiarImagen(CnvOrg,CnvDst: TCanvas);
begin
  Destino.Top:=0;
  Destino.Left:=0;
  Destino.Right:=AnchoPaintBox;
  Destino.Bottom:=AltoPaintBox;
  Origen:=Destino;
  CnvDst.CopyRect(Destino,CnvOrg,Origen);
end;

procedure TPoligono.PegarImagen(Canv: TCanvas; Opc: boolean);
begin
  if Opc then Canv.CopyRect(Origen,ImgCNum.Canvas,Destino)
         else Canv.CopyRect(Origen,ImgSNum.Canvas,Destino);
end;

function TPoligono.CoordGeoACanvas(Coord: Integer; Opc: byte): integer;
begin
  if Opc=1 then
    Result:=Round((Coord-PoliMenor.X)*FProp)+MedioX+(Margen.X)
  else Result:=Round((Coord-PoliMenor.Y)*FProp)+MedioY+(Margen.Y);
end;

function TPoligono.CoordCanvasAGeo(Coord: integer; Opc: byte): integer;
begin
  if Opc=1 then
    Result:=Round(Coord*AltoPantalla/FProp)
  else Result:=Round(Coord*AltoPantalla/FProp);
end;

procedure TPoligono.ObtenerRangoCoord(var Rng: TRango);
var
  CoordGeo,CoordCnv: TPoint;
begin
  //la primera coord geográfica X:
  CoordGeo.X:=PoliMenor.X;
  CoordCnv.X:=1;
  while CoordCnv.X>=0 do
  begin
    CoordCnv.X:=CoordGeoACanvas(CoordGeo.X,1);
    CoordGeo.X:=CoordGeo.X-1;
  end;
  Rng.Inicio.X:=CoordGeo.X;
  //la primera coord geográfica Y:
  CoordGeo.Y:=PoliMenor.Y;
  CoordCnv.Y:=1;
  while CoordCnv.Y>=0 do
  begin
    CoordCnv.Y:=CoordGeoACanvas(CoordGeo.Y,2);
    CoordGeo.Y:=CoordGeo.Y-1;
  end;
  Rng.Inicio.Y:=CoordGeo.Y;
  //la última coord geográfica X:
  CoordGeo.X:=PoliMayor.X;
  CoordCnv.X:=1;
  while CoordCnv.X<Poligono.AnchoPaintBox do
  begin
    CoordCnv.X:=CoordGeoACanvas(CoordGeo.X,1);
    CoordGeo.X:=CoordGeo.X+1;
  end;
  Rng.Fin.X:=CoordGeo.X;
  //la última coord geográfica Y:
  CoordGeo.Y:=PoliMayor.Y;
  CoordCnv.Y:=1;
  while CoordCnv.Y<Poligono.AltoPaintBox do
  begin
    CoordCnv.Y:=CoordGeoACanvas(CoordGeo.Y,2);
    CoordGeo.Y:=CoordGeo.Y+1;
  end;
  Rng.Fin.Y:=CoordGeo.Y;
  //los demás cálculos:
  Rng.Ancho:=Rng.Fin.X-Rng.Inicio.X;
  Rng.Alto:=Rng.Fin.Y-Rng.Inicio.Y;
  Rng.Proporcion:=Rng.Alto/Poligono.AltoPaintBox;
end;

//********* Fin clase TPoligono ******************//

end.
