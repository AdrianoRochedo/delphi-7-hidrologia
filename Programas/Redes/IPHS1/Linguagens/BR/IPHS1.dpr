library IPHS1;

uses
  ShareMem;

{$E br}

const
  Count = 80;
  Messages : Array[1..Count] of String =
{01}    ('IPHS1 para Windows',
{02}     'Desenvolvedores',
{03}     'IPHS1 Versão DOS',
{04}     'Desenvolvedor',
{05}     'Valor Selecionado: ',
{06}     'Delta T: ',
{07}     'Nome da Derivação criada: ',
{08}     'Já existe uma Derivação neste PC',
{09}     'Nome da Sub-Bacia criada: ',
{10}     'Já existe uma Sub-Bacia conectada a este Trecho-Dágua',
{11}     'Uma Sub-Bacia independente só pode ser'#13 +
         'conectada a um Trecho-Dágua. Como não existem'#13 +
         'Trechos-Dágua neste projeto foi impossível criar o Objeto.',
{12}     'Objeto: %s'#13'Armazenamento Inicial inválido: %f',
{13}     'Objeto: %s'#13'Precipitação Máxima Inválida: %f',
{14}     'Objeto: %s'#13'Área inválida: %f',
{15}     'Objeto: %s'#13'Tempo de Concentração inválido: %f',
{16}     'Tabela de Precipitações',
{17}     'Total',
{18}     'Chuva Efetiva X Hidrograma Resultante',
{19}     'Hidrograma Resultante (m³/s)',
{20}     'Intervalos (n. Delta T)',
{21}     'Perdas X Prec.Efetiva',
{22}     'Intervalos (n. Delta T)',
{23}     'Perdas (mm)',
{24}     'Pe (mm)',
{25}     'Precipitação',
{26}     'P = Pe + Perdas',
{27}     'Precipitação (mm)',
{28}     'Intervalos (n. Delta T)',
{29}     'Perdas (mm)',
{30}     'Pe (mm)',
{31}     'Projeto: %s'#13 + 'Número de Intervalos de Tempo não definido',
{32}     'Projeto: %s'#13'Número de Intervalos de Tempo com Chuva não definido',
{33}     'Projeto: %s'#13 + 'Arquivo não encontrado:'#13'%s',
{34}     'Projeto: %s'#13 +
         'Número de Intervalos de Tempo com Chuva (%d) não pode ser maior que o'#13 +
         'Número de Valores (%d) encontrado no arquivo.'#13 +
         '%s',
{35}     'Projeto: %s'#13 +
         'Número de Intervalos de Tempo com Chuva não pode ser maior'#13 +
         'que o Número de Intervalos de Tempo.',
{36}     'Projeto: %s'#13'Tamanho do Intervalo de Tempo não definido',
{37}     'Transformação Chuva-Vazão',
{38}     'Hidrograma Lido',
{39}     'Simulação concluída. Verifique a saída',
{40}     'Erro na Simulação.'#13#10 +
         'Última operação realizada: ',
{41}     'Projeto: %s'#13'Rede não definida!',
{42}     'Projeto sem nome !',
{43}     'Editar Tabela H = F(S)',
{44}     'Editar Tabela Q = F(S)',
{45}     'Coeficientes de Thiessen não somam 1',
{46}     'PROJETO ',
{47}     'Confirma a remoção ?',
{48}     'Clique em um Ponto de Controle para criar uma Derivação',
{49}     'Diagnóstico: OK',
{50}     'Tem Certeza que deseja remover este Trecho ?',
{51}     'Executando: ',
{52}     'Indefinido',
{53}     'Dados dos Postos',
{54}     'Arquivos Script Pascal (*.pscript)|*.pscript' +
         'Arquivos Pascal (*.pas)|*.pas' + '|' +
         'Todos (*.*)|*.*',
{55}     'Clique consecutivamente em dois Pontos de Controle para criar um Trecho D`água.',
{56}     'Clique em um Ponto de Controle para criar uma Sub-Bacia.',
{57}     'Clique em uma janela de projeto para criar um Ponto de Controle.',
{58}     'Clique em outro Ponto de Controle para fechar a conexão.',
{59}     'Selecione dois Pontos de Controle pertencentes a um Trecho D`água.'#13'Mas Atenção: Primeiro o ponto Montante e depois o Jusante.',
{60}     'Agora selecione o Ponto de Controle Jusante a este Trecho D`água.',
{61}     'Clique em um Ponto de Controle ou em uma Sub-Bacia para criar uma Demanda.'#13'Atenção: Se houver uma Classe de Demanda selecionada a demanda criada herdará seus dados',
{62}     'Clique em uma janela de projeto para criar um Reservatório.',
{63}     'Trecho D`água criado entre os PCs "%s" e "%s"',
{64}     'Primeiro Ponto de Controle: %s',
{65}     'Segundo Ponto: ?? (indefinido)',
{66}     'Ponto Montante: %s',
{67}     'Ponto Jusante: ?? (indefinido)',
{68}     'Ponto de Controle inserido entre os PCs "%s" e "%s"',
{69}     'O PC selecionado "%s" não é Jusante ao PC "%s"',
{70}     'O PC selecionado "%s" não é um PC Montante.',
{71}     'O nome "%s" já pertence a outro objeto !'#13'Por favor, escolha um nome que não exista.',
{72}     'Objeto: %s'#13'Código de Retorno de Contribuição Inválido',
{73}     'Este PC já possui um outro PC a jusante!',
{74}     'O PC "%s" é um dos PCs a Montante do PC "%s"',
{75}     'Os dados da Demanda "%s" foram'#13'sincronizados com os dados da Classe "%s"',
{76}     'Somente posso remover uma classe se não houverem descendentes !',
{77}     'Inserir uma demanda com base na Classe de Demanda: "%s"',
{78}     ' %s. Intervalo: (%d a %d)',
{79}     'Objeto: %s'#13'A operação Transformação Chuva-Vazão não pode ser realizada sem a'#13'definição prévia da Precipitação (intervalo de tempo com chuva, arquivos, etc)',
{80}     'Projeto: %s'#13'Número de Valores (%d) encontrado no arquivo:'#13'%s'#13'não pode ser diferente do Número de Intervalos de Tempo (%d)');


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
