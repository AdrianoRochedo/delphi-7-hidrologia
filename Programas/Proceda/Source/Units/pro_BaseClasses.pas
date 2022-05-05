unit pro_BaseClasses;

interface
uses Types, Classes, Controls, ActnList, ComCtrls, SysUtils, SysUtilsEx, IniFiles, Graphics;

type

  // Representa a classe base para todos os nós da arvore
  TNoObjeto = class(T_NRC_InterfacedObject)
  private
    FPai: TNoObjeto;
  public
    No: TTreeNode;

    // Informa quando um no eh criado, se ele contiver um objeto "TNoObjeto"
    // associado, este eh passado como parametro.
    procedure EstabelecerNo(umNo: TTreeNode);

    // Mostra um aviso de "Capacidade não suportada"
    procedure NotSuported(const Capacity: string);

    // Executa a acao padrao
    procedure ExecutarAcaoPadrao(); virtual;

    // Quando o texto de um nó eh mudado, este eh passado como parametro
    procedure TextoDoNoMudou(var Texto: string); virtual;

    // Obtem o texto a ser mostrado no nó
    function ObterTextoDoNo(): string; virtual;

    // Obtem um resumo descritivo do objeto
    function ObterResumo(): String; virtual;

    // Obtem uma descricao completa do objeto
    function ObterDescricao(): String; virtual;

    // Informa se um nó pode ser editado, isto é, se seu texto pode ser mudado.
    // Se poder, e o nó for alterado, havera uma chamada de "TextoDoNoMudou()"
    function NoPodeSerEditado(): boolean; virtual;

    // Retorna o indice a ser utilizado pelo nó
    function ObterIndiceDaImagem(): integer; virtual;
    function ObterIndiceDaImagemSelecionada(): integer; virtual;

    // Mostra o objeto em uma arvore
    procedure ShowInTree(Tree: TTreeView; root: TTreeNode); virtual;

    // Ações externas que poderão ser envocadas pela interface gráfica. Ex: "Graficar".
    // Uma instância da classe TActionList deverá ser passado através do parâmetro "Acoes"
    procedure ObterAcoesIndividuais(Acoes: TActionList); virtual;
    procedure ObterAcoesColetivas(Acoes: TActionList); virtual;

    // Remove objetos
    procedure Remover(obj: TNoObjeto); virtual;

    // Atualiza o nó (Texto, imagem, etc)
    procedure AtualizarNo();

    // Indica o objeto que eh pai deste (pode ser nil)
    property Pai: TNoObjeto read FPai write FPai;
  end;

  TClasse_NoObjeto = class of TNoObjeto;

implementation
uses pro_Const,
     pro_Application;

{ TNoObjeto }

procedure TNoObjeto.EstabelecerNo(umNo: TTreeNode);
begin
  self.No := umNo;
end;

procedure TNoObjeto.TextoDoNoMudou(var Texto: string);
begin
  // Nada neste nivel
end;

procedure TNoObjeto.ExecutarAcaoPadrao();
begin
  // Somente classes descendentes definem ações padrões
end;

function TNoObjeto.NoPodeSerEditado(): boolean;
begin
  result := false;
end;

procedure TNoObjeto.ObterAcoesColetivas(Acoes: TActionList);
begin
  // Somente classes descendentes definem ações
end;

procedure TNoObjeto.ObterAcoesIndividuais(Acoes: TActionList);
begin
  // Somente classes descendentes definem ações
end;

function TNoObjeto.ObterDescricao(): String;
begin
  result := '';
end;

function TNoObjeto.ObterIndiceDaImagem(): integer;
begin
  result := -1;
end;

function TNoObjeto.ObterIndiceDaImagemSelecionada(): integer;
begin
  result := self.ObterIndiceDaImagem();
end;

function TNoObjeto.ObterResumo(): String;
begin
  Result := '';
end;

function TNoObjeto.ObterTextoDoNo(): string;
begin
  result := self.ClassName;
end;

procedure TNoObjeto.ShowInTree(Tree: TTreeView; root: TTreeNode);
begin
  // Nada
end;

procedure TNoObjeto.NotSuported(const Capacity: string);
begin
  Applic.Messages.ShowWarning(Format(cNotSuported, [ClassName + '.' + Capacity]));
end;

procedure TNoObjeto.Remover(obj: TNoObjeto);
begin
  // Nada
end;

procedure TNoObjeto.AtualizarNo();
begin
  if No <> nil then
     begin
     No.Text := self.ObterTextoDoNo();
     No.ImageIndex := self.ObterIndiceDaImagem();
     end;
end;

end.
