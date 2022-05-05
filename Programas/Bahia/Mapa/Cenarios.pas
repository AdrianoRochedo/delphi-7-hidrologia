unit Cenarios;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, gridx32, ba_Classes;

type
  TCenarios_DLG = class(TForm)
    Panel1: TPanel;
    btnOk: TButton;
    btnCancelar: TButton;
    Panel2: TPanel;
    sgDados: TdrStringAlignGrid;
    btnAdicionar: TButton;
    btnEditar: TButton;
    btnRemover: TButton;
    btnAtualizar: TButton;
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure sgDadosClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FCopiaCenarios : TListaDeCenarios;
    Dados          : TRecSubBacia;

    Function l_existe_parametro_na_grid: Boolean;
    procedure ExecutarAcoes;
    procedure PedeSenha;
  public
    IndCenario : Integer;
    Modificado : Boolean;
    SBs        : TListaDeSubBacias;
    IndSB      : Integer;
  end;

implementation
uses Dados_Cenarios, Dialogs, SysUtil2, IniFiles;

{$R *.DFM}

Function TCenarios_DLG.l_existe_parametro_na_grid: Boolean;
begin
  Result := (sgDados.RowCount > 2) or
            (sgDados.Cells[0,1] <> '');
end; {l_existe_parametro_na_grid}

procedure TCenarios_DLG.btnAdicionarClick(Sender: TObject);
var D: TDadosSenario_DLG;
    c: TRecCenario;
begin
  PedeSenha;
  D := TDadosSenario_DLG.Create(Self);
  Try
    If D.ShowModal = mrOk Then
       begin
       If l_existe_parametro_na_grid Then
          sgDados.RowCount := sgDados.RowCount + 1;

       btnRemover.Enabled := True;
       btnEditar .Enabled := True;

       c.Arquivo    := D.edArquivo.Text;
       c.Nome       := D.edNome.Text;
       c.Comentario := D.edComentario.Text;

       FCopiaCenarios.Adicionar(c);
       FCopiaCenarios.Mostrar(sgDados);
       Modificado := True;
       end;
  Finally
    D.Free;
  End;

  btnOk.Enabled := l_existe_parametro_na_grid;
end; {AdicionarClick}

procedure TCenarios_DLG.btnEditarClick(Sender: TObject);
var D: TDadosSenario_DLG;
    L: Integer;
    c: TRecCenario;
begin
  L := sgDados.Row;
  If (L > 0) and (sgDados.Cells[0, L] <> '') Then
     begin
     D := TDadosSenario_DLG.Create(Self);
     Try
       D.edNome.Text        := FCopiaCenarios[L-1].Nome;
       D.edComentario.Text  := FCopiaCenarios[L-1].Comentario;
       D.edArquivo.Text     := FCopiaCenarios[L-1].Arquivo;
       If D.ShowModal = mrOk Then
          begin
          c.Nome       := D.edNome.Text;
          c.Comentario := D.edComentario.Text;
          c.Arquivo    := D.edArquivo.Text;

          FCopiaCenarios[L-1] := c;
          FCopiaCenarios.Mostrar(sgDados);
          end;
     Finally
        D.Free;
     End;
     btnOk.Enabled := l_existe_parametro_na_grid ;
     end
  else
     MessageDlg('Selecione os dados que deseja editar.', mtInformation, [mbOk], 0);
end;{sbEditarClick}

procedure TCenarios_DLG.btnRemoverClick(Sender: TObject);
begin
  PedeSenha;
  if MessageDLG('Tem certeza ?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
     If sgDados.RowCount > 2 Then
        begin
        FCopiaCenarios.Remover(sgDados.Row-1);
        sgDados.RemoveRows(sgDados.Row, 1);
        Modificado := True;
        end;
{
     Else
        Begin
        sgDados.Clear(False);
        FCopiaCenarios.Remover(0);
        btnRemover.Enabled := False;
        btnEditar .Enabled := False;
        End;
}
     btnOk.Enabled := l_existe_parametro_na_grid ;
     sgDadosClick(nil);
     end;
end;{sbRemoverClick}

procedure TCenarios_DLG.FormCreate(Sender: TObject);
begin
  sgDados.RowCount := 2;
  sgDados.Cells[0,0] := ' Nome';
  sgDados.Cells[1,0] := ' Comentário';

  FCopiaCenarios := TListaDeCenarios.Create;
  IndCenario := -1;
end;

procedure TCenarios_DLG.FormDestroy(Sender: TObject);
begin
  FCopiaCenarios.Free;
end;

procedure TCenarios_DLG.FormShow(Sender: TObject);
var i: Integer;
begin
  Caption := ' Cenários da Sub-Bacia ' + Dados.Nome;
  Dados := SBs[IndSB];
  FCopiaCenarios.Associar(Dados.Cenarios);
  with FCopiaCenarios do
    begin
    sgDados.RowCount := NumCenarios + 1;
    for i := 0 to NumCenarios-1 do
      begin
      sgDados.Cells[0, i+1] := Cenario[i].Nome;
      sgDados.Cells[1, i+1] := Cenario[i].Comentario;
      end;
    end;
  sgDadosClick(nil);  
end;

procedure TCenarios_DLG.btnAtualizarClick(Sender: TObject);
begin
  ExecutarAcoes;
  Dados.Cenarios.Associar(FCopiaCenarios);
  SBs[IndSB] := Dados;
  Modificado := False;
end;

procedure TCenarios_DLG.btnOkClick(Sender: TObject);
begin
  if Modificado then
     if MessageDLG('Salva os Cenários ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        ExecutarAcoes;
        IndCenario := sgDados.Row-1;
        Dados.Cenarios.Associar(FCopiaCenarios);
        SBs[IndSB] := Dados;
        ModalResult := mrOk;
        end
     else
        ModalResult := mrCancel
  else
     begin
     IndCenario := sgDados.Row-1;
     ModalResult := mrOk;
     end;
end;

procedure TCenarios_DLG.ExecutarAcoes;
var i, j  : Integer;
    Achou : Boolean;
    Ini   : TMemIniFile;
    s, s2 : String;
begin
  // Verifica quais cenários foram removidos
  // Se um cenário foi removido seu arquivo também é
  for i := 0 to Dados.Cenarios.NumCenarios - 1 do
    begin
    s := Dados.Cenarios[i].Nome;
    Achou := False;
    for j := 0 to FCopiaCenarios.NumCenarios - 1 do
      if s = FCopiaCenarios[j].Nome then begin Achou := True; Break; end;
    if not Achou then DeleteFile(Dados.Cenarios[i].Arquivo);
    end;

  // Verifica quais cenários foram adicionados
  for i := 0 to FCopiaCenarios.NumCenarios - 1 do
    begin
    s := FCopiaCenarios[i].Nome;
    Achou := False;
    for j := 0 to Dados.Cenarios.NumCenarios - 1 do
      if s = Dados.Cenarios[j].Nome then begin Achou := True; Break; end;

    if not Achou then
       begin
       Ini := TMemIniFile.Create(FCopiaCenarios[i].Arquivo);
       s2 := Ini.ReadString('Projeto', 'Nome', '');
       if s2 <> '' then
          begin
          s := ExtractFileName(Ini.ReadString('Projeto', 'Fundo', ''));
          Ini.WriteString('Projeto', 'Fundo', s);
          Ini.WriteString('Dados ' + s2, 'Dir. Saida', '');
          Ini.WriteString('Dados ' + s2, 'Dir. Pesquisa', '');

          Ini.Rename(Dados.Cenarios[0].Arquivo, False);
          if FileExists(Ini.FileName) then
             Ini.Rename(GetTempFile(ExtractFilePath(Ini.FileName), 'cen', '.prg'), False);

          s := Ini.FileName;
          Ini.UpdateFile;
          Ini.Free;

          EncryptFile(1803, s);
          FCopiaCenarios.Arquivo[i] := s;
          end;
       end;
    end;
end;

procedure TCenarios_DLG.PedeSenha;
var i: Integer;
begin
  try
    i := StrToInt(Inputbox('Senha', 'Entre com a senha:', '0'));
  except
    i := 0;
  end;

  if i <> 12345 then
     Raise Exception.Create('Senha Incorreta !');
end;

procedure TCenarios_DLG.sgDadosClick(Sender: TObject);
begin
  btnRemover.Enabled := (sgDados.Row > 1);
end;

procedure TCenarios_DLG.btnCancelarClick(Sender: TObject);
begin
  if Modificado then
     if MessageDLG('Salva os Cenários ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
        btnAtualizarClick(Sender);
        ModalResult := mrYes;
        end
     else
        ModalResult := mrCancel
  else
     ModalResult := mrCancel;
end;

end.
