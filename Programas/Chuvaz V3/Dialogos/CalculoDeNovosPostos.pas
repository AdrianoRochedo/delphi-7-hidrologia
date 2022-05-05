unit CalculoDeNovosPostos;

// AUTOR : Adriano Rochedo Conceição
// DATA  : 18/12/1998

{ OBJETIVOS:
  Dado um arquivo com vários postos, calcular um novo posto com base em
  uma expressão aritmética.

  Ex: Arquivo 02008001.DB contém os postos:  P1, P2, P3.
      Calcular P4 = 0.4*P1 + 0.2*P2 + (0.5*P3 - 0.1*P1)
               P5 = 0.7*P4 + 0.3*P1

  ALGORÍTMO:
  - Passar o DataSet associado ao arquivo para a função ModelFrame()
  - Adicionar os dados do DataSet resultante ao arquivo
  - Adicionar o DataSet resultante ao DataSet usado para o cálculo
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, CH_Const, CH_Tipos;

type
  TDLG_CalcularNovosPostos = class(TForm)
    Label2: TLabel;
    Bevel2: TBevel;
    lbPostos: TListBox;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    L1: TLabel;
    sbInclui: TSpeedButton;
    sbSoma: TSpeedButton;
    sbSub: TSpeedButton;
    sbMul: TSpeedButton;
    sbDiv: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    lbExpressoes: TListBox;
    Label5: TLabel;
    editNomePosto: TEdit;
    EditExpressao: TEdit;
    procedure OperadoresClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbExpressoesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure editExpressaoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
    procedure editExpressaoKeyPress(Sender: TObject; var Key: Char);
    procedure editNomePostoKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    indexEditExpr: Integer;
    Finfo: TDSInfo;
    Procedure Insere(Const s: String);
    Procedure AtualizaListaDePostos;
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses wsgLib, SysUtilsEx, wsParser, wsAvaliadorDeExpressoes,
     wsFuncoesDeDataSets, wsOutPut, GaugeFO, wsMatrix, WinUtils,
     CH_Procs;

{$R *.DFM}

constructor TDLG_CalcularNovosPostos.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TDLG_CalcularNovosPostos.OperadoresClick(Sender: TObject);
var P    : TExpressionParser;
    eval : TAvaliator;
    i    : Integer;
begin
  Case TComponent(Sender).Tag of
    0: Insere('+');
    1: Insere('-');
    2: Insere('*');
    3: Insere('/');

    4: begin
       Insere(lbPostos.Items[lbPostos.ItemIndex]);
       //editExpressao.CurrentPos := indexEditExpr + 1; <<<
       end;

    5: begin // Analisa a expressão antes de adicioná-la.
       if (allTrim(editNomePosto.Text) = '') or (allTrim(editExpressao.Text) = '') Then
          exit
       else
          begin
          editNomePosto.Text := GetValidId(allTrim(editNomePosto.Text));
          if lbPostos.Items.IndexOf(editNomePosto.Text) > -1 Then
             Raise Exception.CreateFmt('O posto < %s > já existe', [editNomePosto.Text]);
          end;

       P := TExpressionParser.Create(nil);
       try
         with P.Operators do
           begin
           Add('+'); Add('-'); Add('*'); Add('/');
           end;
         P.KeyWords.Assign(lbPostos.Items);
         P.Text.Add(ChangeChar(editExpressao.Text, ',', '.'));
         P.Scan;
         for i := 0 to P.Variables.Count-1 do
           if lbPostos.Items.IndexOf(P.Variables[i]) = -1 Then
              raise Exception.Create('Erro na Expressão: ' + editExpressao.Text + #13 +
              'Posto Desconhecido: ' + P.Variables[i]);

         // Verifica a construção sintática da expressão
         eval := TAvaliator.Create;
         try
           for i := 0 to lbPostos.Items.Count-1 do
             eval.TabVar.AddFloat(lbPostos.Items[i], 0);
           try
             eval.Expression := ChangeChar(editExpressao.Text, ',', '.');
           except
             On E: Exception do
                MessageDLG('Erro na expressão: ' + editExpressao.Text + #13 + E.Message,
                mtError, [mbOK], 0);
           end;
         finally
           eval.Free;
         end;

         lbExpressoes.Items.Add(editNomePosto.Text + ' = ' + allTrim(editExpressao.Text));
         AtualizaListaDePostos;
         Clear([EditNomePosto, EditExpressao]);
         EditNomePosto.SetFocus;
       finally
         P.Free;
         end;
       end;
    end;
end;

Procedure TDLG_CalcularNovosPostos.Insere(Const s: String);
//var Col: Integer;
//    s1: String;
Begin
  with EditExpressao do
    begin
{
    Col := CurrentPos;
    if Col = -1 Then Col := indexEditExpr;
    s1 := Text;
    Insert(s, s1, Col+1);
    Text := s1;
    indexEditExpr := Col + Length(s) + 1;
    CurrentPos := indexEditExpr;
    Deselect;
}
    Text := Text + s;
    end;
End;

procedure TDLG_CalcularNovosPostos.editExpressaoKeyUp(Sender: TObject; var Key: Word;
          Shift: TShiftState);
begin
  //indexEditExpr := editExpressao.CurrentPos + 1; <<<
end;

Procedure TDLG_CalcularNovosPostos.AtualizaListaDePostos;
var i: Integer;
    s1, s2: String;
Begin
  FInfo.MostrarPostos(lbPostos.Items);
  For i := 0 to lbExpressoes.Items.Count-1 Do
    begin
    SubStrings('=', s1, s2, lbExpressoes.Items[i]);
    lbPostos.Items.Add(allTrim(s1));
    end;
End;

procedure TDLG_CalcularNovosPostos.FormShow(Sender: TObject);
begin
  indexEditExpr := -1;
  AtualizaListaDePostos;
end;

procedure TDLG_CalcularNovosPostos.lbExpressoesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DeleteElemFromList(lbExpressoes, Key);
  AtualizaListaDePostos;
end;

procedure TDLG_CalcularNovosPostos.btnOkClick(Sender: TObject);
var i,j,k      : Integer;
    nCols      : Integer;
    Expressoes : TStrings;
    Nomes      : TStrings;
    DS         : TwsDataSet;
    L          : TwsDataSets;
    s, s1      : String;
    Pr         : TDLG_Progress;
begin
  Nomes      := TStringList.Create;
  Expressoes := TStringList.Create;

  Screen.Cursor := crHourGlass;
  Try
    for i := 0 to lbExpressoes.Items.Count - 1 do
      begin
      SubStrings('=', s, s1, lbExpressoes.Items[i]);
      Nomes.ADD(allTrim(s));
      Expressoes.ADD(ChangeChar(allTrim(s1), ',', '.'));
      end;

    Caption := 'Calculando os dados dos postos ...';
    L := ModelFrame(Expressoes, nil, '', Finfo.DS, Nomes, True);
    Try
      if L <> nil Then
         begin
         DS := TwsDataSet(L[0]);
         nCols := Finfo.DS.nCols;
         For i := 1 to DS.nCols Do
           begin
           s := DS.Struct.Col[i].Name;

           // Criacao da coluna
           Finfo.DS.Struct.AddNumeric(s, 'Posto ' + s);
           k := Finfo.DS.nCols;
           Finfo.DS.Struct.Col[k].aObject :=
             TPosto.Create(Finfo.DS.Struct.Col[k].Name, Finfo);
           Caption := 'Atualizando arquivo ...';

           // calculo das variáveis
           Pr := CreateProgress(-2, -2, DS.nRows, 'Inserindo posto ' + s + ' ...');
           try
             if s[1] = '_' then
                Delete(s, 1, 1); //remove o primeiro caracter, isto é, o '_'

             for j := 1 to DS.nRows do
               begin
               pr.Value := j;
               Finfo.DS.Row[j].Add(DS.Data[j, i]);
               end;

           finally
             Pr.Free();
             end;
           end;
         end;
      ModalResult := mrOk;
    Finally
      L.Free;
    End;
  Finally
    Screen.Cursor := crDefault;
    Expressoes.Free;
    Nomes.Free;
  End;
end;

procedure TDLG_CalcularNovosPostos.editExpressaoKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = ',') or (key = '.') then
     key := DecimalSeparator;
end;

procedure TDLG_CalcularNovosPostos.editNomePostoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = ' ' then key := #0; //não deixa digitar espaço
end;

procedure TDLG_CalcularNovosPostos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDLG_CalcularNovosPostos.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
