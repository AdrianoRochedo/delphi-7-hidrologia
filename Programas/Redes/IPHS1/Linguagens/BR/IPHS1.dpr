library IPHS1;

uses
  ShareMem;

{$E br}

const
  Count = 80;
  Messages : Array[1..Count] of String =
{01}    ('IPHS1 para Windows',
{02}     'Desenvolvedores',
{03}     'IPHS1 Vers�o DOS',
{04}     'Desenvolvedor',
{05}     'Valor Selecionado: ',
{06}     'Delta T: ',
{07}     'Nome da Deriva��o criada: ',
{08}     'J� existe uma Deriva��o neste PC',
{09}     'Nome da Sub-Bacia criada: ',
{10}     'J� existe uma Sub-Bacia conectada a este Trecho-D�gua',
{11}     'Uma Sub-Bacia independente s� pode ser'#13 +
         'conectada a um Trecho-D�gua. Como n�o existem'#13 +
         'Trechos-D�gua neste projeto foi imposs�vel criar o Objeto.',
{12}     'Objeto: %s'#13'Armazenamento Inicial inv�lido: %f',
{13}     'Objeto: %s'#13'Precipita��o M�xima Inv�lida: %f',
{14}     'Objeto: %s'#13'�rea inv�lida: %f',
{15}     'Objeto: %s'#13'Tempo de Concentra��o inv�lido: %f',
{16}     'Tabela de Precipita��es',
{17}     'Total',
{18}     'Chuva Efetiva X Hidrograma Resultante',
{19}     'Hidrograma Resultante (m�/s)',
{20}     'Intervalos (n. Delta T)',
{21}     'Perdas X Prec.Efetiva',
{22}     'Intervalos (n. Delta T)',
{23}     'Perdas (mm)',
{24}     'Pe (mm)',
{25}     'Precipita��o',
{26}     'P = Pe + Perdas',
{27}     'Precipita��o (mm)',
{28}     'Intervalos (n. Delta T)',
{29}     'Perdas (mm)',
{30}     'Pe (mm)',
{31}     'Projeto: %s'#13 + 'N�mero de Intervalos de Tempo n�o definido',
{32}     'Projeto: %s'#13'N�mero de Intervalos de Tempo com Chuva n�o definido',
{33}     'Projeto: %s'#13 + 'Arquivo n�o encontrado:'#13'%s',
{34}     'Projeto: %s'#13 +
         'N�mero de Intervalos de Tempo com Chuva (%d) n�o pode ser maior que o'#13 +
         'N�mero de Valores (%d) encontrado no arquivo.'#13 +
         '%s',
{35}     'Projeto: %s'#13 +
         'N�mero de Intervalos de Tempo com Chuva n�o pode ser maior'#13 +
         'que o N�mero de Intervalos de Tempo.',
{36}     'Projeto: %s'#13'Tamanho do Intervalo de Tempo n�o definido',
{37}     'Transforma��o Chuva-Vaz�o',
{38}     'Hidrograma Lido',
{39}     'Simula��o conclu�da. Verifique a sa�da',
{40}     'Erro na Simula��o.'#13#10 +
         '�ltima opera��o realizada: ',
{41}     'Projeto: %s'#13'Rede n�o definida!',
{42}     'Projeto sem nome !',
{43}     'Editar Tabela H = F(S)',
{44}     'Editar Tabela Q = F(S)',
{45}     'Coeficientes de Thiessen n�o somam 1',
{46}     'PROJETO ',
{47}     'Confirma a remo��o ?',
{48}     'Clique em um Ponto de Controle para criar uma Deriva��o',
{49}     'Diagn�stico: OK',
{50}     'Tem Certeza que deseja remover este Trecho ?',
{51}     'Executando: ',
{52}     'Indefinido',
{53}     'Dados dos Postos',
{54}     'Arquivos Script Pascal (*.pscript)|*.pscript' +
         'Arquivos Pascal (*.pas)|*.pas' + '|' +
         'Todos (*.*)|*.*',
{55}     'Clique consecutivamente em dois Pontos de Controle para criar um Trecho D`�gua.',
{56}     'Clique em um Ponto de Controle para criar uma Sub-Bacia.',
{57}     'Clique em uma janela de projeto para criar um Ponto de Controle.',
{58}     'Clique em outro Ponto de Controle para fechar a conex�o.',
{59}     'Selecione dois Pontos de Controle pertencentes a um Trecho D`�gua.'#13'Mas Aten��o: Primeiro o ponto Montante e depois o Jusante.',
{60}     'Agora selecione o Ponto de Controle Jusante a este Trecho D`�gua.',
{61}     'Clique em um Ponto de Controle ou em uma Sub-Bacia para criar uma Demanda.'#13'Aten��o: Se houver uma Classe de Demanda selecionada a demanda criada herdar� seus dados',
{62}     'Clique em uma janela de projeto para criar um Reservat�rio.',
{63}     'Trecho D`�gua criado entre os PCs "%s" e "%s"',
{64}     'Primeiro Ponto de Controle: %s',
{65}     'Segundo Ponto: ?? (indefinido)',
{66}     'Ponto Montante: %s',
{67}     'Ponto Jusante: ?? (indefinido)',
{68}     'Ponto de Controle inserido entre os PCs "%s" e "%s"',
{69}     'O PC selecionado "%s" n�o � Jusante ao PC "%s"',
{70}     'O PC selecionado "%s" n�o � um PC Montante.',
{71}     'O nome "%s" j� pertence a outro objeto !'#13'Por favor, escolha um nome que n�o exista.',
{72}     'Objeto: %s'#13'C�digo de Retorno de Contribui��o Inv�lido',
{73}     'Este PC j� possui um outro PC a jusante!',
{74}     'O PC "%s" � um dos PCs a Montante do PC "%s"',
{75}     'Os dados da Demanda "%s" foram'#13'sincronizados com os dados da Classe "%s"',
{76}     'Somente posso remover uma classe se n�o houverem descendentes !',
{77}     'Inserir uma demanda com base na Classe de Demanda: "%s"',
{78}     ' %s. Intervalo: (%d a %d)',
{79}     'Objeto: %s'#13'A opera��o Transforma��o Chuva-Vaz�o n�o pode ser realizada sem a'#13'defini��o pr�via da Precipita��o (intervalo de tempo com chuva, arquivos, etc)',
{80}     'Projeto: %s'#13'N�mero de Valores (%d) encontrado no arquivo:'#13'%s'#13'n�o pode ser diferente do N�mero de Intervalos de Tempo (%d)');


function GetMessage(Index: Word): String;
begin
  if (Index > Count) or (Index = 0) then
     Result := 'Invalide Index Message !!!'
  else
     Result := Messages[Index];
end;

exports
  GetMessage;

begin
end.
