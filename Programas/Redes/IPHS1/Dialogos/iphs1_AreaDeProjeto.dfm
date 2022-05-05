inherited iphs1_Form_AreaDeProjeto: Tiphs1_Form_AreaDeProjeto
  Left = 262
  Top = 149
  Width = 433
  Caption = 'iphs1_Form_AreaDeProjeto'
  KeyPreview = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Progresso: TProgressBar
    Width = 425
  end
  inherited SaveDialog: TSaveDialog
    Left = 19
    Top = 9
  end
  object Menu_PC: TPopupMenu
    OnPopup = Menu_PC_Popup
    Left = 23
    Top = 71
    object Menu_PC_ClonarObjeto: TMenuItem
      Caption = '&Clonar Objeto'
      OnClick = Menu_PC_ClonarObjetoClick
    end
    object Menu_PC_CopiarDados: TMenuItem
      Caption = 'Copiar &Dados Deste Objeto ...'
      OnClick = Menu_PC_CopiarDadosClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Menu_PC_HidroRes: TMenuItem
      Caption = 'Plotar &Hidrograma Resultante'
      OnClick = Menu_HidroRes_Click
    end
    object Menu_PC_MostrarHR_DosObjConectados: TMenuItem
      Caption = 'Plotar Hidrograma Resultante Dos Objetos Conectados'
      OnClick = Menu_PC_MostrarHR_DosObjConectadosClick
    end
    object Menu_PC_PlotarVC: TMenuItem
      Caption = 'Plotar Vaz'#227'o Controlada'
      OnClick = Menu_PlotarVC_Click
    end
  end
  object Menu_SB: TPopupMenu
    OnPopup = Menu_SBPopup
    Left = 152
    Top = 69
    object Menu_SB_CopiarDados: TMenuItem
      Caption = 'Copiar &Dados Deste Objeto ...'
      OnClick = Menu_SB_CopiarDadosClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object PlotarVazoControlada2: TMenuItem
      Caption = 'Plotar Vaz'#227'o Controlada'
      OnClick = Menu_PlotarVC_Click
    end
    object Menu_SB_HidroRes: TMenuItem
      Caption = 'Plotar &Hidrograma Resultante X Tab. de Precipita'#231#227'o'
      OnClick = Menu_HidroRes_Click
    end
    object MenuSB_PlotarTabPrecip: TMenuItem
      Caption = 'Plotar Tabela de Precipita'#231#245'es'
      OnClick = MenuSB_PlotarTabPrecipClick
    end
  end
  object Menu_PCR: TPopupMenu
    OnPopup = Menu_PCRPopup
    Left = 86
    Top = 71
    object Menu_PCR_ClonarObjeto: TMenuItem
      Caption = '&Clonar Objeto'
      OnClick = Menu_PCR_ClonarObjetoClick
    end
    object Menu_PCR_CopiarDados: TMenuItem
      Caption = 'Copiar &Dados Deste Objeto ...'
      OnClick = Menu_PCR_CopiarDadosClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Menu_PCR_VerCotas: TMenuItem
      Caption = 'Visualizar Cotas e Vaz'#245'es ...'
      OnClick = Menu_PCR_VerCotasClick
    end
    object Menu_PCR_VNA: TMenuItem
      Caption = 'Visualizar N'#237'vel-D'#225'gua ...'
      OnClick = Menu_PCR_VNAClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Menu_PCR_HidroRes: TMenuItem
      Caption = 'Plotar &Hidrograma Resultante'
      OnClick = Menu_HidroRes_Click
    end
    object Menu_PCR_MostrarHidrogramaResultanteDosObjetosConectados: TMenuItem
      Caption = 'Plotar Hidrograma Resultante Dos Objetos Conectados'
      OnClick = Menu_PC_MostrarHR_DosObjConectadosClick
    end
    object PlotarVazoControlada1: TMenuItem
      Caption = 'Plotar Vaz'#227'o Controlada'
      OnClick = Menu_PlotarVC_Click
    end
    object Menu_PCR_PlotarCotas: TMenuItem
      Caption = 'Plotar Cotas e Vaz'#245'es ...'
      OnClick = Menu_PCR_PlotarCotasClick
    end
  end
  object Menu_Der: TPopupMenu
    OnPopup = Menu_DerPopup
    Left = 220
    Top = 71
    object Menu_DER_CopiarDados: TMenuItem
      Caption = 'Copiar &Dados Deste Objeto ...'
      OnClick = Menu_DER_CopiarDadosClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object Menu_Der_HidroRes: TMenuItem
      Caption = 'Plotar &Hidrograma Resultante'
      OnClick = Menu_HidroRes_Click
    end
  end
  object Menu_TD: TPopupMenu
    OnPopup = Menu_TDPopup
    Left = 288
    Top = 73
    object Menu_TD_CopiarDados: TMenuItem
      Caption = 'Copiar &Dados Deste Objeto ...'
      OnClick = Menu_TD_CopiarDadosClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Menu_TD_VisCotas: TMenuItem
      Caption = 'Visualizar Cotas ...'
      Enabled = False
      OnClick = Menu_TD_VisCotasClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Menu_TD_HidroRes: TMenuItem
      Caption = 'Plotar &Hidrograma Resultante'
      OnClick = Menu_HidroRes_Click
    end
    object PlotarVazoControlada3: TMenuItem
      Caption = 'Plotar Vaz'#227'o Controlada'
      OnClick = Menu_PlotarVC_Click
    end
    object Menu_TD_PlotarCotas: TMenuItem
      Caption = 'Plotar Cotas'
      OnClick = Menu_TD_PlotarCotasClick
    end
    object PlotarQRua1: TMenuItem
      Caption = 'Plotar Q. Rua'
      OnClick = PlotarQRua1Click
    end
  end
end
