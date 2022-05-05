program TestaIsaregDLL;

uses
  Windows,
  Dialogs,
  SysUtils;

type
  T1 = array[0..163] of char;
  T2 = char;

  TProc = procedure(var p1: T1;
                    var p2: T2); stdcall;


  var s: ShortString = 'F:\Projetos\Hidrologia\Programas\Redes\Propagar 2.5\Exemplos\FlavioVitoria';

    procedure ExecutarIsareg();
    var ExecIsareg: TProc;
        h: THandle;
        i: integer;
        s1: T1;
        s2: T2;
    begin
      fillChar(s1, sizeof(s1), #0);
      move(s[1], s1, Length(s));
      s2 := '0';
      showMessage(s1);

      h := Windows.LoadLibrary('Isareg.dll');
      if h <> 0 then
         try
         @ExecIsareg := Windows.GetProcAddress(h, 'isareg');
         if @ExecIsareg <> nil then
           begin
           ExecIsareg(s1, s2);
           end
         else
            Dialogs.ShowMessage('Ponto de entrada da "Isareg.dll" não encontrado.')
         finally
            Windows.FreeLibrary(h);
         end
      else
         Dialogs.ShowMessage('"Isareg.dll" não encontrada.');
    end;

begin
  ExecutarIsareg();
  Dialogs.ShowMessage('executado com sucesso:');
end.
