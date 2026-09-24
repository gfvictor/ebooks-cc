\newpage

# Capítulo IV

\vspace{-1em}

## Layout na Prática

\vspace{1em}

Os Capítulos III e IV do Livro I ensinaram Flexbox e Grid escrevendo CSS puro. Este capítulo refaz os mesmos layouts em utilitário, e a boa notícia é que quase não há nada novo para aprender: cada propriedade CSS que você já conhece tem um utilitário com nome parecido.

### 4.1 Flexbox em Utilitários

A tabela abaixo faz a ponte direta entre o que o Livro I ensinou e o utilitário equivalente:

| Propriedade CSS           | Utilitário       |
| ------------------------- | ---------------- |
| `display: flex`           | `flex`           |
| `flex-direction: column`  | `flex-col`       |
| `justify-content: center` | `justify-center` |
| `align-items: center`     | `items-center`   |
| `flex-wrap: wrap`         | `flex-wrap`      |
| `gap: 1rem`               | `gap-4`          |

O "meme resolvido em três linhas" do Livro I - centralizar uma div, no eixo principal e no cruzado - vira uma linha só de classe:

```html
<div class="flex items-center justify-center">
  <div>Centralizado</div>
</div>
```

E uma barra com título à esquerda e ações à direita, que no CSS puro pedia `flex: 1` no título, usa o mesmo raciocínio, só que como classe:

```html
<div class="flex items-center gap-4">
  <h2 class="flex-1">Título</h2>
  <button>Ação</button>
</div>
```

`flex-1` equivale a `flex: 1 1 0%`: o título cresce para ocupar o espaço livre, empurrando o botão para a ponta - exatamente o comportamento que o Capítulo III do Livro I descreveu.

### 4.2 A Propriedade `flex` Resumida

O Livro I mostrou que `flex-grow`, `flex-shrink` e `flex-basis` quase sempre aparecem juntos, através da abreviação `flex`. O Tailwind já vem com as combinações mais comuns prontas:

| Utilitário  | Equivale a | Uso                                      |
| ----------- | ---------- | ---------------------------------------- |
| `flex-1`    | `1 1 0%`   | dividir o espaço igualmente entre irmãos |
| `flex-auto` | `1 1 auto` | crescer, partindo do tamanho do conteúdo |
| `flex-none` | `0 0 auto` | tamanho fixo, não cresce nem encolhe     |

Não existe um utilitário para cada combinação possível de `grow`/`shrink`/`basis` separadamente - as três combinações acima cobrem a esmagadora maioria dos casos reais, e é por isso que elas viraram atalho.

### 4.3 Grid em Utilitários

Grid segue o mesmo princípio de tradução direta:

```html
<div class="grid grid-cols-3 gap-4">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>
```

`grid-cols-3` equivale a `grid-template-columns: repeat(3, minmax(0, 1fr))` - três colunas de largura igual. Um item pode ocupar mais de uma coluna com `col-span-*`, o equivalente ao `grid-column: span N` do Livro I:

```html
<div class="grid grid-cols-3 gap-4">
  <div class="col-span-2">Ocupa duas colunas</div>
  <div>Ocupa uma</div>
</div>
```

Para o grid responsivo do Livro I - poucas colunas no celular, mais colunas na tela grande - o jeito idiomático em Tailwind não é reproduzir `auto-fit`/`minmax` diretamente; é combinar `grid-cols-*` com os prefixos de largura do Capítulo III:

```html
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>
```

### 4.4 Quando a Escala Não Basta: Valores Arbitrários

Nem todo layout cabe nas colunas prontas. Se você precisa exatamente do `repeat(auto-fit, minmax(220px, 1fr))` do Livro I - colunas que se reorganizam sozinhas, sem depender de um prefixo de largura - o Tailwind permite escrever o valor CSS bruto entre colchetes:

```html
<div class="grid grid-cols-[repeat(auto-fit,minmax(220px,1fr))] gap-4"></div>
```

Isso se chama valor arbitrário, e funciona em praticamente qualquer utilitário, não só em grid: `w-[137px]`, `bg-[#1da1f2]`, `top-[calc(100%+8px)]`. É a válvula de escape para o dia em que a escala pronta não tem o valor exato que você precisa - você continua escrevendo uma classe, só que com CSS de verdade dentro dos colchetes, em vez de um número da escala padrão.

> **Cuidado:** valor arbitrário é escape, não o caminho principal. Usá-lo toda hora é sinal de que talvez a escala do projeto devesse ganhar mais um valor formal no `@theme`, coisa que o próximo capítulo resolve. Reserve os colchetes para exceções de verdade, não para fugir da escala por preguiça de abrir o `globals.css`.

Sobre nomear áreas de grid com `grid-template-areas`, como o Livro I ensinou: o Tailwind não tem utilitário dedicado para isso, porque a ideia central do framework é compor a partir de peças pequenas, não nomear regiões inteiras de layout. Quando um grid realmente pede áreas nomeadas, a saída mais comum é valor arbitrário na própria declaração, ou simplesmente voltar ao CSS puro do Livro I para aquele componente específico. Nenhuma ferramenta resolve tudo, e admitir isso é mais útil do que forçar uma solução torta.

### 4.5 O `container`

`container` é um utilitário que limita a largura do conteúdo e a ajusta em degraus, um por breakpoint, em vez de crescer livremente até a borda da tela:

```html
<div class="container mx-auto px-4">
  <p>Conteúdo</p>
</div>
```

Sozinho, `container` só define a largura máxima em cada ponto de quebra; ele não centraliza nem adiciona respiro nas laterais por padrão - por isso aparece quase sempre ao lado de `mx-auto` (margem automática nos dois lados, centralizando) e um `px-*` (preenchimento lateral, para o conteúdo não colar na borda em telas pequenas). Se o projeto precisar de um comportamento padrão diferente - sempre centralizado, sempre com um preenchimento mínimo - isso se personaliza no `globals.css` com a diretiva `@utility`, que redefine um utilitário existente em vez de usar tabelas de configuração em JavaScript.

### 4.6 O Que Levar Deste Capítulo

- todo utilitário de Flexbox e Grid é a mesma propriedade CSS do Livro I, só que com um nome curto: `flex`, `items-center`, `grid-cols-3`, `gap-4`;
- `flex-1`/`flex-auto`/`flex-none` cobrem as combinações reais de `grow`/`shrink`/`basis` sem precisar escrever as três separadas;
- grid responsivo, em Tailwind, normalmente combina `grid-cols-*` com prefixo de largura, não `auto-fit`/`minmax` - que ainda é possível via valor arbitrário quando for realmente necessário;
- `grid-template-areas` não tem utilitário dedicado; um grid que precisa de áreas nomeadas às vezes é mais honesto em CSS puro;
- `container` só define largura máxima por breakpoint; centralizar e dar respiro lateral é trabalho de `mx-auto` e `px-*` ao lado dele.

O próximo capítulo volta à escala e ao tema - agora para você escrever a sua própria, em vez de só usar a que vem pronta.
