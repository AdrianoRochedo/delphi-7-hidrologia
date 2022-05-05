unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SysUtilsEx, ComCtrls;

type
  TfoMain = class(TForm, IProgressBar, ITextWriter)
    Button1: TButton;
    Memo: TRichEdit;
    procedure Button1Click(Sender: TObject);
  private
    // IProgressBar interface
    procedure setMin(value: integer);
    procedure setMax(value: integer);
    procedure setValue(value: integer);
    procedure setMessage(const s: string);

    // IWriter interface
    procedure Write(const s: string); overload;
    procedure Write(const s, FontName: string; const Color, Size: integer); overload;
    procedure Write(const s: string; const FontAttributes: TFontAttributesRec); overload;
  public
    { Public declarations }
  end;

var
  foMain: TfoMain;

implementation
uses LP_Solver_Res_Reader;

{$R *.dfm}

procedure TfoMain.Button1Click(Sender: TObject);
var Reader: TLP_Solver_Res_Reader;
begin
  Reader := TLP_Solver_Res_Reader.Create(self);
  try
    Reader.LoadFromFile('F:\Projetos\Arquivos de Trabalho\Propagar 3.0\Sao Chico\Otimizacoes\teste.res', self);
  finally
    Reader.Free();
  end;
end;

procedure TfoMain.setMax(value: integer);
begin

end;

procedure TfoMain.setMessage(const s: string);
begin

end;

procedure TfoMain.setMin(value: integer);
begin

end;

procedure TfoMain.setValue(value: integer);
begin

end;

procedure TfoMain.Write(const s: string);
begin
  Memo.Lines.Add(s);
end;

procedure TfoMain.Write(const s, FontName: string; const Color, Size: integer);
begin
  Memo.SelAttributes.Color := Color;
  Memo.SelAttributes.Size := Size;
  if FontName = '' then
     Memo.SelAttributes.Name := 'Courier New'
  else
     Memo.SelAttributes.Name := FontName;

  Memo.Lines.Add(s);
end;

procedure TfoMain.Write(const s: string; const FontAttributes: TFontAttributesRec);
begin
  with FontAttributes do
    Write(s, FontName, Color, Size);
end;

end.
