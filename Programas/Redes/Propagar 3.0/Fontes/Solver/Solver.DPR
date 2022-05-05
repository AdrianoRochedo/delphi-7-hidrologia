PROGRAM Solver;

uses
  Forms,
  lp_form in '..\..\..\..\..\..\Outros\LP\lp_form.pas' {lpForm},
  fernform in '..\..\..\..\..\..\Outros\LP\Fernform.pas' {tfernform};

{$R *.RES}

begin
  Application.Initialize;
  Application.HelpFile := 'LP.hlp';
  Application.CreateForm(TlpForm, lpForm);
  Application.CreateForm(Ttfernform, tfernform);
  Application.Run();
end.
