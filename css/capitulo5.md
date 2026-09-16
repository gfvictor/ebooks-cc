\newpage

# Capítulo V

\vspace{-1em}

## Uma Página, Todas as Telas

\vspace{1em}

Você constrói a página no seu monitor de 1440 pixels de largura, tudo alinhado, tudo no lugar. Aí alguém abre no celular de 375 pixels segurado com uma mão só, e o seu layout lindo vira uma coluna de texto que sangra pela lateral, com um botão importante escondido embaixo da barra de endereço. O problema não é o celular. O problema é que você desenhou a página para exatamente uma tela - a sua.

Responsividade é a página se adaptar ao espaço que tem, em vez de você manter doze versões dela. Isso se apoia em duas ideias: **parar de medir tudo em pixel fixo** e **escrever o layout do menor para o maior**. Este capítulo é sobre as duas.

### 5.1 O Problema do Pixel Fixo

O `px` é uma unidade absoluta: `16px` é sempre 16 pixels, não importa o dispositivo, o tamanho da tela ou as preferências de quem está lendo. Isso o torna previsível e, para algumas coisas, ele é a escolha certa - a espessura de uma borda, o raio de um canto, o deslocamento de uma sombra. São detalhes que não deveriam crescer só porque a tela é maior.

O veneno começa quando você mede em `px` as coisas que **deveriam** se adaptar: o tamanho da fonte, as larguras do layout, os espaçamentos, os pontos de quebra. Um usuário que aumentou a fonte padrão do navegador (porque enxerga mal, porque está num monitor a três metros de distância) não vê diferença nenhuma se o seu texto está travado em `font-size: 14px`. Você ignorou a decisão dele.

### 5.2 Unidades Relativas: `rem` e `em`

Duas unidades resolvem isso ao se ancorarem no tamanho de fonte em vez de num número cravado:

- **`rem`** - relativa ao `font-size` do elemento raiz (`<html>`), que por padrão é 16px e respeita a configuração do navegador do usuário. `1rem` = o tamanho de fonte base; `1.5rem` = uma vez e meia isso. É **previsível**: o valor de `rem` significa a mesma coisa em qualquer lugar da página;
- **`em`** - relativa ao `font-size` do **próprio elemento**. Serve para algo que deve escalar junto com o texto local - o `padding` de um botão, por exemplo, cresce proporcionalmente se aquele botão tiver uma fonte maior.

A pegadinha do `em` é que ele **compõe**: se um elemento com `font-size: 1.2em` está dentro de outro com `font-size: 1.2em`, o de dentro fica com 1.44 vezes o tamanho do avô, e isso empilha a cada nível de aninhamento. Por isso a regra prática: **`rem` para quase tudo** (fontes, espaçamentos, larguras), e `em` só quando você quer de propósito que uma medida acompanhe o texto imediato.

> **Nota do Autor:** o ganho aqui não é estético, é de acessibilidade. Quando tudo está em `rem`, o usuário aumenta a fonte do navegador uma vez e a página inteira - texto, botões, espaços - cresce junto, mantendo as proporções. Com `px`, ele aumenta a fonte e nada acontece. Uma dessas páginas respeita quem a lê; a outra não.

### 5.3 Unidades de Viewport: `vw` e `vh`

`vw` e `vh` medem em relação ao tamanho da **janela de visualização** (o _viewport_): `1vw` = 1% da largura da janela, `1vh` = 1% da altura. `100vh` é a altura inteira da tela. Servem para seções que precisam ocupar a tela toda - um _hero_ de página inicial, um painel de altura cheia.

| Unidade | 1% de...                     |
| ------- | ---------------------------- |
| `vw`    | largura do viewport          |
| `vh`    | altura do viewport           |
| `vmin`  | o **menor** lado do viewport |
| `vmax`  | o **maior** lado do viewport |

Dois cuidados. Primeiro: `100vw` inclui a área da barra de rolagem vertical, então um elemento com `width: 100vw` numa página que rola provoca uma barra de rolagem horizontal de alguns pixels. Segundo: no celular, `100vh` historicamente considera a tela com a barra de endereço recolhida, o que faz o conteúdo "pular" quando ela aparece. As unidades `svh`, `lvh` e `dvh` (viewport pequeno, grande e dinâmico) existem justamente para você dizer qual comportamento quer - `dvh` acompanha a barra em tempo real.

### 5.4 Porcentagem

`%` parece com `vw`, mas mede em relação ao **elemento pai**, não ao viewport. `width: 50%` num elemento é metade da largura do container dele, seja lá qual for. Se o pai tem 400px, são 200px; se o pai é o `body` numa tela cheia, aí sim se aproxima de `vw`. Use `%` quando a referência é o container (uma coluna que ocupa metade da linha); use `vw`/`vh` quando a referência é a tela.

### 5.5 `clamp()`, `min()` e `max()`

Estas três funções calculam um valor a partir de outros e deixam você fazer dimensionamento fluido **sem media query nenhuma**:

```css
.titulo {
  font-size: clamp(1.5rem, 4vw, 3rem);
}

.conteudo {
  width: min(100%, 60rem);
}
```

`clamp(min, ideal, max)` devolve o valor `ideal` (aqui `4vw`, que acompanha a largura da tela), mas nunca deixa passar de `1.5rem` para baixo nem de `3rem` para cima. O título encolhe e cresce suavemente entre esses limites conforme a janela muda de tamanho, e você não escreveu um único `@media`.

`min(100%, 60rem)` lê-se como "o que for menor: 100% do pai ou 60rem". Numa tela larga, o conteúdo trava em 60rem e não vira uma linha de texto de dois palmos; numa tela estreita, vira 100% e respeita a margem. É o padrão moderno para limitar a largura de leitura.

### 5.6 Media Queries e Mobile-First

Quando a adaptação fluida não basta - o layout precisa **mudar de forma**, de uma coluna para três, de menu escondido para menu na barra - aí entra a media query:

```css
.grade {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@media (min-width: 48rem) {
  .grade {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

Repare na ordem: o estilo **base**, fora de qualquer query, é o do celular - uma coluna. A media query com `min-width` **adiciona** o layout de três colunas quando há pelo menos 48rem de largura. Isso é _mobile-first_: você escreve para a tela pequena primeiro e vai enriquecendo para telas maiores.

O contrário - começar pelo desktop e usar `max-width` para "consertar" no celular - funciona, mas te obriga a desescrever estilos a cada breakpoint, e telas pequenas (onde está a maioria dos acessos e os aparelhos mais fracos) acabam carregando o CSS mais pesado. Prefira `min-width`, aditivo.

Não existe lista sagrada de breakpoints. Coloque um onde o **conteúdo** começa a ficar feio ao esticar ou espremer, não em números de modelos de celular. As mesmas media queries também respondem a preferências do sistema: `@media (prefers-reduced-motion: reduce)` para desligar animações de quem pediu, `@media (prefers-color-scheme: dark)` para tema escuro.

### 5.7 Container Queries

Media query pergunta sobre o **viewport**. Mas um componente reutilizável - um card que aparece tanto numa barra lateral estreita quanto numa área principal larga - não deveria se importar com o tamanho da tela, e sim com o espaço que **ele** recebeu. É o que a _container query_ faz:

```css
.lista-cards {
  container-type: inline-size;
}

@container (min-width: 30rem) {
  .card {
    display: grid;
    grid-template-columns: auto 1fr;
  }
}
```

O `.card` passa a layout de duas colunas quando o **container dele** tem pelo menos 30rem - não importa se a janela é grande ou pequena. É recurso relativamente recente, mas já com suporte amplo nos navegadores atuais, e resolve de vez o componente que precisava saber "onde fui colocado".

### 5.8 O Que Levar Deste Capítulo

- `px` só para detalhes que não devem escalar (borda, raio, sombra); nunca para fonte, layout e breakpoint;
- `rem` para quase tudo (previsível, respeita o usuário); `em` só quando a medida deve acompanhar o texto local, lembrando que `em` compõe;
- `vw`/`vh` medem a tela, `%` mede o pai; cuidado com `100vw` e a barra de rolagem, e com `100vh` no celular (use `dvh`);
- `clamp()`, `min()`, `max()` dão dimensionamento fluido sem media query - use `min(100%, 60rem)` para largura de leitura;
- mobile-first: estilo base para a tela pequena, media queries `min-width` aditivas para as maiores; breakpoint onde o conteúdo pede, não onde o iPhone tem;
- container queries fazem o componente reagir ao próprio espaço, não ao viewport.

Falta um último passo para o CSS deixar de ser um monte de valores repetidos e ganhar vida: variáveis que você declara uma vez e reusa, e transições que suavizam a mudança de estado. É o próximo capítulo, o que fecha o livro.
