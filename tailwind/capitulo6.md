\newpage

# Capítulo VI

\vspace{-1em}

## Componentização

\vspace{1em}

O Capítulo I fez uma promessa: o HTML verboso do Tailwind é pago uma vez por componente, não uma vez por página. O Capítulo V reforçou a promessa pelo caminho contrário, mostrando que `@apply` no seu próprio HTML recria o cemitério de classes. Faltava cumprir. Este capítulo mostra onde a lista de classes repetida deveria morar, como lidar com variações sem voltar a inventar `.botao-grande-perigo`, e as armadilhas que aparecem quando classes começam a ser montadas por código em vez de digitadas à mão.

Os exemplos usam React, porque é o que o Livro III vai usar, mas a ideia vale igual para Vue, Svelte ou qualquer ferramenta que permita criar componentes. Um detalhe de sintaxe antes de começar: no JSX do React, o atributo `class` se escreve `className`. O conteúdo é exatamente o mesmo.

### 6.1 Repetição de Verdade e Repetição Aparente

Antes de extrair qualquer coisa, vale separar dois tipos de repetição, porque só um deles é problema.

```jsx
<ul>
  {produtos.map((produto) => (
    <li key={produto.id} className="rounded-lg border p-4">
      {produto.nome}
    </li>
  ))}
</ul>
```

Na tela aparecem trinta cards idênticos, mas no código a lista de classes foi escrita uma vez só. O laço já resolveu a repetição. Extrair um componente aqui não economiza nada; só acrescenta um arquivo.

O mesmo vale para três ou quatro elementos parecidos lado a lado, no mesmo arquivo, que você edita sempre juntos. Um editor com seleção múltipla altera os quatro de uma vez, e ninguém vai esquecer de um deles, porque estão todos na mesma tela.

Repetição de verdade é outra coisa: a mesma lista de classes espalhada por arquivos diferentes, onde mudar o visual obriga você a lembrar de todos os lugares. É exatamente o problema do Capítulo I, só que agora com utilitários no lugar de classes nomeadas. Esse é o sinal para extrair.

### 6.2 Extraindo um Componente

O botão do Capítulo I, que assustava pela quantidade de classes, vira um componente:

```jsx
function Botao({ children, ...props }) {
  return (
    <button
      className="inline-flex items-center gap-2 rounded-md bg-marca-600
        px-4 py-2 text-sm font-medium text-white hover:bg-marca-700"
      {...props}
    >
      {children}
    </button>
  )
}
```

E o resto do projeto usa assim:

```jsx
<Botao onClick={salvar}>Salvar</Botao>
```

A verbosidade não sumiu. Ela foi para um lugar só, com nome, e todo o resto do projeto chama esse lugar pelo nome. Parece o mesmo que `.botao` com `@apply`, mas há uma diferença fundamental: o componente não empacota só o visual. Ele empacota o visual, a estrutura HTML e o comportamento. Se amanhã todo botão precisar de um ícone de carregamento, você muda um arquivo. Com `@apply`, você mudaria o CSS num arquivo e o HTML em todos os outros.

O `...props` repassa para o `<button>` tudo o que não foi tratado explicitamente, como `onClick`, `type` e `disabled`. Isso mantém o componente fino: ele cuida da aparência e deixa o resto funcionar como um `<button>` comum.

### 6.3 Variações sem Classes Novas: `clsx`

Um botão raramente tem um visual só. Existe o principal, o de excluir, o desabilitado. Montar isso concatenando strings à mão fica ilegível rápido, então a comunidade praticamente padronizou uma biblioteca minúscula para a tarefa, a `clsx`:

```jsx
import clsx from 'clsx'

function Botao({ perigo, children, ...props }) {
  return (
    <button
      className={clsx('rounded-md px-4 py-2 text-white', {
        'bg-red-600 hover:bg-red-700': perigo,
        'bg-marca-600 hover:bg-marca-700': !perigo,
      })}
      {...props}
    >
      {children}
    </button>
  )
}
```

`clsx` recebe qualquer mistura de strings, condições e objetos, descarta o que for falso e devolve uma string só, com as classes separadas por espaço. No objeto, cada chave é um conjunto de classes e cada valor é a condição que decide se ele entra. O uso vira `<Botao perigo>Excluir</Botao>`. Nenhuma classe nova foi inventada, nenhum arquivo CSS cresceu: a variação é só uma escolha entre dois conjuntos de utilitários que já existem.

### 6.4 Nunca Monte uma Classe em Pedaços

Com classes montadas por código, surge a tentação de ser esperto:

```jsx
<div className={`bg-${cor}-600`}>Aviso</div>
```

Parece elegante, e não funciona. O Capítulo I explicou que o Tailwind gera CSS só para os utilitários que encontra no seu código. O que ele faz, na prática, é ler os seus arquivos como texto puro, procurando nomes de classe completos. Ele não executa o seu JavaScript. A string `bg-red-600` nunca aparece inteira em lugar nenhum desse arquivo, então a regra correspondente nunca é gerada, e o elemento fica sem fundo.

O pior é que às vezes funciona por acaso: se `bg-red-600` aparece escrito inteiro em algum outro arquivo do projeto, a regra existe e o aviso fica vermelho. Até o dia em que alguém apaga aquele outro uso, e o aviso perde a cor sem que ninguém tenha tocado nele.

A saída é sempre escrever o nome completo, e escolher entre nomes completos:

```jsx
const cores = {
  erro: 'bg-red-600',
  sucesso: 'bg-green-600',
  alerta: 'bg-amber-500',
}

function Aviso({ tipo, children }) {
  return <div className={cores[tipo]}>{children}</div>
}
```

Agora cada classe aparece inteira no arquivo, o Tailwind encontra todas, e o código ainda ficou mais legível: quem lê vê exatamente quais cores são possíveis.

> **Cuidado:** a regra vale para qualquer pedaço de classe, não só para cores. `p-${tamanho}`, `md:${classe}`, `grid-cols-${n}`: se o nome final não aparece escrito por inteiro em algum arquivo, o CSS dele não existe.

### 6.5 O Conflito de Classes

Componentes costumam aceitar um `className` extra, para quem usa ajustar um detalhe sem criar variação nova:

```jsx
<Botao className="px-8">Continuar</Botao>
```

Dentro do componente, esse `className` é somado às classes padrão, e o `<button>` acaba com `px-4` e `px-8` ao mesmo tempo. Qual vence?

A intuição diz que vence o último escrito no atributo. A intuição está errada, e o motivo é o Capítulo II do Livro I. As duas classes têm a mesma especificidade, então o desempate é a ordem em que as regras aparecem **na folha de estilo**, não a ordem em que os nomes aparecem no atributo `class`. E quem decide a ordem na folha é o Tailwind, não você. Dependendo de como ele organizou as regras, `px-8` funciona, ou é ignorado sem nenhum aviso.

A biblioteca `tailwind-merge` resolve isso entendendo o que cada utilitário faz: quando duas classes mexem na mesma propriedade, ela mantém só a última. Combinada com a `clsx`, vira uma função pequena que aparece em quase todo projeto React com Tailwind, quase sempre com o nome `cn`:

```jsx
import clsx from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...entradas) {
  return twMerge(clsx(...entradas))
}
```

```jsx
<button className={cn('rounded-md px-4 py-2', className)} />
```

Agora `cn('px-4', 'px-8')` devolve só `px-8`, e quem usa o componente tem a garantia de que o ajuste passado de fora sempre vence o padrão de dentro.

> **Nota do Autor:** o `tailwind-merge` reconhece os namespaces padrão e a maioria dos tokens do seu `@theme` sem configuração nenhuma. Tokens com nomes ambíguos, como o `text-gigante` do Capítulo V (tamanho ou cor?), podem precisar ser ensinados a ele por configuração. Se um ajuste por `className` sumir sem explicação, esse é o primeiro lugar para olhar.

### 6.6 Variantes Declaradas: `cva`

`clsx` com um `perigo ? ... : ...` funciona para uma variação. Quando o botão tem três estilos e três tamanhos, os ternários se multiplicam e o componente volta a ficar ilegível. A biblioteca `cva` (_class variance authority_) organiza isso numa tabela declarada:

```jsx
import { cva } from 'class-variance-authority'

const botao = cva('inline-flex items-center rounded-md font-medium', {
  variants: {
    variante: {
      primario: 'bg-marca-600 text-white hover:bg-marca-700',
      perigo: 'bg-red-600 text-white hover:bg-red-700',
      fantasma: 'bg-transparent text-texto hover:bg-marca-50',
    },
    tamanho: {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2 text-sm',
      lg: 'px-6 py-3 text-base',
    },
  },
  defaultVariants: {
    variante: 'primario',
    tamanho: 'md',
  },
})
```

O primeiro argumento são as classes que todo botão tem. Em `variants`, cada chave é uma dimensão de variação, e cada opção dentro dela é uma lista de classes completas, o que de quebra respeita a regra da seção 6.4. `defaultVariants` diz o que usar quando nada for informado. O componente fica curto:

```jsx
function Botao({ variante, tamanho, className, ...props }) {
  const classes = cn(botao({ variante, tamanho }), className)

  return <button className={classes} {...props} />
}
```

E o uso fica autoexplicativo:

```jsx
<Botao>Salvar</Botao>
<Botao variante="perigo" tamanho="sm">Excluir</Botao>
<Botao variante="fantasma" className="w-full">Cancelar</Botao>
```

Compare com o `.botao-grande-perigo` do Capítulo V. As mesmas combinações existem, mas nenhuma delas tem nome próprio nem regra CSS própria. Três variantes e três tamanhos dão nove botões possíveis, descritos em seis linhas de opções, e acrescentar um quarto tamanho é uma linha a mais, não três classes novas.

> **Nota do Autor:** repare que a variante `fantasma` usa `text-texto`, o token semântico do Capítulo V. Componentes e tokens se completam: o componente decide quais variações existem, os tokens decidem o que cada cor significa, e o tema escuro continua funcionando sem um único `dark:` dentro do botão.

### 6.7 Onde a Lista de Classes Deveria Morar

A pergunta que fechou o Capítulo V tem, agora, uma resposta completa:

| Situação                                       | Onde mora                             |
| ---------------------------------------------- | ------------------------------------- |
| repetição dentro de um laço                    | no próprio laço, escrita uma vez      |
| elementos parecidos no mesmo arquivo           | no próprio arquivo                    |
| o mesmo padrão em arquivos diferentes          | num componente                        |
| o componente com uma variação                  | `clsx` com uma condição               |
| o componente com várias dimensões de variação  | `cva`                                 |
| ajuste pontual feito por quem usa o componente | `className` extra, resolvido com `cn` |
| HTML que você não escreve                      | `@apply` (Capítulo V)                 |

Na prática, projetos maduros acabam com uma pasta de componentes de interface (botão, campo, card, modal, etiqueta) que concentra quase todas as listas longas de classes. O resto do código monta telas combinando esses componentes, e as classes que sobram nas telas são as de layout: `flex`, `grid`, `gap-*`, o assunto do Capítulo IV. É assim que um projeto Tailwind grande continua legível.

### 6.8 O Que Levar Deste Capítulo

- repetição dentro de um laço ou no mesmo arquivo não pede extração; a mesma lista espalhada por arquivos diferentes, sim;
- componente empacota visual, estrutura e comportamento juntos, por isso é a resposta certa onde `@apply` só empacotaria o visual;
- `clsx` escolhe entre conjuntos de classes por condição, sem inventar classe nova;
- nunca monte o nome de uma classe em pedaços: o Tailwind lê o código como texto e só gera o que aparece escrito por inteiro;
- duas classes que mexem na mesma propriedade são desempatadas pela ordem na folha de estilo, não no atributo; `tailwind-merge`, via `cn`, garante que o ajuste de fora vença;
- `cva` declara as dimensões de variação num lugar só, e combina bem com os tokens semânticos do Capítulo V.

Com isso, o ciclo do livro se fecha: o Capítulo I prometeu que a verbosidade seria paga uma vez só, e este capítulo mostrou onde essa conta é paga.
