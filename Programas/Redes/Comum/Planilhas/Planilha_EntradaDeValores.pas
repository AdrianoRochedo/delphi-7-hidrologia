unit Planilha_EntradaDeValores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Frame_Planilha, Menus, ExtCtrls, Buttons;

type
  TPlanilhaEntradaDeValores = class(TForm)
    FramePlanilha: TFramePlanilha;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function EntrarValores_e_SalvarComoTexto(
              const DirInicial: String;
              const NumValores: Integer = 0): String; // retorna o nome do arquivo salvo ou vazio

implementation
uses vcf1;

{$R *.dfm}

function EntrarValores_e_SalvarComoTexto(const DirInicial: String;
                                         const NumValores: Integer = 0): String;
var Save: TSaveDialog;
    d: TPlanilhaEntradaDeValores;
begin
  Result := '';
  Save := TSaveDialog.Create(nil);
  Save.InitialDir := DirInicial;
  Save.Filter := 'Arquivos Texto (*.txt)|*.txt';
  Save.DefaultExt := 'txt';
  Save.Title := 'Salvar os dados da planilha em ...';
  Save.Options := Save.Options + [ofOverwritePrompt];

  d := TPlanilhaEntradaDeValores.Create(nil);
  d.FramePlanilha.btnSalvar.Enabled := false;
  d.FramePlanilha.Menu_Salvar.Enabled := false;
  d.FramePlanilha.Menu_Abrir.Enabled := false;
  if NumValores > 0 then
     d.FramePlanilha.Tab.MaxRow := NumValores;

  d.ShowModal;

  if Save.Execute then
     begin
     d.FramePlanilha.Tab.Write(Save.FileName, vcf1.F1FileTabbedText);
     Result := Save.FileName;
     end;

  d.Free;
  Save.Free;
end;

end.
