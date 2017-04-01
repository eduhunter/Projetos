# encoding: utf-8
require 'magic_encoding'

class PesquisaPageLocators
   
    def txtfield_busca
      @driver.text_field(:id => 'lst-ib')
    end

    def txtlabel_sem_resultado
      @driver.div(:class => 'med card-section')
    end
    
end
