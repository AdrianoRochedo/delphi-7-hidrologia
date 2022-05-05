library cd_Lavouras;

// Compilar o projeto sem otimizacao
// Verificar "DiretivasDeCompilacao" antes da compilacao final

{%File 'Parametros.txt'}
{%ToDo 'cd_Lavouras.todo'}

uses
  ShareMem,
  Classes,
  Dialogs,
  SysUtils,
  SysUtilsEx,
  Plugin,
  Graphics,
  Forms,
  DiretivasDeCompilacao,
  Frame_TreeViewObjects in '..\..\..\..\..\..\..\..\Comum\Frames\Frame_TreeViewObjects.pas' {TreeViewObjects: TFrame},
  cd_ClassesBase in 'cd_ClassesBase.pas',
  cd_Classes in 'cd_Classes.pas',
  cd_Frame_Sensibilidade in 'cd_Frame_Sensibilidade.pas' {frSensibilidade: TFrame},
  cd_Form_TransferirDados in 'cd_Form_TransferirDados.pas' {foTransferirDados},
  cd_Form_DadosGerais in 'cd_Form_DadosGerais.pas' {foDadosGerais},
  cd_Form_Selecionar_Man_Res in 'cd_Form_Selecionar_Man_Res.pas' {foSel_Man_Res},
  cd_Form_EstimativasEconomicas in 'cd_Form_EstimativasEconomicas.pas' {foEstimativasEconomicas},
  cd_Form_Arvore in 'cd_Form_Arvore.pas' {foMain},
  cd_GR_Demandas in 'cd_GR_Demandas.pas' {foGR_Demandas},
  cd_GR_Indices in 'cd_GR_Indices.pas' {foGR_Indices},
  cd_GR_IndicesMedios in 'cd_GR_IndicesMedios.pas' {foGR_IndicesMedios},
  cd_Form_AnaliseDeSensibilidade in 'cd_Form_AnaliseDeSensibilidade.pas' {foAnaliseDeSens},
  SpreadSheetBook_Frame in '..\..\..\..\..\..\..\..\Lib\SpreadSheet\SpreadSheetBook_Frame.pas' {SpreadSheetBookFrame: TFrame},
  SpreadSheetBook in '..\..\..\..\..\..\..\..\Lib\SpreadSheet\SpreadSheetBook.pas',
  pr_Interfaces in '..\..\..\Unidades\pr_Interfaces.pas';

{$R *.res}
{$R Imagens.res}

type

  TFactory = class(T_NRC_InterfacedObject, IObjectFactory)
  private
    FBM_Lavoura: TBitmap;
  public
    function ToString(): wideString;
    procedure Release();
    function getName(): wideString;
    function CreateObject(const ClassName: wideString): TObject;
    function getBitmap(const ClassName: wideString): TBitmap;
  end;

var
  FPlugin: TPlugin = nil;

  function getPlugin(): TPlugin;
  var f: TFactory;
  begin
    if FPlugin = nil then
       FPlugin := TPlugin.Create(TFactory.Create());

    Result := FPlugin;
  end;

exports
  getPlugin;

{ TFactory }

function TFactory.CreateObject(const ClassName: wideString): TObject;
begin
  Result := TCrop.Create();
end;

// Este nome não poderá mudar após os arquvos serem criados
function TFactory.getName(): wideString;
begin
  Result := 'Lavoura-Isareg 1.0';
end;

procedure TFactory.Release();
begin
  self.Free;
end;

function TFactory.ToString: wideString;
begin
  Result := 'Lavoura (Isareg)';
end;

// No hospedeiro, será utilizado o Handle do bitmap.
function TFactory.getBitmap(const ClassName: wideString): TBitmap;
begin
  if FBM_Lavoura = nil then
     FBM_Lavoura := TBitmap.Create();

  FBM_Lavoura.LoadFromResourceName(HInstance, 'LAVOURA_20X20');
  Result := FBM_Lavoura;   
end;

begin
  SysUtils.DecimalSeparator := '.';
end.
