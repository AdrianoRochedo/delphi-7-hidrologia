program CN;

uses Windows;

{$R *.res}

var h: THandle;
    F: function(Validar: Boolean): Real;
begin
  h := LoadLibrary('CN.DLL');
  if h <> 0 then
     begin
     @F := GetProcAddress(h, 'ObterCN');
     F(False);
     FreeLibrary(h);
     end;
end.
