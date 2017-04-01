Before do |feature|
  
end

After do |feature|

end

Before do |scenario|

  $tag_cenario = scenario.source_tag_names
  $cenario_nome = scenario.name

end

AfterStep do |scenario|
  if $encoded_img != nil
    embed("data:image/png;base64,#{$encoded_img}",'image/png')
  end
  $encoded_img = nil
end

After do |scenario|
  if scenario.failed?
    sleep 1
    encoded_img = $browser.driver.screenshot_as(:base64)
    embed("data:image/png;base64,#{encoded_img}",'image/png')
  end
  obter_evidencia
  $browser.close
end

##########################################################################
# GLOBAL HOOKS ###########################################################
##########################################################################

at_exit do
   
end
