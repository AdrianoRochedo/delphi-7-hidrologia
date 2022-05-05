library CN;

uses
  SysUtils,
  Classes,
  JanelaPrincipal in '..\JanelaPrincipal.pas' {foPrincipal},
  dlg_Dados in '..\dlg_Dados.pas' {dlgDados};

{$R *.res}

  function ObterCN(Validar: Boolean): Real;
  begin
    Result := JanelaPrincipal.ObterCN(Validar);
  end;

exports
  ObterCN;

begin
end.
