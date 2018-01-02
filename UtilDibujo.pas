unit UtilDibujo;

interface

uses
  System.Types, Vcl.Graphics, Vcl.Forms;

type
  TCoord = record
    E,N: string;
  end;
  TPos = record
    X,Y: integer;
  end;
  //el registro de parámetros:
  TParametros = record
    TotalPuntos,
    AnchoPBox,
    AltoPBox: integer;
    Coord: array of TPos;
  end;

  TPoligono = class
    TotalPuntos,            //el total de puntos del polígono
    AltoPantalla,           //alto (pixeles) del paintbox-margen Y
    AnchoPantalla,          //ancho (pixeles) del paintbox-margen X
    EspAlto,                //la diferencia entre paintbox.alto-poligono.alto
    EspAncho,               //la diferencia entre paintbox.ancho-poligono.ancho
    DibAltoY,               //el alto del dibujo
    DibAnchoX,              //el ancho del dibujo
    AnchoPaintBox,          //ancho (pixeles) del paintbox
    AltoPaintBox,           //alto (pixeles) del paintbox
    MargenX,                //margen X de polígono en pantalla
    MargenY,                //margen Y de polígono en pantalla
    MedioX,
    MedioY,
    PoliMayorX,             //valor máximo real X del polígono
    PoliMayorY,             //valor mínimo real X del polígono
    PoliMenorX,             //valor máximo real Y del polígono
    PoliMenorY,             //valor mínimo real Y del polígono
    PoliAncho,              //el ancho real del polígono
    PoliAlto: integer;      //el alto real del polígono
    FProp: double;          //factor de proporción
    Origen,
    Destino: TRect;
    ImgCNum,ImgSNum: TBitmap;
    PtoDib: array of TPoint;
    public
      constructor CrearPoligono(Param: TParametros);
      procedure CopiarImagen(CnvOrg,CnvDst: TCanvas);
      procedure PegarImagen(Canv: TCanvas; Opc: boolean);
      function  CoordGeoACanvas(Coord: integer; Opc: byte): integer;
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
  MargenX:=100;   // Estos márgenes son para escribir las coordenadas de las
  MargenY:=40;    // cuadrículas
  //dimensiones del paintbox donde se dibujará el polígono:
  AnchoPaintBox:=Param.AnchoPBox;
  AltoPaintBox:=Param.AltoPBox;
  AnchoPantalla:=AnchoPaintBox-MargenX;
  AltoPantalla:=AltoPaintBox-MargenY;
  //se crean los bitmaps para guardar las imágenes temporales de polígonos:
  ImgCNum:=TBitmap.Create;
  ImgSNum:=TBitmap.Create;
  ImgCNum.SetSize(AnchoPaintBox,AltoPaintBox);
  ImgSNum.SetSize(AnchoPaintBox,AltoPaintBox);
  //se determina las coords mayores y menores del listado de puntos (X e Y):
  PoliMayorX:=0;
  PoliMayorY:=0;
  PoliMenorX:=Param.Coord[0].X;
  PoliMenorY:=Param.Coord[0].Y;
  TotalPuntos:=Param.TotalPuntos;
  for I:=0 to TotalPuntos-1 do
  begin
    if PoliMayorX<Param.Coord[I].X then PoliMayorX:=Param.Coord[I].X;
    if PoliMayorY<Param.Coord[I].Y then PoliMayorY:=Param.Coord[I].Y;
    if PoliMenorX>Param.Coord[I].X then PoliMenorX:=Param.Coord[I].X;
    if PoliMenorY>Param.Coord[I].Y then PoliMenorY:=Param.Coord[I].Y;
  end;
  //se determinan las dimensiones del polígono:
  PoliAncho:=PoliMayorX-PoliMenorX;
  PoliAlto:=PoliMayorY-PoliMenorY;
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
    result:=Round((Coord-PoliMenorX)*FProp)+MedioX+(MargenX div 2)
  else result:=Round((Coord-PoliMenorY)*FProp)+MedioY+(MargenY);
end;

//********* Fin clase TPoligono ******************//

end.
