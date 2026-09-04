\newpage
\pagestyle{fancy}
\pagenumbering{arabic}
\setcounter{page}{1}
\fancyhead[R]{\textit{Livro I: CSS}}

# Capítulo I

\vspace{-1em}

## Tudo é uma Caixa

\vspace{1em}

Antes de você escrever `display: flex` e sentir que finalmente domou o CSS, precisa engolir uma verdade desconfortável: o navegador não enxerga "cards", "botões" ou "seções bonitas". Ele enxerga caixas retangulares empilhadas umas sobre as outras segundo regras que existem desde os anos 90 e que ninguém nunca te explicou direito. Layout quebrado quase nunca é culpa do Flexbox ou do Grid - é culpa de você não saber o que a caixa estava fazendo antes de você mexer nela.

Neste capítulo a gente desmonta a caixa: as quatro camadas que todo elemento tem, o cálculo de largura que o CSS erra por padrão há décadas, e as regras invisíveis de empilhamento que fazem seus espaçamentos aparecerem "do nada" ou sumirem sem explicação.

### 1.1 A Anatomia da Caixa

Todo elemento renderizado na tela - um parágrafo, uma imagem, uma `div` vazia - é desenhado pelo navegador como uma caixa composta por quatro camadas, de dentro para fora:

1. **Content (conteúdo):** onde o texto, a imagem ou os elementos filhos de fato aparecem. É o que `width` e `height` medem;
2. **Padding (preenchimento):** o espaço entre o conteúdo e a borda. Empurra a borda para longe do conteúdo e recebe a cor de fundo do elemento;
3. **Border (borda):** a linha que circunda o padding. Tem espessura, estilo e cor;
4. **Margin (margem):** o espaço do lado de fora da borda. Afasta esta caixa das caixas vizinhas e nunca recebe cor de fundo.

Uma regra mental que economiza horas de depuração: **`padding` empurra para dentro, `margin` empurra para fora**. Se o texto está grudado na borda do card, o problema é `padding`. Se dois cards estão grudados um no outro, o problema é `margin`.

\newpage

```css
.card {
  width: 300px;
  padding: 20px;
  border: 2px solid #333;
  margin: 16px;
}
```

Abra o DevTools, selecione esse `.card` e no painel lateral você vê o diagrama do box model com esses quatro valores aninhados. Decore esse diagrama. É o mapa que você vai consultar toda vez que algo estiver "com um espaço estranho".

### 1.2 O Erro Histórico: `box-sizing`

Pergunta que parece boba: o `.card` do exemplo acima ocupa quantos pixels de largura na tela?

Você respondeu 300. Está errado. Por padrão, ocupa **344px**.

O CSS, por decisão histórica, calcula `width` como a largura _apenas do content_. O padding e a borda são somados por fora: a largura real é `width` mais os dois paddings mais as duas bordas, ou seja, `300 + 20 + 20 + 2 + 2 = 344`.

Esse é o modelo `content-box`, o valor padrão. É contra-intuitivo, quebra layouts e é a razão de `width: 100%` com qualquer `padding` estourar o container e criar aquela barra de rolagem horizontal que você jura que não colocou.

A correção cabe em quatro linhas e vai em todo projeto sério, antes de qualquer outra regra:

```css
*,
*::before,
*::after {
  box-sizing: border-box;
}
```

Com `border-box`, o `width` passa a incluir padding e borda. Aquele `.card` volta a ocupar exatamente os 300px que você pediu, e o padding "come" o espaço para dentro em vez de inflar a caixa. `width: 100%` com `padding: 20px` agora se comporta como qualquer pessoa sã esperaria.

> **Nota do Autor:** não existe projeto profissional de CSS sem esse reset. Frameworks como Tailwind e Bootstrap já o aplicam por você. No CSS cru, a responsabilidade é sua - cole essas linhas no topo da folha de estilo e nunca mais pense nisso.

### 1.3 O Fluxo do Documento

Antes de qualquer `flex` ou `grid`, os elementos se posicionam sozinhos segundo o **fluxo normal do documento**: a ordem em que aparecem no HTML, respeitando o tipo de exibição de cada um. Os três tipos que você precisa saber de cor:

**`display: block`** - a caixa começa numa linha nova e empurra o próximo elemento para a linha de baixo. Ocupa toda a largura disponível do pai, mesmo que o conteúdo seja pequeno. Respeita `width`, `height` e margens dos quatro lados. É o padrão de `<div>`, `<p>`, `<h1>`, `<section>` e `<ul>`.

**`display: inline`** - a caixa flui junto com o texto, na mesma linha, quebrando só quando a linha acaba. **Ignora `width` e `height`**. Ignora `margin-top` e `margin-bottom` (as laterais funcionam). É o padrão de `<span>`, `<a>`, `<strong>` e `<em>`.

**`display: inline-block`** - o híbrido: flui na mesma linha que o texto, como `inline`, mas **respeita `width`, `height` e todas as margens**, como `block`. Serve para colocar dois elementos lado a lado sem partir para um sistema de layout, ou para dar dimensão a um `<a>` que precisa virar botão.

```css
.tag {
  display: inline-block;
  width: 80px;
  padding: 4px 8px;
}
```

Se você já tentou definir `height` num `<span>` e nada aconteceu, agora sabe por quê: `inline` ignora. Troque para `inline-block` (ou `block`) e a altura passa a valer.

### 1.4 O Colapso de Margens

Cenário: dois parágrafos, um embaixo do outro. O de cima tem `margin-bottom: 30px`. O de baixo tem `margin-top: 20px`. Qual o espaço entre eles?

Não é 50px. É **30px**.

Margens verticais adjacentes **colapsam**: em vez de somar, o navegador usa só a maior das duas e descarta a menor. Isso se chama _margin collapse_ e acontece em três situações clássicas:

1. **Entre irmãos:** o `margin-bottom` de um elemento e o `margin-top` do seguinte, como no exemplo acima;
2. **Entre pai e primeiro filho:** se o container não tem `padding` nem `border` no topo, o `margin-top` do primeiro filho "vaza" para fora do pai e colapsa com o `margin-top` do pai;
3. **Numa caixa vazia:** o próprio `margin-top` e `margin-bottom` de um elemento sem conteúdo, altura ou borda colapsam entre si.

O colapso **só acontece com margens verticais** e **só no fluxo normal**. Ele não acontece:

- na horizontal - margens laterais sempre somam;
- dentro de um container `flex` ou `grid` - mais um motivo para usá-los;
- se houver `padding`, `border` ou qualquer conteúdo separando as duas margens.

> **Cuidado:** o colapso entre pai e filho é o que mais confunde. Você põe `margin-top` num título dentro de um card e o card inteiro desce, com um espaço em branco por cima dele - a margem escapou. Soluções: um `padding` no card, uma `border`, ou (melhor) transformar o card em `display: flex` com `flex-direction: column`.

### 1.5 O Que Levar Deste Capítulo

- Todo elemento é uma caixa de quatro camadas: content, padding, border, margin;
- `box-sizing: border-box` no seletor universal, sempre, antes de tudo;
- `block` empilha e respeita dimensões; `inline` flui e ignora `width` e `height`; `inline-block` faz as duas coisas;
- margens verticais colapsam para a maior; padding, border, flex e grid quebram o colapso.

Com a caixa entendida, o próximo capítulo ataca a pergunta "por que esse estilo não está sendo aplicado?" - seletores, especificidade e a cascata.
