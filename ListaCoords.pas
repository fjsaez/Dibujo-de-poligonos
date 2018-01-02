unit ListaCoords;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ComCtrls, UtilDibujo;

type
  TFListaCoords = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    SGrid: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
  private
    { Private declarations }
    procedure CargarCoordenadas;
  public
    { Public declarations }
  end;

var
  FListaCoords: TFListaCoords;

implementation

{$R *.dfm}

procedure TFListaCoords.CargarCoordenadas;
var
  I: integer;
begin
  for I:=1 to Poligono.TotalPuntos do
  begin
    SGrid.RowCount:=SGrid.RowCount+1;
    SGrid.Cells[0,I]:='V'+IntToStr(I);
    SGrid.Cells[1,I]:=Lista[I-1].E;
    SGrid.Cells[2,I]:=Lista[I-1].N;
  end;
  SGrid.FixedRows:=1;
end;

procedure TFListaCoords.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFListaCoords.FormShow(Sender: TObject);
begin
  SGrid.Cells[0,0]:='N° Vértice';
  SGrid.Cells[1,0]:='Coord X';
  SGrid.Cells[2,0]:='Coord Y';
  CargarCoordenadas;
end;

procedure TFListaCoords.SGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
  Alineacion: TAlignment;
  AnchoTxt: Integer;
begin
  if (ARow=0) or (ACol=0) then Alineacion:=taCenter
                          else Alineacion:=taRightJustify;
  with SGrid.Canvas do
  begin
    Font.Color:=clBlack;
    if gdFixed in State then  //las columnas fijas:
    begin
      Brush.Color:=clSkyBlue;
      Font.Style:=[fsBold];
    end;
    sTexto:=SGrid.Cells[ACol,ARow];
    FillRect(Rect);
    AnchoTxt:=TextWidth(sTexto);
    if Alineacion=taCenter then
      TextOut(Rect.Left+((Rect.Right-Rect.Left)-AnchoTxt) div 2,Rect.Top+2,sTexto)
    else TextOut(Rect.Right-AnchoTxt-2,Rect.Top+2,sTexto);
  end;
end;

end.
