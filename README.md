# Fundamentos da Web Moderna

## Coletânea de Manuais — Ciência da Computação

Este repositório reúne os materiais didáticos da coletânea **Fundamentos da Web Moderna**, um conjunto de manuais produzidos como Atividade de Extensão Acadêmica do curso de Ciência da Computação da UNIP (Universidade Paulista).

Enquanto a trilogia (ou saga) _Git: Versionamento de Código & Fluxo de Trabalho_ cobre o fluxo de trabalho colaborativo, esta coletânea cobre a base técnica para construir interfaces web: da folha de estilo crua ao framework de aplicação.

---

## Estrutura da Obra

Cada livro proposto é modular e independente, organizado da fundação para a superfície:

- **Livro I — CSS: A Fundação Visual.**
  Modelo de caixa, seletores e especificidade, Flexbox, Grid, unidades responsivas e custom properties;

- **Livro II — Tailwind CSS: Utilitário Primeiro.**
  O modelo mental de utilitários, responsividade e estados, design tokens (`@theme`) e componentização;

- **Livro III — Next.js com App Router: A Base.**
  Roteamento por arquivos, Server e Client Components, busca de dados, Server Actions e deploy;

- **Livro IV — TypeScript Sem Medo.**
  Tipos do dia a dia, inferência, narrowing, generics e validação em runtime com Zod.

---

## Pré-requisitos

Para compilar os livros a partir do código-fonte você precisa de:

- **Pandoc** — conversão de documentos;
- **Tectonic** — motor LaTeX moderno e auto-gerenciado;
- **Lua** — usada pelo script de automação do build.

## Instalação

```bash
macOS (via Homebrew)
$ brew install pandoc tectonic lua

Linux (Debian/Ubuntu)

$ sudo apt install pandoc lua5.4
```

---

### Como Gerar os PDFs

```bash
$ lua build.lua <nome-do-livro>

# Exemplo:
$ lua build.lua css
```

O PDF resultante é gerado em output/. Capítulos bônus e referências são incluídos automaticamente quando existem.

---

### Padronização de Estilo

A formatação dos arquivos-fonte (Markdown, YAML, JSON) segue o pacote codifylab-config, que centraliza as regras de Prettier usadas nos projetos.

```bash
$ npm install          # instala as ferramentas de formatação
$ npm run format       # aplica o padrão em todo o repositório
$ npm run format:check # apenas verifica, sem escrever
```

---

Extensão Acadêmica (UNIP)

- Autor: Victor Gama de Farias.
- Curso: Ciência da Computação - UNIP.
- Contato: gfvictor@pm.me
