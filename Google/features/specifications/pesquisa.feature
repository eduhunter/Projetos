#language: pt
#Encoding: UTF-8

Funcionalidade: Google

@pesquisa_google
Cenário: Pesquisar valor no google
    Dado que eu esteja com o site do google aberto
    Quando eu preencher o campo de buscar com o valor "Eduardo"
    Então a pesquisa retornará ao menos um resultado