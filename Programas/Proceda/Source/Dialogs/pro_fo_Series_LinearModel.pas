unit pro_fo_Series_LinearModel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, wsMatrix, StdCtrls, Buttons;

type
  TfoSeries_LinearModel = class(TForm)
    Label7: TLabel;
    Label8: TLabel;
    lbVars: TListBox;
    edM: TEdit;
    btnCalcular: TButton;
    btnFechar: TButton;
    procedure btnFechar_Click(Sender: TObject);
    procedure btnCalcular_Click(Sender: TObject);
    procedure lbVarsDblClick(Sender: TObject);
  private
    FDS: TwsDataset;
  public
    constructor Create(ds: TwsDataset);
  end;

implementation
uses SysUtilsEx,
     wsBXML_Output,
     wsConstTypes,
     wsMasterModel,
     pro_Application;

{$R *.dfm}

{ TfoSeries_LinearModel }

constructor TfoSeries_LinearModel.Create(ds: TwsDataset);
var i: Integer;
begin
  inherited Create(nil);
  FDS := ds;
  for i := 1 to FDS.nCols do
    lbVars.Items.Add(FDS.Struct.Col[i].Name + ':  ' + FDS.Struct.Col[i].Lab);
end;

procedure TfoSeries_LinearModel.btnFechar_Click(Sender: TObject);
begin
  Close();
end;

procedure TfoSeries_LinearModel.lbVarsDblClick(Sender: TObject);
var p: integer;
    s: string;
begin
  s := lbVars.Items[lbVars.ItemIndex];
  p := System.pos(':', s);
  edM.Text := edM.Text + System.Copy(s, 1, p-1);
end;

procedure TfoSeries_LinearModel.btnCalcular_Click(Sender: TObject);
var s: string;
    m: TwsLMManager;
    i: integer;
begin
  s := SysUtilsEx.ChangeChar(edM.Text, '=', '~');

  m := TwsLMManager.Create(FDS, s, '', '', '');
  m.Output := TwsBXML_Output.Create();

  // Descricao do processo
  m.Output.BeginText();
  m.Output.WriteTitle(2, self.Caption);
  m.Output.NewLine();
  for i := 1 to FDS.nCols do
    m.Output.WritePropValue(FDS.Struct.Col[i].Name + ':', FDS.Struct.Col[i].Lab);
  m.Output.EndText();

  // Opcoes gerais
  m.Options[ ord(cmIntercept) ] := true;
  m.Options[ ord(cmUnivar)    ] := true;
  m.Options[ ord(cmPrintCoef) ] := true;
  m.Options[ ord(cmSaveCoef)  ] := true;

  // m.ObjectCreation_Event := ???

  // Avaliacao do modelo e calculo dos coeficientes
  try
    m.EvalModel();
    if m.Error = 0 then
       begin
       m.ExecReg(0{complete});
       Applic.ShowReport(m.Output.SaveToTempFile(), self.Caption);
       end;
  finally
    m.Output.Free();
    m.Free();
  end;
end;

end.
