require 'magic_encoding'
require 'pages/Google/Pesquisa/PesquisaPage'

pesquisa_page = PesquisaPage.new

########################################################################################################################
# DADO
########################################################################################################################

Dado(/^que eu esteja com o site do google aberto$/) do
  pesquisa_page.verifica_titulo
  obter_evidencia
end

########################################################################################################################
# QUANDO
########################################################################################################################

Quando(/^eu preencher o campo de buscar com o valor "([^"]*)"$/) do |valor|
  pesquisa_page.preenche_campo_busca(valor)
  obter_evidencia
end

########################################################################################################################
# ENTAO
########################################################################################################################

Então(/^a pesquisa retornará ao menos um resultado$/) do
  pesquisa_page.verifica_sem_resultados
  obter_evidencia
end