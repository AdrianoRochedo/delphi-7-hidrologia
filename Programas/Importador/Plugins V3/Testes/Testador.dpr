program Testador;

uses
  shareMem,
  windows,
  SysUtils;

var h: THandle;
    //p: TProc;
begin
  h := LoadLibrary('Excel.dll');
  try
    if h <> 0 then
       begin
{
       @p := GetProcAddress(h, pChar(Edit1.Text));
       try
         if @p <> nil then
            try
              p()
            except
              on E: Exception do
                 ShowMessage(E.Message)
            end
         else
            ShowMessage('Rotina não encontrada');
       except
         // nada
         end;
}
       end;
  finally
    if h <> 0 then FreeLibrary(h);
  end;
end.
 