unit Planilha_DadosDosObjetos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, AxCtrls, OleCtrls, vcf1, 
  Planilha_base;

type
  TForm_Planilha_DadosDosObjetos = class(TForm_Planilha_Base)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TForm_Planilha_DadosDosObjetos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TForm_Planilha_DadosDosObjetos.FormCreate(Sender: TObject);
begin
  inherited;
  Tab.FixedCols := 1;
  Tab.FixedRows := 1;
  Tab.SetDefaultFont('ARIAL', 8);
end;

end.
