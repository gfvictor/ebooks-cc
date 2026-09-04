\newpage

# Capítulo III

\vspace{-1em}

## Uma Dimensão de Cada Vez

\vspace{1em}

Durante quase vinte anos, "centralizar uma `div` na vertical" foi um rito de passagem doloroso do desenvolvimento web. As soluções envolviam `position: absolute`, `margin` negativo calculado na mão, `line-height` igual à altura, tabelas fingindo não ser tabelas, e uma prece. Cada uma quebrava num caso diferente.

O Flexbox acabou com isso. Ele é um sistema de layout que faz uma coisa muito bem: **distribuir espaço e alinhar itens ao longo de um único eixo**. Uma linha de botões, uma barra de navegação, um card com conteúdo em cima e ação embaixo, aquele bloco que precisa ficar no centro da tela - tudo isso é Flexbox. Quando o layout tem duas dimensões que precisam conversar entre si (linhas _e_ colunas ao mesmo tempo), aí é Grid, assunto do próximo capítulo.

### 3.1 O Container e os Itens

Flexbox é uma relação entre um pai e seus filhos diretos. Você declara `display: flex` no pai:

```css
.barra {
  display: flex;
}
```

A partir daí:

- o `.barra` vira um **flex container**;
- cada **filho direto** dele vira um **flex item** (netos não são afetados);
- os itens passam a se organizar lado a lado numa linha, cada um ocupando só o espaço do seu conteúdo, todos com a mesma altura.

Metade das propriedades de Flexbox vai no container (como os itens se distribuem no conjunto); a outra metade vai nos itens (como aquele item específico se comporta).

### 3.2 Os Dois Eixos

Todo container flex tem dois eixos perpendiculares, e **entender qual é qual é 80% do Flexbox**:

- **Eixo principal (_main axis_):** a direção em que os itens são colocados em fila;
- **Eixo cruzado (_cross axis_):** o perpendicular ao principal.

Quem define a direção do eixo principal é a propriedade `flex-direction` no container:

| `flex-direction` | Eixo principal | Itens fluem                |
| ---------------- | -------------- | -------------------------- |
| `row` (padrão)   | horizontal     | da esquerda para a direita |
| `row-reverse`    | horizontal     | da direita para a esquerda |
| `column`         | vertical       | de cima para baixo         |
| `column-reverse` | vertical       | de baixo para cima         |

Com `flex-direction: row`, o eixo principal é horizontal e o cruzado é vertical. Com `column`, os dois trocam de lugar. Toda propriedade de alinhamento a seguir age sobre um desses dois eixos - se você souber qual eixo está manipulando, nunca mais erra qual propriedade usar.

### 3.3 Alinhamento

Duas propriedades no container fazem o trabalho pesado:

**`justify-content`** distribui os itens ao longo do **eixo principal**:

| Valor           | Efeito                                                   |
| --------------- | -------------------------------------------------------- |
| `flex-start`    | agrupados no início (padrão)                             |
| `flex-end`      | agrupados no fim                                         |
| `center`        | agrupados no centro                                      |
| `space-between` | primeiro na ponta, último na ponta, resto espaçado igual |
| `space-around`  | espaço igual em volta de cada item                       |
| `space-evenly`  | espaço igual entre itens e nas bordas                    |

**`align-items`** alinha os itens ao longo do **eixo cruzado**:

| Valor        | Efeito                                            |
| ------------ | ------------------------------------------------- |
| `stretch`    | itens esticam para preencher o container (padrão) |
| `flex-start` | alinhados no começo do eixo cruzado               |
| `flex-end`   | alinhados no fim                                  |
| `center`     | centralizados no eixo cruzado                     |
| `baseline`   | alinhados pela linha de base do texto             |

O meme dos vinte anos, resolvido em três linhas:

```css
.centro {
  display: flex;
  justify-content: center;
  align-items: center;
}
```

`justify-content: center` centra no eixo principal, `align-items: center` centra no cruzado. Não importa o tamanho do filho, não importa `flex-direction` - ele fica no meio. Um item individual pode furar o alinhamento do grupo com `align-self`, que aceita os mesmos valores de `align-items` mas se aplica só a ele.

### 3.4 Quebra de Linha

Por padrão, um container flex é teimoso: ele mantém todos os itens numa única linha, encolhendo-os se preciso, mesmo que fiquem espremidos. Para permitir que quebrem em várias linhas quando não couberem:

```css
.galeria {
  display: flex;
  flex-wrap: wrap;
}
```

Com `flex-wrap: wrap`, o container passa a ter múltiplas linhas, e aí surge uma terceira propriedade: `align-content`, que distribui **as linhas** dentro do eixo cruzado (aceita os valores de `justify-content`). Atenção: `align-content` só faz efeito quando há `wrap` **e** mais de uma linha de itens - é a pegadinha clássica de "essa propriedade não está fazendo nada".

### 3.5 A Propriedade `flex`

Isto é o que dá o "flex" ao Flexbox. Vai em cada **item** e controla como ele divide o espaço com os irmãos. São três valores, quase sempre escritos juntos na _shorthand_ `flex`:

- **`flex-grow`** - fator de crescimento. Se sobrar espaço no container, quanto deste item cresce em relação aos outros. `0` = não cresce;
- **`flex-shrink`** - fator de encolhimento. Se faltar espaço, quanto este item cede em relação aos outros. `0` = não encolhe;
- **`flex-basis`** - o tamanho inicial do item no eixo principal, antes de crescer ou encolher. `auto` = o tamanho do conteúdo.

As combinações que você vai escrever de verdade:

| Shorthand    | Equivale a | Uso                                              |
| ------------ | ---------- | ------------------------------------------------ |
| `flex: 1`    | `1 1 0`    | todos os itens dividem o espaço em partes iguais |
| `flex: auto` | `1 1 auto` | cresce, mas parte do tamanho do conteúdo         |
| `flex: none` | `0 0 auto` | tamanho fixo, não cresce nem encolhe             |

Uma barra com um título à esquerda e ações à direita: dê `flex: 1` só ao título e ele empurra as ações para a ponta, sem nenhum `margin-left: auto` (embora esse truque também funcione).

### 3.6 `gap`

Durante anos, o espaço entre itens flex era feito com `margin` em todos menos no último, ou com `:not(:last-child)`, ou com um `margin` negativo no pai para compensar. Esqueça tudo isso:

```css
.barra {
  display: flex;
  gap: 16px;
}
```

`gap` cria espaço **apenas entre** os itens, nunca nas bordas externas do container. Funciona igual em Flexbox e em Grid, aceita um valor (linhas e colunas iguais) ou dois (`gap: 12px 24px` = 12 na vertical, 24 na horizontal). É a forma correta e atual de espaçar itens - não use `margin` para isso.

### 3.7 O Que Levar Deste Capítulo

- `display: flex` no pai; os filhos diretos viram itens ao longo de um eixo;
- `flex-direction` define o eixo principal; o cruzado é o perpendicular;
- `justify-content` alinha no eixo principal, `align-items` no cruzado, `align-self` foge do padrão num item;
- `flex-wrap: wrap` libera múltiplas linhas; `align-content` só vale com wrap e mais de uma linha;
- `flex: 1` divide espaço igualmente; `flex: none` trava o tamanho;
- `gap` é o jeito certo de espaçar - `margin` entre itens é gambiarra herdada.

Flexbox resolve uma dimensão por vez. Quando você precisar alinhar linhas e colunas ao mesmo tempo - uma grade de verdade - o capítulo seguinte apresenta o CSS Grid.
