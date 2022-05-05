unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, UnitConversor, StdCtrls, QDialogs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FConversor: TConversor;
  public
    property Conversor : TConversor read FConversor write FConversor;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Dir : widestring;
begin
  Dir := '';
  if not DirectoryExists(Conversor.InputDir) then
     begin
     SelectDirectory('Selecione o diretório de entrada','',dir);
     Conversor.InputDir := Dir;
     Dir := '';
     end;

  if not DirectoryExists(Conversor.OutputDir) then
     begin
     SelectDirectory('Selecione o diretório de saida','',Dir);
     Conversor.OutputDir := Dir;
     end;

  Conversor.Execute;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FConversor := TConversor.Create;
end;

end.
