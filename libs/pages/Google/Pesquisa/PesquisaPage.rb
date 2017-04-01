# encoding: utf-8
require 'magic_encoding'
require 'utils/Utils'
require 'pages/Google/Pesquisa/PesquisaPageLocators'

class PesquisaPage < PesquisaPageLocators
    def initialize
        @driver = $browser
        @tela = 'Google'
    end

    def verifica_titulo
      raise 'O site do Google não foi localizado.' unless @driver.title.include? 'Google'
    end

    def preenche_campo_busca(valor)
      preencher_textfield(txtfield_busca, valor, 'Campo busca')
      enviar_tecla :enter
    end

    def verifica_sem_resultados
      raise 'Não foram encontrados resultados na busca.' if txtlabel_sem_resultado.exists?
    end
end
