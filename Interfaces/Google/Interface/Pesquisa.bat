rem Pesquisar valor no Google
c:

cd %cd%
cd..
call Conf.bat


cd %ARQUIVO_PATH%
cucumber --format html --out %NOME_ARQUIVO_REPORT%.html --tag @pesquisa_google

pause