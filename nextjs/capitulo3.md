\newpage

# Capítulo III

\vspace{-1em}

## Servidor e Navegador

\vspace{1em}

O Capítulo II terminou com uma linha misteriosa no topo do `error.js`: `'use client'`. Ela parece um detalhe de sintaxe, mas carrega a decisão mais importante do App Router. Cada componente do seu projeto roda em um de dois lugares, o servidor ou o navegador, e o que ele pode fazer depende inteiramente de onde está.

Este capítulo explica os dois tipos de componente, o que cada um pode e não pode, e onde traçar a fronteira entre eles. É também aqui que o botão de troca de tema, prometido desde o Capítulo III do Livro II, finalmente ganha vida.

### 3.1 Dois Lugares Para Rodar

Todo componente dentro de `app/` é, por padrão, um **Server Component**: ele roda no servidor, produz HTML, e o código dele nunca é enviado ao navegador. Para um componente rodar também no navegador, com cliques e estado, ele precisa ser marcado como **Client Component**, com a linha `'use client'` no topo do arquivo.

A Metodologia deste livro sugeriu deixar o terminal do servidor à vista, e é agora que isso rende. Faça este teste:

```jsx
export default function Home() {
  console.log('Onde estou rodando?')

  return <h1 className="p-6 text-2xl">Olá</h1>
}
```

Abra a página e procure a mensagem. Ela não aparece no console do navegador. Aparece no terminal onde o `npm run dev` está rodando, porque é lá que esse componente executa. O navegador só recebeu o HTML que ele produziu, sem uma linha do código que o produziu.

Esse é o modelo mental do capítulo inteiro: um Server Component é como a cozinha do restaurante do Capítulo I. O cliente recebe o prato pronto, mas nunca entra na cozinha, nunca vê a receita, e nunca carrega as panelas para casa.

### 3.2 O Que o Servidor Pode

Rodar no servidor não é uma limitação; é um privilégio. Um Server Component tem acesso a coisas que o navegador jamais teria:

```jsx
import { readFile } from 'node:fs/promises'

export default async function AvisosPage() {
  const texto = await readFile('avisos.txt', 'utf8')

  return <p className="p-6">{texto}</p>
}
```

Esse componente lê um arquivo direto do disco do servidor, algo impossível no navegador, que não tem acesso ao sistema de arquivos de ninguém. E repare na palavra `async`: Server Components podem ser funções assíncronas, que esperam por dados antes de devolver o HTML. É isso que o Capítulo IV vai usar para buscar dados de uma API ou de um banco, direto dentro do componente.

As vantagens se resumem em três:

- **acesso direto a recursos do servidor:** arquivos, banco de dados, chaves secretas de API, sem precisar criar uma rota intermediária só para buscar dados;
- **zero JavaScript enviado:** o código do componente fica no servidor. Uma página que só exibe conteúdo não precisa mandar nenhum código dela para o celular de quem acessa;
- **dependências pesadas ficam em casa:** uma biblioteca de dois megabytes usada para formatar um texto roda no servidor, e o navegador recebe só o texto formatado.

### 3.3 O Que o Servidor Não Pode

O preço do privilégio é que um Server Component roda uma vez, produz HTML e acaba. Ele não fica "vivo" na página depois disso. Por isso, não pode usar nada que dependa de estar no navegador:

| Recurso                                | Por que não funciona no servidor         |
| -------------------------------------- | ---------------------------------------- |
| `onClick`, `onChange` e outros eventos | não há usuário clicando no servidor      |
| `useState`, `useEffect` e outros hooks | não há estado vivo depois que o HTML sai |
| `window`, `document`, `localStorage`   | esses objetos só existem no navegador    |

Se você tentar usar `useState` num componente sem `'use client'`, o Next.js recusa o código com um erro explicando que aquele hook só funciona num Client Component. A mensagem costuma ser bem clara, e a solução quase sempre é a mesma: mover o pedaço interativo para um componente próprio, marcado com `'use client'`.

### 3.4 `'use client'`

Um componente que conta cliques é o exemplo mais simples de algo que só o navegador consegue fazer:

```jsx
'use client'

import { useState } from 'react'

export default function Contador() {
  const [total, setTotal] = useState(0)

  return (
    <button
      className="rounded-md bg-slate-900 px-4 py-2 text-white"
      onClick={() => setTotal(total + 1)}
    >
      Cliques: {total}
    </button>
  )
}
```

`useState` é a forma do React guardar um valor que muda com o tempo. Ele devolve duas coisas: o valor atual (`total`, que começa em `0`) e uma função para trocá-lo (`setTotal`). Cada vez que `setTotal` é chamada, o React desenha o componente de novo com o valor atualizado. É o mínimo de React que este livro precisa, e é exatamente o tipo de coisa que exige o navegador: um valor que vive enquanto a página está aberta, reagindo a cliques.

A linha `'use client'` precisa ser a primeira do arquivo, antes de qualquer `import`. Ela não marca só aquele componente: marca o arquivo como **ponto de entrada do navegador**. Tudo o que esse arquivo importa passa a fazer parte do JavaScript enviado ao navegador também.

> **Nota do Autor:** repare no nome: é `'use client'` que existe, e não `'use server'` para marcar Server Components. Server é o padrão, e não precisa de marcação. Existe sim uma diretiva `'use server'`, mas ela serve para outra coisa, as Server Actions do Capítulo V. Confundir as duas é um dos erros mais comuns de quem está começando.

### 3.5 Client Não Significa "Só no Navegador"

Aqui mora o mal-entendido mais comum sobre o assunto. O nome "Client Component" sugere que ele roda apenas no navegador, e isso não é verdade.

Um Client Component também passa pelo servidor. Na primeira visita, o Next.js executa o `Contador` no servidor para produzir o HTML inicial, com o botão e o texto "Cliques: 0". Esse HTML chega pronto, e o usuário vê o botão antes de qualquer JavaScript. Depois, o código do componente chega ao navegador e faz a hidratação do Capítulo I: prende o `onClick` no botão que já estava na tela.

Faça o teste do `console.log` num Client Component e você vai ver a mensagem nos **dois** lugares: no terminal, da renderização inicial, e no console do navegador, da hidratação em diante.

A diferença real entre os dois tipos, então, não é "servidor contra navegador". É esta:

| Server Component                    | Client Component                             |
| ----------------------------------- | -------------------------------------------- |
| roda só no servidor                 | roda no servidor e depois no navegador       |
| o código nunca vai para o navegador | o código vai para o navegador, para hidratar |
| não reage a nada depois de pronto   | reage a cliques, digitação, tempo            |
| pode ser `async` e acessar recursos | não pode ser `async` nem acessar o servidor  |

### 3.6 A Fronteira: Empurre Para as Pontas

Imagine a página de um produto: nome, foto, descrição longa, avaliações de clientes, e um botão "Adicionar ao carrinho". Só o botão é interativo. Tudo o resto é conteúdo que não muda depois de exibido.

O erro clássico é colocar `'use client'` no topo da página inteira, porque "ela tem um botão". Funciona, mas agora o código da página toda, com descrição, avaliações e o que mais ela importar, vai para o navegador, e a página perde o acesso direto aos dados do servidor. O jeito certo é isolar só a parte interativa:

```jsx
'use client'

import { useState } from 'react'

export default function BotaoComprar() {
  const [adicionado, setAdicionado] = useState(false)

  return (
    <button onClick={() => setAdicionado(true)}>
      {adicionado ? 'No carrinho' : 'Adicionar ao carrinho'}
    </button>
  )
}
```

\newpage

```jsx
import BotaoComprar from './botao-comprar'

export default function ProdutoPage() {
  return (
    <article className="p-6">
      <h1 className="text-2xl font-bold">Teclado mecânico</h1>
      <p>Uma descrição longa, que não precisa de JavaScript.</p>
      <BotaoComprar />
    </article>
  )
}
```

A página continua sendo um Server Component, e só o `BotaoComprar` cruza para o navegador. A regra geral é empurrar o `'use client'` para as pontas da árvore de componentes: os botões, os campos, os menus que abrem e fecham. Quanto mais perto das folhas a fronteira estiver, menos código vai para o navegador, e mais do seu projeto continua com os privilégios do servidor.

### 3.7 O Que Atravessa a Fronteira

Um Server Component pode renderizar um Client Component e passar propriedades para ele, como qualquer componente faz:

```jsx
<BotaoComprar produtoId={42} nome="Teclado mecânico" />
```

Mas essas propriedades precisam atravessar uma fronteira de verdade: saem do servidor, viajam pela rede e chegam ao navegador. Por isso, só podem ser dados simples, que dão para escrever e reler do outro lado: textos, números, booleanos, listas e objetos feitos desses mesmos tipos.

O que não atravessa são funções. Um `onClick={() => ...}` criado num Server Component não tem como viajar até o navegador, porque uma função não é um dado, é código que roda num lugar específico. Se o Server Component precisa que o Client Component "faça algo" no servidor, o caminho é uma Server Action, a exceção a essa regra, assunto do Capítulo V.

### 3.8 Servidor Dentro do Cliente: `children`

A seção 3.4 disse que tudo o que um arquivo `'use client'` importa vira código de navegador também. Então um Client Component nunca pode ter conteúdo de servidor dentro dele? Pode, desde que esse conteúdo chegue pronto, de fora, e não importado.

Pense numa caixa que abre e fecha, uma "sanfona". O abrir e fechar é interativo, então é Client Component. Mas o conteúdo dentro dela pode ser uma lista pesada, vinda do banco:

```jsx
'use client'

import { useState } from 'react'

export default function Sanfona({ titulo, children }) {
  const [aberta, setAberta] = useState(false)

  function alternar() {
    setAberta(!aberta)
  }

  return (
    <section className="rounded-lg border">
      <button className="w-full p-4 text-left" onClick={alternar}>
        {titulo}
      </button>
      {aberta && <div className="p-4">{children}</div>}
    </section>
  )
}
```

```jsx
import Sanfona from './sanfona'
import Avaliacoes from './avaliacoes'

export default function ProdutoPage() {
  return (
    <Sanfona titulo="Avaliações">
      <Avaliacoes />
    </Sanfona>
  )
}
```

`Avaliacoes` é um Server Component, importado pela página, que também é servidor. Ele roda no servidor e chega à `Sanfona` já transformado em resultado pronto, através do `children`. A `Sanfona` não sabe nem se importa com o que tem dentro; ela só decide se mostra ou esconde. É como a caixa de um presente: quem embrulha não precisa saber montar o que está dentro.

Esse padrão resolve a maior parte dos casos em que parece que "a página inteira precisa ser cliente". Quase sempre, só a moldura interativa precisa, e o conteúdo pode entrar pelo `children`.

### 3.9 O Botão de Tema, Finalmente

O Capítulo III do Livro II ensinou o `@custom-variant` que faz o prefixo `dark:` depender de uma classe `dark` no `<html>`, e comentou numa **Nota do Autor** que é comum existir um componente próprio só para o botão de troca de tema. O Capítulo V do mesmo livro mostrou os tokens semânticos que trocam de cor sozinhos quando essa classe aparece. Faltava só quem pusesse e tirasse a classe. Agora você sabe exatamente que tipo de componente é esse:

```jsx
'use client'

import { useState } from 'react'

export default function BotaoTema() {
  const [escuro, setEscuro] = useState(false)

  function alternar() {
    document.documentElement.classList.toggle('dark')
    setEscuro(!escuro)
  }

  const rotulo = escuro ? 'Tema claro' : 'Tema escuro'

  return <button onClick={alternar}>{rotulo}</button>
}
```

É um Client Component por dois motivos que você já sabe reconhecer: reage a um clique e usa `document`, que só existe no navegador. `document.documentElement` é o próprio `<html>`, e `classList.toggle('dark')` põe a classe se ela não estiver lá, ou tira se estiver. Todo o resto, os `bg-fundo`, os `text-texto`, os `dark:`, reage sozinho, como os dois capítulos do Livro II prometeram.

O botão pode morar no layout raiz, ao lado do `children`, e o layout continua sendo um Server Component: só o botão cruza a fronteira.

> **Nota do Autor:** esta versão é propositalmente mínima, e esquece a escolha quando a página recarrega. Um botão de tema de verdade guarda a preferência no navegador e a aplica antes da primeira pintura da tela, para não piscar o tema errado por um instante. Não vale a pena escrever isso à mão: a biblioteca `next-themes` resolve o problema inteiro e é o que a maioria dos projetos usa. O ponto aqui é entender o que ela faz por baixo.

### 3.10 Segredos Ficam no Servidor

Como o código de um Server Component nunca vai para o navegador, ele é o lugar natural para chaves de API, senhas de banco e qualquer outro segredo. O risco aparece quando um arquivo com segredo é importado, sem querer, por um arquivo `'use client'`: aí ele entra no JavaScript do navegador, visível para qualquer um que abrir as ferramentas de desenvolvedor.

Para impedir esse acidente, existe um pacote minúsculo chamado `server-only`. Instale com `npm install server-only` e ponha uma linha no topo de qualquer arquivo que só deve rodar no servidor:

```jsx
import 'server-only'

export async function buscarPedidos() {
  const resposta = await fetch('https://api.exemplo.com/pedidos', {
    headers: { Authorization: `Bearer ${process.env.API_SECRETA}` },
  })

  return resposta.json()
}
```

Se algum Client Component importar esse arquivo, direta ou indiretamente, o build falha com um erro, em vez de publicar o segredo. É uma trava barata para um erro caro. O Capítulo VI volta às variáveis de ambiente como `process.env.API_SECRETA`, e mostra a regra do Next.js que decide quais delas o navegador pode ou não enxergar.

\newpage

### 3.11 A Vitrine Até Aqui

A Vitrine ganha três coisas neste capítulo: o botão de comprar, o botão de tema e a trava de segurança nos dados. A estrutura cresce assim:

```bash
vitrine/
  app/
    globals.css
    layout.js
    not-found.js
    (site)/
      layout.js
      page.js
      produtos/
        page.js
        [id]/
          page.js
    (app)/
      painel/
        layout.js
        page.js
  components/
    botao-comprar.js
    botao-tema.js
  lib/
    produtos.js
```

Os dois botões são os das seções 3.6 e 3.9, sem nenhuma mudança, cada um no seu arquivo dentro de `components/`. É a pasta na raiz que a **Nota do Autor** da seção 2.1 sugeriu: fora de `app/`, sem chance de virar rota.

Para o botão de tema fazer efeito, o `globals.css` precisa do que o Livro II ensinou: a estratégia de tema por classe do Capítulo III e os tokens semânticos do Capítulo V.

```css
@import 'tailwindcss';

@custom-variant dark (&:where(.dark, .dark *));

@theme {
  --color-fundo: #ffffff;
  --color-texto: #1f2937;
}

.dark {
  --color-fundo: #0f172a;
  --color-texto: #e2e8f0;
}
```

E o layout raiz passa a usar esses tokens no `<body>`, para o site inteiro trocar de cor junto:

```jsx
import './globals.css'

export const metadata = {
  title: 'Vitrine',
}

export default function RootLayout({ children }) {
  return (
    <html lang="pt-BR">
      <body className="bg-fundo text-texto">{children}</body>
    </html>
  )
}
```

\newpage

O cabeçalho de `(site)/layout.js` ganha o botão de tema, empurrado para a direita com `ml-auto`:

```jsx
import Link from 'next/link'
import BotaoTema from '@/components/botao-tema'

export default function SiteLayout({ children }) {
  return (
    <>
      <header className="flex items-center gap-4 border-b p-4">
        <Link href="/" className="font-bold">
          Vitrine
        </Link>
        <Link href="/produtos">Produtos</Link>
        <div className="ml-auto">
          <BotaoTema />
        </div>
      </header>
      <main className="p-6">{children}</main>
    </>
  )
}
```

O layout continua sendo um Server Component; só o `BotaoTema` cruza para o navegador. Na página do produto, `(site)/produtos/[id]/page.js`, o `BotaoComprar` entra logo depois da descrição, com `import BotaoComprar from '@/components/botao-comprar'` no topo. A página inteira segue no servidor, exatamente o desenho da seção 3.6.

Por fim, `lib/produtos.js` ganha uma linha no topo:

```js
import 'server-only'
```

Hoje a lista de produtos é inofensiva, mas no próximo capítulo esse arquivo passa a falar com uma fonte de dados de verdade. Pôr a trava antes de precisar dela é mais barato do que lembrar de pôr depois.

No seu projeto, a pergunta que decide tudo é a da seção 3.6: quais são as pontas interativas, e o que pode continuar no servidor. Faça a lista antes de escrever o primeiro `'use client'`; ela costuma ser bem menor do que parece.

### 3.12 O Que Levar Deste Capítulo

- todo componente em `app/` é Server Component por padrão: roda no servidor, pode ser `async`, acessa recursos do servidor e não envia código ao navegador;
- Server Components não usam eventos, hooks nem objetos do navegador, porque não ficam vivos depois de produzir o HTML;
- `'use client'` na primeira linha marca o arquivo, e tudo o que ele importa, como código que também vai para o navegador;
- Client Component também é renderizado no servidor na primeira visita, e depois hidratado no navegador;
- empurre o `'use client'` para as pontas: o botão, não a página;
- entre servidor e cliente só atravessam dados simples, nunca funções, com a exceção das Server Actions;
- um Client Component pode exibir conteúdo de servidor recebido pronto via `children`;
- `server-only` transforma o vazamento acidental de segredo num erro de build;
- a Vitrine ganhou seus dois primeiros Client Components, e o resto dela continua no servidor.

O próximo capítulo usa o privilégio mais valioso do servidor: buscar dados de verdade, direto no componente, e decidir por quanto tempo guardá-los antes de buscar de novo.
