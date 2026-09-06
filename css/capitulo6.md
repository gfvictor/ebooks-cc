\newpage

# Capítulo VI

\vspace{-1em}

## Variáveis e Movimento

\vspace{1em}

Até aqui, o seu CSS é um monte de valores literais repetidos: o mesmo azul digitado em quarenta lugares, o mesmo `16px` de espaçamento colado à mão em cada componente. Mude a identidade visual e você vai caçar ocorrência por ocorrência, rezando para não esquecer nenhuma. E é tudo estático: o estado muda, o pixel salta de uma posição para outra num piscar, sem transição.

Este capítulo fecha o livro resolvendo as duas coisas. **Custom properties** deixam você declarar um valor uma vez e reutilizá-lo - trocar num lugar, propagar para tudo. **`transition` e `animation`** fazem a mudança acontecer ao longo do tempo, em vez de num salto seco.

### 6.1 Custom Properties

Uma _custom property_ (ou "variável CSS") é um valor que você nomeia e guarda. O nome sempre começa com dois hífens; a leitura é feita com a função `var()`:

```css
:root {
  --cor-primaria: #2563eb;
  --espaco: 1rem;
}

.botao {
  background: var(--cor-primaria);
  padding: var(--espaco);
}
```

`var()` aceita um segundo argumento como reserva, usado se a variável não estiver definida: `color: var(--cor-texto, #333)`. Custom properties **herdam** e seguem a cascata como qualquer outra propriedade - um filho enxerga as variáveis declaradas no pai. É por isso que declarar em `:root` (o `<html>`) as torna visíveis na página inteira.

### 6.2 Tokens de Design em Um Lugar

O uso que muda o seu dia a dia é centralizar as decisões visuais do projeto - cores, espaçamentos, raios de borda, tipografia - num bloco só:

```css
:root {
  --cor-fundo: #ffffff;
  --cor-texto: #1f2937;
  --cor-primaria: #2563eb;
  --raio: 8px;
  --espaco-1: 0.5rem;
  --espaco-2: 1rem;
  --espaco-3: 2rem;
}
```

A partir daí, o resto do CSS não digita mais `#2563eb` nem `8px` - digita `var(--cor-primaria)` e `var(--raio)`. Quando o cliente pedir para escurecer o azul, você troca **uma linha** e a mudança percorre o projeto inteiro.

### 6.3 O Que a Variável de Sass Não Fazia

Pré-processadores como o Sass têm variáveis há muito tempo (`$cor: blue`), mas elas são resolvidas na hora de compilar e depois deixam de existir - viram o valor literal no arquivo final. A custom property é **viva em tempo de execução**: ela pode mudar depois que a página carregou.

\newpage

```css
:root {
  --cor-fundo: #ffffff;
  --cor-texto: #1f2937;
}

@media (prefers-color-scheme: dark) {
  :root {
    --cor-fundo: #0f172a;
    --cor-texto: #e2e8f0;
  }
}
```

Todo elemento que usa `var(--cor-fundo)` e `var(--cor-texto)` troca de tema sozinho, sem uma única regra duplicada. O mesmo vale para redefinir uma variável num escopo menor (`--espaco: 0.5rem` dentro de `.compacto`) ou para o JavaScript mexer nelas em tempo real (`elemento.style.setProperty('--x', ...)`). A variável de Sass não faz nada disso.

### 6.4 `transition`

`transition` diz ao navegador para **interpolar** entre o valor antigo e o novo quando uma propriedade muda, em vez de trocar de uma vez. A forma completa é `transition: propriedade duração função-de-tempo atraso`:

```css
.botao {
  background: var(--cor-primaria);
  transition: background-color 200ms ease;
}

.botao:hover {
  background: #1e40af;
}
```

Passe o mouse e a cor desliza em 200 milissegundos; tire o mouse e ela desliza de volta. Dois detalhes importantes:

- **declare a `transition` no estado base** (`.botao`), não no `:hover`. Assim ela vale na ida e na volta;
- só propriedades **animáveis** transicionam - cor, tamanho, `opacity`, `transform`. `display` não; trocar `display: none` para `block` continua sendo instantâneo.

| Parte           | Exemplo            | O que faz                                       |
| --------------- | ------------------ | ----------------------------------------------- |
| propriedade     | `background-color` | qual propriedade animar (`all` = todas)         |
| duração         | `200ms`            | quanto tempo leva                               |
| função de tempo | `ease`             | a curva de velocidade (`linear`, `ease-in-out`) |
| atraso          | `100ms`            | espera antes de começar (opcional)              |

### 6.5 O Que É Barato Animar

Nem toda propriedade custa o mesmo para animar. `transform` (mover, escalar, rotacionar) e `opacity` são baratas: o navegador as resolve numa camada separada, sem refazer o layout. Já animar `width`, `height`, `top` ou `margin` obriga o navegador a **recalcular a posição de tudo em volta a cada quadro** - em telas fracas isso engasga visivelmente.

A regra prática: para mover um elemento, use `transform: translate(...)` em vez de mexer em `top`/`left`; para revelar ou esconder, anime `opacity`. Você chega quase sempre no mesmo efeito visual, com um custo muito menor.

### 6.6 `@keyframes` e `animation`

`transition` cobre "de um estado A para um estado B, disparado por um evento". Quando o movimento é um ciclo próprio - um _spinner_ girando, um aviso pulsando, um elemento entrando na tela sozinho - você descreve os quadros-chave com `@keyframes` e aplica com `animation`:

\newpage

```css
@keyframes girar {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  animation: girar 1s linear infinite;
}
```

Dentro de `@keyframes` você usa `from`/`to` (dois pontos) ou porcentagens (`0%`, `50%`, `100%`) para mais etapas. A propriedade `animation` reúne, além de duração e função de tempo, o número de repetições (`infinite` ou um número), a direção (`alternate` faz o movimento ir e voltar) e o `fill-mode` (se o elemento fica no estado final ao terminar).

### 6.7 Movimento com Responsabilidade

Animação existe para dar **feedback** (o botão respondeu ao clique) e **continuidade** (o painel deslizou de onde foi aberto, então você sabe de onde ele veio). Movimento que só enfeite cansa rápido e, para algumas pessoas, provoca enjoo de verdade. O sistema operacional deixa o usuário pedir menos movimento, e o CSS ouve esse pedido:

```css
@media (prefers-reduced-motion: reduce) {
  * {
    transition-duration: 0.01ms;
    animation-duration: 0.01ms;
  }
}
```

Quem não pediu nada continua vendo suas transições; quem pediu para reduzir recebe a interface sem o movimento. É uma linha de consideração que custa quase nada.

### 6.8 O Que Levar Deste Capítulo

- custom properties (`--nome` + `var()`) herdam e vivem em tempo de execução - centralize cores, espaços e raios em `:root` e troque num lugar só;
- ao contrário da variável de Sass, elas mudam com media query, escopo e JavaScript - é assim que se faz tema escuro sem duplicar regra;
- `transition` interpola uma mudança de estado; declare-a no estado base e lembre que `display` não anima;
- anime `transform` e `opacity` (baratas); evite animar `width`, `height` e posição (forçam relayout);
- `@keyframes` + `animation` para movimento cíclico ou autônomo;
- respeite `prefers-reduced-motion` - movimento é feedback e continuidade, não enfeite.

Com isto, você tem a fundação completa: a caixa, a cascata, os dois sistemas de layout, a adaptação a qualquer tela e, agora, um CSS que se mantém e se move. As Considerações Finais fecham o caminho e apontam o próximo passo.
