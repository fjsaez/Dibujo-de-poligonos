{    Dibujo de polígonos v1.0

   Autor: Ing. Francisco J. Sáez S.

   Desarrollado en Delphi XE10.2 Berlin (Starter)

   Aplicación simple que dibuja un polígono irregular a partir de coordenadas
   contenidas en un archivo CSV.
   Sólo se emplearon componentes nativos.

   Calabozo, 31 de diciembre de 2017.

}


program DibPoligono;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {FPrinc},
  Vcl.Themes,
  Vcl.Styles,
  About in 'About.pas' {AboutBox},
  ListaCoords in 'ListaCoords.pas' {FListaCoords},
  UtilDibujo in 'UtilDibujo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Dibujo de polígonos v1.0';
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
