\newpage

# Capítulo IV

\vspace{-1em}

## Duas Dimensões ao Mesmo Tempo

\vspace{1em}

O capítulo anterior resolveu fileiras: uma barra de botões, uma lista de tags, um card com título e ação. Mas existe uma categoria de layout que o Flexbox se recusa a resolver direito - o layout de página inteira, com cabeçalho, barra lateral, conteúdo e rodapé; ou uma galeria onde as colunas de uma linha precisam ter exatamente a mesma largura das colunas da linha de baixo. Você até consegue forçar o Flexbox a fingir que faz isso, com `flex-basis` calculado a dedo e `flex-wrap`, mas é sempre uma aproximação - linhas e colunas nunca conversam de verdade entre si.

O CSS Grid existe exatamente para esse problema: ele pensa em **linhas e colunas simultaneamente**, como uma planilha. Se Flexbox é uma dimensão de cada vez, Grid é as duas ao mesmo tempo - e por isso os dois não competem, eles se complementam.

### 4.1 O Container e as Trilhas

Declare `display: grid` no pai e defina as colunas com `grid-template-columns`:

```css
.pagina {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-rows: 80px 1fr 60px;
  gap: 16px;
}
```

Cada valor em `grid-template-columns` cria uma **trilha** (_track_) de coluna; o mesmo vale para `grid-template-rows` e linhas. O exemplo acima cria duas colunas (uma barra lateral fixa de 200px e uma área principal que ocupa o resto) e três linhas (cabeçalho, conteúdo, rodapé). O `gap` que você já conhece do Flexbox funciona aqui do mesmo jeito, criando espaço entre as trilhas.

### 4.2 A Unidade `fr` e o `repeat()`

`fr` significa **fração do espaço livre** - depois de reservado tudo que tem tamanho fixo (`px`, `%`, conteúdo), o que sobra é dividido entre as trilhas em `fr` na proporção declarada:

```css
.galeria {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}
```

`repeat(4, 1fr)` é atalho para `1fr 1fr 1fr 1fr` - quatro colunas de largura igual, dividindo o espaço disponível entre si. Misturar unidades também funciona: `grid-template-columns: 250px repeat(3, 1fr)` cria uma coluna fixa seguida de três colunas iguais no espaço restante.

### 4.3 Grids Responsivos Sem Media Query

Esta é a combinação que resolve sozinha um problema que costumava exigir uma media query para cada breakpoint - uma galeria que se reorganiza conforme o espaço disponível, sem você declarar um único `@media`:

```css
.galeria {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
}
```

Decompondo:

- **`minmax(220px, 1fr)`** - cada coluna tem no mínimo 220px e no máximo 1 fração do espaço livre. Nunca fica menor que o mínimo, nunca menor que isso;
- **`auto-fit`** - em vez de um número fixo de colunas, o navegador calcula quantas colunas de pelo menos 220px cabem na largura disponível, e as expande para preencher o espaço restante.

A diferença entre `auto-fit` e `auto-fill` só aparece quando há poucos itens: `auto-fit` estica os itens existentes para preencher as colunas vazias; `auto-fill` mantém colunas vazias e do mesmo tamanho, sem esticar os itens. Para galerias e grids de card, `auto-fit` é quase sempre o que você quer.

> **Nota do Autor:** esse trio - `repeat`, `auto-fit`, `minmax` - substitui sozinho um bloco inteiro de media queries manuais que você escreveria pra cada largura de tela. Decore essa linha; ela aparece em praticamente todo layout de grid de card do mundo real.

### 4.4 Posicionando Itens nas Linhas

Por padrão, os itens de um grid preenchem as trilhas na ordem em que aparecem no HTML. Para posicionar um item manualmente, você conta **linhas de grade** (as linhas entre as trilhas, não as trilhas em si) com `grid-column` e `grid-row`:

```css
.destaque {
  grid-column: 1 / 3;
  grid-row: 2 / 4;
}
```

`1 / 3` significa "comece na linha 1, termine na linha 3" - ou seja, ocupe as duas primeiras colunas. A palavra-chave `span` conta trilhas em vez de linhas, o que costuma ser mais fácil de ler: `grid-column: span 2` ocupa duas colunas a partir de onde o item cairia naturalmente. A linha `-1` sempre aponta para a última linha de grade do container, útil para "vá até o fim" sem contar quantas trilhas existem.

### 4.5 Nomeando o Layout com `grid-template-areas`

Para um layout de página inteira, contar linhas fica ilegível rápido. `grid-template-areas` deixa você desenhar o layout como um mapa, com nomes:

```css
.pagina {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-rows: 80px 1fr 60px;
  grid-template-areas:
    'cabecalho cabecalho'
    'lateral   conteudo'
    'rodape    rodape';
}

.cabecalho {
  grid-area: cabecalho;
}
.lateral {
  grid-area: lateral;
}
.conteudo {
  grid-area: conteudo;
}
.rodape {
  grid-area: rodape;
}
```

Cada string em `grid-template-areas` é uma linha do grid; repetir um nome numa célula faz aquela área ocupar as duas colunas ou linhas, como o `cabecalho` e o `rodape` acima. O visual do CSS literalmente desenha o layout - você olha para a folha de estilo e vê a página, sem precisar simular linhas e colunas na cabeça.

### 4.6 Grid ou Flexbox?

A pergunta errada é "qual dos dois é melhor". A pergunta certa é **quantas dimensões esse layout específico tem**:

| Situação                                                     | Use            |
| ------------------------------------------------------------ | -------------- |
| Uma fileira ou coluna de itens (menu, barra de ações, tags)  | Flexbox        |
| Itens de tamanho variável que só precisam alinhar numa linha | Flexbox        |
| Layout de página inteira (cabeçalho/lateral/conteúdo/rodapé) | Grid           |
| Galeria onde linhas e colunas precisam alinhar entre si      | Grid           |
| Espaçar itens dentro de um componente já flexível            | `gap` nos dois |

Na prática, um projeto real usa os dois o tempo todo: Grid para a estrutura macro da página, Flexbox para organizar o conteúdo dentro de cada célula dessa estrutura.

### 4.7 O Que Levar Deste Capítulo

- Grid controla linhas e colunas ao mesmo tempo; Flexbox controla um eixo por vez;
- `fr` divide o espaço livre; `repeat()` evita repetir valores de trilha;
- `repeat(auto-fit, minmax(min, 1fr))` cria grids responsivos sem media query;
- `grid-column`/`grid-row` posicionam por linha de grade; `span` conta trilhas, mais legível que contar linhas;
- `grid-template-areas` nomeia o layout e deixa a folha de estilo parecer com a página real;
- a escolha entre Grid e Flexbox é sobre quantas dimensões o layout tem, não sobre qual é "melhor".

Colunas fixas em pixels resolvem hoje e quebram amanhã, no primeiro celular que abrir a página. O próximo capítulo ataca isso de frente: unidades responsivas e a mentalidade _mobile-first_.
