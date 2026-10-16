# ------------------------------------------------------------------
# Atualiza o retrato dos dados usado pelo painel no Posit Connect Cloud
# ------------------------------------------------------------------
# Rode no seu PC, dentro da rede do órgão (precisa do ODBC PostgreSQLCampinas).
# Ele grava dados/carteira.rds só com as colunas que o painel usa e
# regenera o manifest.json. Depois é só enviar os dois para o GitHub.

library(DBI)

colunas <- c(
  "cod_tci", "txt_link", "num_convenio", "cod_operacao", "cod_ag_financeiro",
  "num_ano_instrumento", "dte_assinatura_contrato", "dte_carga",
  "txt_tipo_instrumento", "txt_sigla_secretaria", "txt_fonte", "dsc_sub_fonte",
  "bln_pac", "dsc_fase_pac", "bln_carteira_ativa_mcid", "bln_carteira_andamento",
  "dsc_situacao_contrato_mcid", "dsc_situacao_objeto_mcid", "dsc_objeto_instrumento",
  "txt_regiao", "txt_uf", "id_municipio", "txt_municipio",
  "txt_tipo_tomador", "txt_tomador",
  "vlr_investimento", "vlr_repasse", "vlr_contrapartida", "vlr_empenhado",
  "vlr_desbloqueado", "vlr_desembolsado"
)

conexao <- dbConnect(odbc::odbc(), database = "corporativo", "PostgreSQLCampinas", timeout = 10)
tci <- dbGetQuery(conexao, paste0(
  "SELECT ", paste(colunas, collapse = ", "),
  " FROM se_saci.view_mat_carteira_investimento WHERE bln_carteira_ativa_mcid = 'SIM'"
))
dbDisconnect(conexao)

dir.create("dados", showWarnings = FALSE)
saveRDS(tci, "dados/carteira.rds")
message(format(nrow(tci), big.mark = "."), " contratos gravados em dados/carteira.rds")

rsconnect::writeManifest(appPrimaryDoc = "carteira_investimentos_mcid.Rmd")
message("manifest.json atualizado")
