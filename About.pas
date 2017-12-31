unit About;

interface

uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Autor: TLabel;
    Fecha: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.FormShow(Sender: TObject);
begin
  ProductName.Caption:=Application.Title;
  Autor.Caption:='Autor: Ing. Francisco J. Sáez S.';
  Comments.Caption:='Dibuja un polígono a partir de coodenadas UTM contenidas '+
                    'en un archivo .CSV';
  Fecha.Caption:='Calabozo, Diciembre de 2017';
end;

end.

