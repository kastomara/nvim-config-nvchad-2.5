-- Конфигурация языкового сервера R
-- Устанавливаем в R: install.packages(c("languageserver", "styler"))
return {
  cmd = { 'R', '--no-echo', '-e', 'languageserver::run()' },
  filetypes = { 'r', 'rmd', 'quarto' },
  root_markers = {
    '.Rproj',
    'DESCRIPTION',
    'NAMESPACE',
    '.git',
  },
  settings = {
    r = {
      lsp = {
        diagnostics = true,
        rich_documentation = true,
        snippet_support = true,
        max_completions = 200,
        lintr_cache = true,
      },
    },
  },
}
