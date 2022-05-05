program Generico;

uses
  Forms,
  JanelaPrincipal in 'JanelaPrincipal.PAS' {Principal},
  xx_AreaDeProjeto in 'xx_AreaDeProjeto.pas' {xxAreaDeProjeto},
  xx_Classes in 'xx_Classes.pas',
  xx_GerenteDeResultados in 'xx_GerenteDeResultados.pas',
  xx_Dialogo_SubBacia in 'Dialogos\xx_Dialogo_SubBacia.pas' {xxDialogo_SubBacia},
  Frame_PromotionList in '..\..\..\..\..\Comum\Frames\Frame_PromotionList.pas' {frPL: TFrame},
  hidro_Classes in '..\..\..\..\..\Comum\Hidro\hidro_Classes.pas',
  hidro_Tipos in '..\..\..\..\..\Comum\Hidro\hidro_Tipos.pas',
  hidro_Variaveis in '..\..\..\..\..\Comum\Hidro\hidro_Variaveis.pas',
  hidro_Constantes in '..\..\..\..\..\Comum\Hidro\hidro_Constantes.pas',
  hidro_AreaDeProjeto in '..\..\..\..\..\Comum\Hidro\hidro_AreaDeProjeto.PAS',
  hidro_Dialogo in '..\..\..\..\..\Comum\Hidro\hidro_Dialogo.pas' {HidroDialogo},
  hidro_Dialogo_Projeto in '..\..\..\..\..\Comum\Hidro\hidro_Dialogo_Projeto.pas' {HidroDialogo_Projeto},
  hidro_Form_LayersManager in '..\..\..\..\..\Comum\Hidro\hidro_Form_LayersManager.pas'; {HidroForm_LayersManager}

{$R *.res}

var Principal: TPrincipal;
begin
  Application.Initialize;
  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
