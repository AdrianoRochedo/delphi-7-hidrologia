unit Mapa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Listas, Execfile, sysUtil2, ba_Classes, ComCtrls, ExtCtrls;

type
  TMapa_DLG = class(TForm)
    StatusBar: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    Bitmap   : TBitmap;
    FPath    : String;
    FRegioes : TListaDeRegioes;
    MC       : TSharedMem;
    Dados    : TListaDeSubBacias;
  public
    procedure Processar(IndDados, indCenario: Integer);
  end;

Var
  Mapa_DLG: TMapa_DLG;

implementation
uses IniFiles, {ShellAPI,} Cenarios;

{$R *.DFM}

procedure TMapa_DLG.FormCreate(Sender: TObject);
begin
  MC := TSharedMem.Create('MC_PROGRAMA_PROPAGAR', 1024);

  FPath := ExtractFilePath(Application.ExeName);
  gDir  := FPath;

  Bitmap := TBitmap.Create;
  Bitmap.LoadFromFile(FPath + 'mapaBahia.bmp');

  if Screen.Width > 750 then
     begin
     ClientWidth  := Bitmap.Width;
     ClientHeight := Bitmap.Height + StatusBar.Height;
     end
  else
     begin
     Top := 1;
     Left := 1;
     ClientWidth  := 500;
     ClientHeight := 440;
     HorzScrollBar.Range := Bitmap.Width;
     VertScrollBar.Range := Bitmap.Height;
     end;

  HorzScrollBar.Range := Bitmap.Width;
  VertScrollBar.Range := Bitmap.Height;

  FRegioes := TListaDeRegioes.Create;
  FRegioes.LerDoArquivo(FPath + 'Regioes.map');

  Dados := TListaDeSubBacias.Create;
  Dados.LerDoArquivo;
end;

procedure TMapa_DLG.FormDestroy(Sender: TObject);
begin
  Dados.Free;
  MC.Free;
  FRegioes.Free;
  Bitmap.Free;
end;

procedure TMapa_DLG.FormPaint(Sender: TObject);
begin
  Canvas.Draw(-HorzScrollBar.Position, -VertScrollBar.Position, Bitmap);
end;

const
  AM_ABRIR_ARQUIVO        = WM_USER + 1000 + 1;
  AM_ABRIR_APAGAR_ARQUIVO = WM_USER + 1000 + 2;

procedure TMapa_DLG.Processar(IndDados, indCenario: Integer);
var s, s2  : String;
    Ini    : TMemIniFile;
    Arq    : String;
    OutArq : String;
begin
  OutArq := GetTempFile(WindowsTempDir, '000');
  Arq := Dados[IndDados].Cenarios[IndCenario].Arquivo;
  DecryptFile(1803, Arq, OutArq);

  Ini := TMemIniFile.Create(OutArq);
  s := Ini.ReadString('Projeto', 'Nome', '');
  if s <> '' then
     begin
     //s2 := ExtractFilePath(OutArq);
     Ini.WriteString('Dados ' + s, 'Dir. Saida', '');

     s2 := ExtractFilePath(Arq);
     Ini.WriteString('Dados ' + s, 'Dir. Pesquisa', s2);

     s2 := s2 + Ini.ReadString('Projeto', 'Fundo', '');
     Ini.WriteString('Projeto', 'Fundo', s2);

     Ini.UpdateFile;
     end;
  Ini.Free;

  if FindWindow('TprDialogo_Principal', nil) = 0 then
     begin
     //Exec.CommandLine := FPath + '\Bin\Propagar.exe';
     //Exec.Execute;

     //ShellExecute(0, 'open',
     //    pChar(FPath + 'Propagar\Propagar.exe'), nil, nil, SW_NORMAL);

     // Somente WinExec espera a inicialização da aplicação
     WinExec(pChar(FPath + 'Propagar\Propagar.exe SEMSPLASH'), SW_NORMAL);
     end;

  MC.AsString := OutArq;
  MessageToApplication('TprDialogo_Principal', AM_ABRIR_APAGAR_ARQUIVO, 0, 0);
end;

procedure TMapa_DLG.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, ii : Integer;
    d     : TCenarios_DLG;
    r     : Integer;
    p     : pPoint;
begin
  if Button = mbLeft then
     begin
     i := FRegioes.Existe(x+HorzScrollBar.Position, y+VertScrollBar.Position);
     if i > -1 then
        begin
        Delay(100);
        New(p);

        SetWindowOrgEx(Canvas.Handle, HorzScrollBar.Position, VertScrollBar.Position, p);
        InvertRgn(Canvas.Handle, FRegioes[i]);
        SetWindowOrgEx(Canvas.Handle, p.x, p.y, nil);

        Dispose(p);
        Delay(200);
        FormPaint(Sender);

        ii := Dados.IndicePeloNome(FRegioes.Nome[i]);
        if ii > -1 then
           begin
           d := TCenarios_DLG.Create(nil);
           d.IndSB := ii;
           d.SBs   := Dados;
           //d.Dados := Dados[ii];
           r := d.ShowModal;
           if (r = mrOk) then
              begin
              //Dados[ii] := d.Dados;
              if (d.IndCenario > -1) then Processar(ii, d.IndCenario);
              end;
           d.Free;
           end;
        end;
     end;
end;

end.
