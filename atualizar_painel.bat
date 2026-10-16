@echo off
rem ------------------------------------------------------------------
rem Atualiza os dados do painel e publica (usado pelo Agendador de Tarefas)
rem Gera dados/carteira.rds e manifest.json e envia ao GitHub;
rem o Posit Connect Cloud republica sozinho. Log em atualizacao.log.
rem ------------------------------------------------------------------
cd /d "%~dp0"

rem Se o Rscript nao estiver no PATH, troque pelo caminho completo,
rem por exemplo "C:\Program Files\R\R-4.4.1\bin\Rscript.exe"
set RSCRIPT=Rscript

echo ==== %date% %time% ==== >> atualizacao.log
git pull --rebase origin main >> atualizacao.log 2>&1
%RSCRIPT% atualizar_dados.R >> atualizacao.log 2>&1
if errorlevel 1 (
  echo Falha ao gerar os dados; nada foi publicado. >> atualizacao.log
  exit /b 1
)
git add dados/carteira.rds manifest.json >> atualizacao.log 2>&1
git commit -m "Atualizacao automatica dos dados (%date%)" >> atualizacao.log 2>&1
git push origin main >> atualizacao.log 2>&1
