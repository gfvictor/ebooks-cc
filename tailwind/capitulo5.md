\newpage

# Capítulo V

\vspace{-1em}

## Tema e Tokens de Design

\vspace{1em}

No Capítulo II você abriu o capô e viu o motor: um `@theme` cheio de custom properties prontas, de onde sai cada `p-6` e cada `bg-blue-600`. Naquele momento o tema era só leitura. Você olhava, entendia de onde vinha o valor e seguia em frente.

Só que nenhum projeto de verdade usa o tema padrão do jeito que ele vem. O cliente tem uma cor de marca, uma fonte escolhida por um designer, um raio de borda que aparece em todo card. Este capítulo é sobre escrever o seu próprio `@theme`: acrescentar, mexer na escala, fechar a paleta, e decidir quando `@apply` e `@utility` ajudam e quando só atrapalham. É a mesma ideia de tokens de design do Capítulo VI do Livro I, agora com uma diferença importante: cada token que você declara vira, automaticamente, uma família inteira de classes.

### 5.1 O `@theme` É Seu Também

Tudo acontece no mesmo `globals.css` do Capítulo II, logo abaixo do `@import`:

```css
@import 'tailwindcss';

@theme {
  --color-marca-50: #f0fdfa;
  --color-marca-100: #ccfbf1;
  --color-marca-600: #0d9488;
  --color-marca-700: #0f766e;
  --color-marca-950: #042f2e;
}
```

Salve o arquivo e as classes já existem: `bg-marca-600`, `text-marca-700`, `border-marca-100`, `hover:bg-marca-700`, `dark:bg-marca-950`. Você não registrou nenhuma dessas classes em lugar nenhum. Declarou cinco custom properties, e o Tailwind leu o nome de cada uma para descobrir o que gerar.

Repare em duas coisas. A primeira é que acrescentar não apaga nada: `bg-blue-600` e toda a paleta padrão continuam funcionando ao lado da sua. O `@theme` que você escreve se soma ao que já vem com o `@import`. A segunda é que você não precisa declarar os onze tons da escala só porque a paleta padrão tem onze. Declare os tons que o design realmente usa. Se o projeto só precisa de um fundo claro, uma cor sólida, um hover e um tom escuro, são quatro linhas, não onze.

Fonte funciona do mesmo jeito. Redefinir `--font-sans`, que já existe no tema padrão, troca a fonte do projeto inteiro de uma vez, porque é ela que o Tailwind usa como fonte base do documento:

```css
@import url('https://fonts.googleapis.com/css2?family=Inter&display=swap');
@import 'tailwindcss';

@theme {
  --font-sans: 'Inter', ui-sans-serif, system-ui, sans-serif;
  --font-titulo: 'Georgia', serif;
}
```

`--font-sans` substitui o valor padrão; `--font-titulo` é novo e gera a classe `font-titulo`, para usar só nos títulos. O `@import` da fonte vem antes do `@import 'tailwindcss'` porque o CSS exige que todo `@import` fique no topo do arquivo, antes de qualquer outra regra.

> **Nota do Autor:** carregar fonte por `@import url(...)` funciona em qualquer projeto, mas não é o jeito mais rápido. Frameworks como o Next.js têm um carregador próprio de fontes, que baixa o arquivo junto com o site em vez de buscar num servidor externo. O Livro III volta a esse ponto; por enquanto, o que importa é onde o nome da fonte mora: no `@theme`.

### 5.2 O Prefixo Decide o Utilitário

Por que `--color-marca-600` virou `bg-marca-600`, e não `p-marca-600`? Porque o Tailwind lê o começo do nome da variável, o chamado _namespace_, para saber que tipo de valor é aquele e quais utilitários faz sentido gerar com ele. O pedaço depois do namespace é seu: pode ser em português, pode ser o nome da marca do cliente, pode ser o que o time combinar.

| Namespace        | Exemplo de token     | Utilitários gerados                  |
| ---------------- | -------------------- | ------------------------------------ |
| `--color-*`      | `--color-marca-600`  | `bg-marca-600`, `text-*`, `border-*` |
| `--font-*`       | `--font-titulo`      | `font-titulo`                        |
| `--text-*`       | `--text-gigante`     | `text-gigante` (tamanho de fonte)    |
| `--radius-*`     | `--radius-card`      | `rounded-card`                       |
| `--shadow-*`     | `--shadow-flutuante` | `shadow-flutuante`                   |
| `--spacing-*`    | `--spacing-topo`     | `h-topo`, `pt-topo`, `mt-topo`       |
| `--breakpoint-*` | `--breakpoint-3xl`   | o prefixo responsivo `3xl:`          |

O namespace é a única parte que não é negociável. `--cor-marca-600` é uma custom property perfeitamente válida, mas não gera classe nenhuma, porque `--cor-` não é um namespace que o Tailwind reconhece. Ela continua disponível para `var(--cor-marca-600)` em CSS comum, só não vira utilitário.

Um detalhe que costuma confundir: `text-` serve tanto para cor (`text-marca-600`) quanto para tamanho (`text-gigante`). Não há conflito, porque o Tailwind procura o nome nos dois namespaces e usa o que existir. Se você criar um tom `--color-gigante` e um tamanho `--text-gigante` ao mesmo tempo, aí sim a leitura vira ambígua, e o problema é o nome, não a ferramenta.

### 5.3 Mexendo na Escala

O Capítulo II mostrou que todo espaçamento é `--spacing` vezes o número da classe. Redefinir essa única variável muda a escala inteira:

```css
@theme {
  --spacing: 0.2rem;
}
```

Com isso, `p-4` deixa de valer `1rem` e passa a valer `0.8rem`, e o mesmo acontece com todo `m-*`, `gap-*`, `w-*` e `h-*` do projeto. Isso é poderoso justamente por ser global, e é por isso mesmo que merece cuidado.

> **Cuidado:** trocar `--spacing` no meio de um projeto altera o espaçamento de todas as telas que já existem, inclusive as que ninguém vai lembrar de revisar. É uma decisão para o primeiro dia, junto com o designer, não um ajuste fino para resolver um card que ficou apertado.

Para um valor que aparece em vários lugares mas não cabe na escala, como a altura fixa de um cabeçalho, o caminho mais seguro é acrescentar um valor nomeado em vez de mexer na base:

```css
@theme {
  --spacing-topo: 4.5rem;
  --radius-card: 0.75rem;
  --breakpoint-3xl: 120rem;
}
```

Agora `h-topo` define a altura do cabeçalho, `pt-topo` empurra o conteúdo exatamente essa distância para baixo, `rounded-card` padroniza o raio de todo card, e `3xl:` passa a existir como prefixo responsivo, valendo a partir de `120rem`, para as telas ultralargas que os cinco pontos de quebra padrão não cobrem.

Lembra do **Cuidado** do Capítulo IV sobre valores arbitrários? Era isto que ele prometia. Se você se pegar escrevendo `h-[4.5rem]` pela terceira vez, o valor não é mais exceção: é uma decisão de design que ainda não ganhou nome. Dar esse nome no `@theme` faz o valor morar num lugar só, exatamente o argumento do Capítulo VI do Livro I.

### 5.4 Fechando a Paleta

A paleta padrão do Tailwind tem centenas de cores. Num projeto com identidade visual definida, isso vira um problema silencioso: nada impede alguém do time de escrever `bg-pink-400` num botão, porque a classe existe e funciona. Seis meses depois, o projeto tem catorze tons de azul que ninguém escolheu.

O `@theme` permite remover um namespace inteiro antes de declarar o seu:

```css
@theme {
  --color-*: initial;

  --color-branco: #ffffff;
  --color-preto: #0a0a0a;
  --color-marca-100: #ccfbf1;
  --color-marca-600: #0d9488;
  --color-marca-700: #0f766e;
}
```

`--color-*: initial` apaga todas as cores padrão. Daí em diante, só existem as cinco que você declarou logo abaixo. `bg-pink-400` simplesmente para de funcionar: a classe não gera CSS nenhum, e quem a escreveu percebe na hora que aquela cor não faz parte do projeto.

Isso transforma a paleta de sugestão em regra. O design system deixa de depender da memória e da boa vontade de cada pessoa do time e passa a ser garantido pela própria ferramenta. O mesmo vale para outros namespaces: `--font-*: initial` limita as fontes, `--shadow-*: initial` limita as sombras.

> **Nota do Autor:** existe até a versão radical, `--*: initial`, que apaga o tema padrão inteiro, espaçamento incluído, e deixa você reconstruir tudo do zero. Raramente vale a pena. Fechar só as cores costuma entregar quase todo o benefício de consistência sem obrigar você a redeclarar dezenas de valores que o tema padrão já resolve bem.

### 5.5 Tokens Semânticos e o Tema Escuro Sem `dark:`

Até aqui, todo token tinha nome de cor: `marca-600`, `branco`, `preto`. Existe outro jeito de nomear, que descreve o **papel** da cor em vez da cor em si:

```css
@custom-variant dark (&:where(.dark, .dark *));

@theme {
  --color-fundo: #ffffff;
  --color-texto: #1f2937;
  --color-borda: #e5e7eb;
}

.dark {
  --color-fundo: #0f172a;
  --color-texto: #e2e8f0;
  --color-borda: #334155;
}
```

E o HTML fica assim:

```html
<div class="border border-borda bg-fundo text-texto">Conteúdo</div>
```

Não há um único `dark:` nessa linha, e mesmo assim o elemento troca de tema. O que acontece por baixo é o seguinte: `bg-fundo` não gera `background-color: #ffffff`. Gera `background-color: var(--color-fundo)`. Quando a classe `dark` aparece no `<html>`, a regra `.dark` redefine a variável, e todo elemento que a usa muda junto, sozinho.

Se isso parece familiar, é porque é o Capítulo VI do Livro I, quase linha por linha. Lá, a mesma troca de tema acontecia com `@media (prefers-color-scheme: dark)` redefinindo `--cor-fundo` e `--cor-texto` no `:root`, e a seção 6.3 insistia que isso só funciona porque a custom property é viva em tempo de execução, coisa que a variável do Sass nunca foi. O Tailwind não inventou esse truque. Ele herdou, e só acrescentou as classes por cima. Se o projeto não tiver botão de troca e seguir apenas a preferência do sistema, basta trocar o bloco `.dark` pelo mesmo `@media` do Livro I.

Compare com o Capítulo III, onde cada elemento carregava o par `bg-white` e `dark:bg-slate-900`. Aquele caminho funciona e é ótimo para projetos pequenos. Mas numa interface com duzentos elementos, são duzentos pares para manter sincronizados, e basta esquecer um para ter um card branco brilhando no meio do tema escuro. Com tokens semânticos, a decisão "qual é a cor de fundo no escuro" mora num lugar só. É o complemento natural da **Nota do Autor** do Capítulo III: o componente de troca de tema cuida apenas de pôr e tirar a classe `dark`, e os tokens cuidam de todo o resto.

Duas regras de convivência entre `@theme` e CSS comum ajudam a não se confundir:

- `@theme` é para valores que devem virar utilitário. Uma variável que só vai ser lida por `var()`, sem nunca virar classe, pode ficar num `:root` comum, como no Livro I;
- o bloco `@theme` fica sempre no nível mais externo do arquivo, nunca dentro de um seletor ou de uma media query. Por isso a redefinição do tema escuro vai num `.dark` comum, fora do `@theme`: ali você não está declarando token novo, só trocando o valor de uma variável que já existe.

> **Nota do Autor:** quando um token aponta para outra variável, e não para um valor final (por exemplo, `--font-sans: var(--font-inter)`, com `--font-inter` definida por outra ferramenta), use `@theme inline` em vez de `@theme`. Sem o `inline`, o Tailwind tenta resolver a variável no `:root`, onde ela talvez nem exista ainda. Você vai reencontrar exatamente esse caso no Livro III, com o carregador de fontes do Next.js.

### 5.6 `@apply`: Útil e Perigoso

`@apply` faz o caminho inverso de tudo o que este livro ensinou até aqui: pega utilitários e os despeja dentro de uma classe CSS tradicional.

```css
.botao {
  @apply rounded-md bg-marca-600 px-4 py-2 text-white hover:bg-marca-700;
}
```

Agora `<button class="botao">` tem o mesmo visual de toda aquela linha de utilitários. Parece a solução perfeita para a verbosidade do Capítulo I, e é justamente por isso que `@apply` é o recurso mais mal usado do Tailwind.

Pense no que acontece depois. Surge um botão maior: nasce `.botao-grande`. Um botão vermelho para excluir: `.botao-perigo`. Um botão grande e vermelho: `.botao-grande-perigo`. Em poucos meses você reconstruiu exatamente o cemitério de classes do Capítulo I, com um agravante: agora ele é escrito com utilitários, então nem o argumento "pelo menos é CSS puro" sobrou. Você voltou a nomear as coisas pelo que elas _são_, e com isso voltou a precisar de um nome novo para cada variação. De quebra, perdeu a vantagem de ler o visual direto no HTML: para saber como `.botao` se parece, é preciso abrir outro arquivo e procurar.

A resposta certa para "estou repetindo a mesma lista de classes" quase sempre é um componente, não `@apply`. Esse é o assunto inteiro do próximo capítulo.

Isso não faz de `@apply` um erro em todo caso. Ele é legítimo quando você não controla o HTML:

- conteúdo gerado por outra ferramenta, como Markdown convertido em HTML ou texto vindo de um CMS, onde não há como pôr classes em cada `<h2>` ou `<a>`;
- bibliotecas de terceiros que já vêm com classes próprias (um calendário com `.calendario-dia`, por exemplo), que você quer vestir com as cores e o espaçamento do seu tema;
- projetos sem nenhum sistema de componentes, feitos de páginas HTML soltas, onde o Capítulo I já admitia que o Tailwind fica mais difícil de usar e repetir a mesma linha em dez arquivos é uma dor real.

> **Nota do Autor:** se você usar `@apply` num arquivo CSS separado, como um CSS Module ou o bloco `<style>` de um componente Vue ou Svelte, esse arquivo não enxerga o seu `globals.css` e não sabe que `bg-marca-600` existe. Uma linha no topo dele, `@reference "../globals.css";`, resolve: o arquivo passa a conhecer o tema para consulta, sem duplicar todo o CSS gerado.

### 5.7 `@utility`: Criando o Seu Próprio Utilitário

De vez em quando, você precisa de uma propriedade CSS que o Tailwind não cobre com nenhuma classe, ou de uma combinação pequena que você quer tratar como utilitário de primeira classe. É para isso que existe `@utility`:

```css
@utility sem-scrollbar {
  scrollbar-width: none;
}
```

A diferença para uma classe CSS comum com o mesmo conteúdo é o que você ganha de graça. Uma classe `.sem-scrollbar` escrita à mão funciona, mas não aceita prefixo: `md:sem-scrollbar` ou `hover:sem-scrollbar` simplesmente não geram nada. Declarada com `@utility`, ela passa a se comportar como qualquer utilitário nativo: aceita todos os prefixos do Capítulo III, entra na mesma ordem de prioridade dos outros utilitários, e só é incluída no CSS final se aparecer em algum lugar do HTML.

`@utility` também estende utilitários que já existem. O Capítulo IV mostrou que `container`, sozinho, não centraliza nem dá respiro nas laterais, e por isso aparece quase sempre como `container mx-auto px-4`. Se no seu projeto todo `container` deve ser centralizado e ter preenchimento, diga isso uma vez:

```css
@utility container {
  margin-inline: auto;
  padding-inline: 1rem;
}
```

Daí em diante, `class="container"` sozinho já entrega os três comportamentos. Repare que isso não é o mesmo que `@apply`: você não está empacotando utilitários numa classe com nome de componente, está ajustando o comportamento de um utilitário para o projeto inteiro.

### 5.8 Qual Ferramenta, Quando

Este capítulo apresentou quatro jeitos de fugir do tema padrão, e mais um fica para o próximo. A tabela abaixo serve de guia rápido para escolher entre eles:

| Situação                                             | Ferramenta           |
| ---------------------------------------------------- | -------------------- |
| valor de design que se repete (cor, fonte, espaço)   | token no `@theme`    |
| valor pontual, que aparece uma vez só                | valor arbitrário     |
| propriedade CSS sem utilitário, ou ajuste de um      | `@utility`           |
| HTML que você não escreve (Markdown, CMS, terceiros) | `@apply`             |
| o mesmo conjunto de classes repetido no seu HTML     | componente (Cap. VI) |

A ordem das linhas não é acidental. As de cima são as que você mais vai usar; `@apply` aparece perto do fim de propósito.

### 5.9 O Que Levar Deste Capítulo

- o seu `@theme` se soma ao tema padrão; cada custom property declarada vira uma família inteira de utilitários;
- o namespace (`--color-`, `--font-`, `--radius-`, `--spacing-`, `--breakpoint-`...) decide quais classes o token gera, e o resto do nome é seu;
- `--spacing` muda a escala inteira de uma vez, uma decisão para o primeiro dia; um valor repetido fora da escala merece nome próprio, não valor arbitrário;
- `--color-*: initial` fecha a paleta e transforma o design system em regra garantida pela ferramenta;
- tokens semânticos (`fundo`, `texto`, `borda`) redefinidos num `.dark` trocam o tema sem `dark:` em cada elemento, exatamente o mecanismo do Capítulo VI do Livro I;
- `@apply` recria o cemitério de classes quando usado no seu próprio HTML; guarde-o para HTML que você não controla;
- `@utility` cria ou ajusta utilitários que aceitam todos os prefixos, como qualquer classe nativa.

O próximo capítulo responde à pergunta que o `@apply` deixou no ar: se a mesma lista de classes aparece em vinte lugares, onde ela deveria morar?
