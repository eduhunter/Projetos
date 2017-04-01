
require 'magic_encoding'

########################################################################################################################
# HTTP
########################################################################################################################
def web_not_http403(msg)
    raise "HTTP 403 - #{msg}" if @driver.div(id: 'http403Align').exist?
end

########################################################################################################################
# Elements
########################################################################################################################

def aguardar_objeto_presente(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento #{elemento} não carregado. Esperado: Elemento carregado" unless locator_elemento.wait_until_present(120)
    sleep 2
end

def obter_evidencia
    $encoded_img = $browser.driver.screenshot_as(:base64)
end

def enviar_tecla(tecla)
    $browser.send_keys tecla
end

def elemento_existe?(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento '#{elemento}' não encontrado. Esperado: Elemento encontrado" unless locator_elemento.exist?
end

def elemento_nao_existe?(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento '#{elemento}' encontrado. Esperado: Elemento não encontrado" if locator_elemento.exist?
end

def elemento_visivel?(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento '#{elemento}' não visível. Esperado: Elemento visível" unless locator_elemento.present?
end

def elemento_nao_visivel?(locator_elemento, elemento = '')
    sleep 2
    raise "Tela #{@tela} - Elemento #{elemento} visível. Esperado: Elemento não visível" if locator_elemento.present?
end

def elemento_habilitado?(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento '#{elemento}' desabilitado. Esperado: Elemento habilitado" if locator_elemento.disabled?
end

def elemento_desabilitado?(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento #{elemento} habilitado. Esperado: Elemento desabilitado" unless locator_elemento.disabled?
end

def elemento_readonly?(locator_elemento, elemento = '')
    raise "Tela #{@tela} - Elemento '#{elemento}' habilitado. Esperado: Elemento readonly" unless locator_elemento.readonly?
end

def preencher_textfield(locator_elemento, valor, elemento)
    elemento_existe?(locator_elemento, "TextField #{elemento}")
    locator_elemento.set valor
end

def preencher_file_field(locator_elemento, caminho_arquivo, elemento)
    elemento_existe?(locator_elemento, "File Field #{elemento}")
    locator_elemento.set(caminho_arquivo)
end

def preencher_input(locator_elemento, valor, elemento)
    elemento_existe?(locator_elemento, "TextField #{elemento}")
    locator_elemento.send_keys valor
end

def obter_valor_textfield(locator_elemento, elemento)
    elemento_existe?(locator_elemento, "Valor TextField #{elemento}")
    locator_elemento.value
end

def flash_elemento(locator_elemento, elemento)
    elemento_existe?(locator_elemento, "Valor Elemento #{elemento}")
    locator_elemento.flash
end

def preencher_combobox(locator_elemento, valor, elemento)
    elemento_existe?(locator_elemento, "ComboBox #{elemento}")
    # validar_tipo_tag(locator_elemento, 'select_list', tela)
    begin
        locator_elemento.option(text: valor).select
    rescue Watir::Exception::NoValueFoundException
        raise "Tela #{@tela} - ComboBox '#{elemento}' não possui um item com o valor #{valor}"
    end
end

def selecionar_combobox(locator_elemento, valor, elemento)
    elemento_existe?(locator_elemento, "ComboBox (Table) #{elemento}")
    locator_elemento.tbody.trs.each do |tabela|
        tabela.tds.each do |celula|
             if celula.text == valor
                celula.click
                break
            end
        end
    end
end

def validar_item_combobox(locator_elemento, valor, elemento)
    elemento_existe?(locator_elemento.option(text: valor), "Item ComboBox '#{elemento}'")
end

def clicar_elemento(locator_elemento, elemento)
    elemento_existe?(locator_elemento, "#{elemento} a ser clicado")
    locator_elemento.click
end

def clicar_botao(locator_elemento, elemento)
    clicar_elemento(locator_elemento, elemento)
    aguardar_loading
end

def is_number?(string)
    true if Float(string) rescue false
end

def substituir_valor(valor_velho, valor_novo, elemento)
    elemento.gsub(valor_velho, valor_novo)
end

def validar_numericos?(nome_elemento, elemento, valor)
    require 'bigdecimal'
    valor_num = BigDecimal.new(valor.to_s)
    if valor_num.frac == 0
        raise "Tela #{@tela} - Elemento #{nome_elemento} de valor #{elemento} é incorreto. Esperado: Elemento do tipo inteiro." unless valor_num.to_i
    else
        valor_num.to_f
        if valor == '0.0'
            raise "Tela #{@tela} - Elemento #{nome_elemento} de valor #{elemento} é incorreto. Esperado: Elemento do tipo float/decimal."
        end
    end
end

def verificar_texto(nome_elemento, texto)
    raise "Tela #{@tela} - Elemento #{nome_elemento} de valor #{texto} não encontrado. Esperado: Elemento encontrado." if !nome_elemento.text.include? texto
end

def randomizar_numeros(valor_inicial, valor_final)
    rand(valor_inicial..valor_final)
end

def elemento_validar_valores(valor_esperado, elemento, nome_elemento)
    valor_inicial = elemento.value
    raise "Tela #{@tela} - Elemento #{nome_elemento} não possui o valor esperado. Esperado: #{valor_esperado}" unless valor_inicial.eql? valor_esperado
end

def elemento_validar_valores_texto(valor_esperado, elemento, nome_elemento)
    valor_inicial = elemento.text
    raise "Tela #{@tela} - Elemento #{nome_elemento} não possui o valor esperado. Esperado: #{valor_esperado}" unless valor_inicial.to_s == valor_esperado.to_s
    #raise "Tela #{@tela} - Elemento #{nome_elemento} não possui o valor esperado. Esperado: #{valor_esperado}" unless valor_inicial.eql? valor_esperado
end

def confirmar_selecao(locator_button)
    if locator_button.exist?
        locator_button.click
    else
        raise "N\xC3\xA3o foi poss\xC3\xADvel confirmar a sele\xC3\xA7\xC3\xA3o"
    end
end

########################################################################################################################
# Elements (JavaScript)
########################################################################################################################
def js_preencher_textfield(locator_elemento, valor, elemento)
    elemento_existe?(locator_elemento, "TextField #{elemento}")
    @driver.execute_script('arguments[0].value=arguments[1]', locator_elemento, valor)
end

def js_preencher_combobox(locator_elemento, valor, elemento) # locator_elemento deve ser a tag pai da tag 'li'. Ex: 'ul'
    elemento_existe?(locator_elemento, "ComboBox #{elemento}")
    elemento_existe?(locator_elemento.li(text: valor), "ComboBox(li) #{elemento} com o valor '#{valor}'")
    @driver.execute_script('arguments[0].click()', locator_elemento.li(text: valor))
end

def js_clicar_elemento(locator_elemento, elemento)
    elemento_existe?(locator_elemento, "#{elemento} a ser clicado via JS")
    @driver.execute_script('arguments[0].click()', locator_elemento)
end

def js_clicar_botao(locator_elemento, elemento)
    js_clicar_elemento(locator_elemento, elemento)
    aguardar_loading
end

def js_preencher_combobox_dataLabel(locator_elemento, valor, elemento) # locator_elemento deve ser a tag pai da tag 'li'. Ex: 'ul'
    elemento_existe?(locator_elemento, "ComboBox #{elemento}")
    sleep 2
    elemento_existe?(locator_elemento.li(text: valor), "ComboBox(li) #{elemento} com o valor '#{valor}'")
    sleep 2
    $browser.execute_script('arguments[0].click()', locator_elemento.li(text: valor))
    sleep 2
end



########################################################################################################################
# Table
########################################################################################################################
def elemento_nome_coluna_existe?(locator_tabela, nome_coluna, nome_tabela = '')
    elemento_existe?(locator_tabela.th(text: nome_coluna), "Coluna #{nome_coluna} na Tabela #{nome_tabela}")
end

def obter_id_coluna(locator_tabela, nome_coluna, nome_tabela = '')
    id_nome_coluna = 0
    elemento_nome_coluna_existe?(locator_tabela, nome_coluna, nome_tabela)
    locator_tabela.ths.each_with_index do |cabecalho, index|
        next unless cabecalho.text == nome_coluna
        id_nome_coluna = index
        break
    end
    id_nome_coluna
end

def obter_registro_tabela_pela_coluna(locator_tabela, nome_coluna, valor_pesquisa, _nome_tabela = '')
    # TODO
    num_id_nome_coluna.each = obter_id_coluna(locator_tabela, nome_coluna)
    pesquisa_simples_tabela(locator_tabela, num_id_nome_coluna, valor_pesquisa)
end

def pesquisa_composta_tabela(locator_tabela, id_colunas_pesquisa, valores_pesquisa)
    # TODO: Realizar pesquisa com uma ou mais validações
end

def pesquisa_simples_tabela(locator_tabela, id_coluna_pesquisa, valor_pesquisa)
    # TODO: Realizar pesquisa com uma validação
end

def convert_table_rows_to_array(tabela)
    array = []
    tabela.rows.each do |table|
        array << table.text
    end
    array
end

def convert_table_cells_to_array(tabela)
    array = []
    tabela.trs.each_with_index do |linha, _index_linha|
        array_linha = []
        linha.ths.each_with_index do |_celula, index_coluna|
            array_linha << linha[index_coluna].text
        end
        linha.tds.each_with_index do |_celula, index_coluna|
            array_linha << linha[index_coluna].text
        end
        array << array_linha
    end
    array
end

def numero_linhas_tabela(locator_tabela, nome_elemento = '')
    validar_tipo_objeto(locator_tabela, 'Watir::Table', nome_elemento)
    return locator_tabela.rows.length.to_i
end

########################################################################################################################
# Matchers
########################################################################################################################
def valores_iguais?(esperado, atual, nome_campo)
    raise "Tela #{@tela} - #{nome_campo} divergente. Esperado: '#{esperado}'. Encontrado: '#{atual}'" unless esperado.to_s == atual.to_s
end

def valores_iguais_preco_especial?(esperado, atual, nome_campo)
    esperado = esperado.gsub('["', '').gsub('"[', '').gsub('"]', '').gsub(']"', '').gsub('[\\', '')  unless esperado.nil?
    atual = atual.gsub('["', '').gsub('"[', '').gsub('"]', '').gsub(']"', '').gsub('[\\', '')  unless atual.nil?

    raise "Tela #{@tela} - #{nome_campo} divergente. Esperado: #{esperado}. Encontrado: #{atual}" unless esperado.to_s == atual.to_s
end

def validar_tipo_tag(locator_elemento, tag, elemento)
    raise "Tela #{@tela} - Tag do elemento #{elemento} divergente . Esperado: #{tag}. Encontrado: #{locator_elemento.class}" unless locator_elemento.class_name == tag
end

def compara_array(array_base, array_comparacao, nome_tabela = '')
    # TODO
end

def validar_tipo_objeto(locator_elemento, objeto_esperado, nome_elemento)
    raise "Tela #{@tela} - Elemento #{nome_elemento} não é o objeto esperado #{objeto_esperado}. Esperado: Objeto #{objeto_esperado}." unless locator_elemento.class.to_s.eql? objeto_esperado
end

########################################################################################################################
# FORMATERS
########################################################################################################################
def formata_data_atual(formato)
    case formato
    when 'dd/mm/aaaa'
        format_atual = '%d/%m/%Y'
    when 'aaaa-mm-dd'
        format_atual = '%Y-%m-%d'
    end
    Time.now.strftime(format_atual)
end

def formata_data_atual_sem_horario(data, formato)
    case formato
    when 'dd/mm/aaaa'
        dia = data[0..2]
        mes = data[3..4]
        ano = data[6..9]
        format_atual = '%d/%m/%Y'
        Time.new(ano, mes, dia, 0).strftime(format_atual)
    when 'aaaa-mm-dd'
        format_atual = '%Y-%m-%d'
    end
end

def formata_data_tomorrow(formato)
    case formato
    when 'dd/mm/aaaa'
        format_atual = '%d/%m/%Y'
    when 'aaaa-mm-dd'
        format_atual = '%Y-%m-%d'
    end
    tomorrow = Date.today + 1
    return tomorrow.strftime(format_atual)
end

########################################################################################################################
# RegEdit Windows
########################################################################################################################
def ler_registro(path_registro, nome_registro)
    # Win32::Registry::HKEY_CURRENT_USER.open('SOFTWARE\foo') do |reg|
    #   value = reg['foo']                               # read a value
    #   value = reg['foo', Win32::Registry::REG_SZ]      # read a value with type
    #   type, value = reg.read('foo')                    # read a value
    #   reg['foo'] = 'bar'                               # write a value
    #   reg['foo', Win32::Registry::REG_SZ] = 'bar'      # write a value with type
    #   reg.write('foo', Win32::Registry::REG_SZ, 'bar') # write a value

    #   reg.each_value { |name, type, data|  }        # Enumerate values
    #   reg.each_key { |key, wtime| ... }                # Enumerate subkeys

    #   reg.delete_value(name)                         # Delete a value
    #   reg.delete_key(name)                           # Delete a subkey
    #   reg.delete_key(name, true)                     # Delete a subkey recursively
    # end
end

def alterar_valor_registro(path_registro, nome_registro, valor)
    # Win32::Registry::HKEY_CURRENT_USER.open(path_registro) do |reg|
    #   break if reg[nome_registro, Win32::Registry::REG_SZ] == valor
    #   reg.write(nome_registro, Win32::Registry::REG_SZ, valor)
    # end
    # puts "Local download arquivo: c:\Downloads"
end

########################################################################################################################
# Zip Files
########################################################################################################################
def arquivo_existe?(caminho_completo_arquivo)
    raise 'ERRO: Nome Arquivo em branco' if caminho_completo_arquivo == ''
    raise "ERRO: Arquivo #{caminho_completo_arquivo} não existe" unless File.exist?(caminho_completo_arquivo)
end

def extrair_nome_arquivo_zip(caminho_completo_arquivo, destino)
    arquivo_descompactado = ''
    arquivo_existe?(caminho_completo_arquivo)

    Zip::File.open(caminho_completo_arquivo) do |zip_file|
        zip_file.each do |f|
            fpath = File.join(destino, f.name)
            zip_file.extract(f, fpath) unless File.exist?(fpath)
            arquivo_descompactado = f
        end
    end
    arquivo_descompactado
end

########################################################################################################################
# CSV Files
########################################################################################################################
def obter_registros_arquivo_csv(caminho_completo_arquivo)
    array = []
    quote_chars_csv = %w(" | ~ ^")
    CSV.foreach(caminho_completo_arquivo, quote_char: quote_chars_csv.shift, encoding: 'iso-8859-1:utf-8') do |linha|
        array_linha = []
        array_linha << linha.to_s.split(';')
        array += array_linha
    end

    array
end

########################################################################################################################
# Regex Text
########################################################################################################################
  def regex_cnpj
    regex = /^[0-9]{2}.[0-9]{3}.[0-9]{3}\/[0-9]{4}-[0-9]{2}$/
  end

  def regex_cpf
    regex = /^[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}$/
  end

  def regex_data_pt
    regex = /^[0-3][0-9]\/[0-1][0-9]\/[2][0-9][1-9][0-9]$/
  end

  def regex_hora
    regex = /^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$/
  end

  def regex_data_pt_hora
    regex = /^[0-3][0-9]\/[0-1][0-9]\/[2][0][1][0-6] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]$/
  end

  def regex_porcentagem
    regex = /^[0-9]+,[0-9]{3}%$/
  end

  def regex_real
    regex = /^[R][$] [0-9]+,[0-9]{2}$/
  end

  def regex_real_negativo
    regex = /^[-] [R][$] [0-9]+,[0-9]{2}$/
  end

  def regex_prazo
    regex = /^[0-9]+,[0-9]{2}$/
  end

########################################################################################################################
# Actions
########################################################################################################################
  def arraste_e_solte(objeto_pegar, elemento_pegar, objeto_destino, elemento_destino)
    elemento_existe?(objeto_pegar, "#{elemento_pegar} a selecionar (drag and drop)")
    elemento_existe?(objeto_destino, "#{elemento_destino} a ser populado(drag and drop)")
    objeto_pegar.drag_and_drop_on(objeto_destino)
  end
  
  def parar_teste
      Process.kill 9, Process.pid
  end