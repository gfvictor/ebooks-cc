\newpage

# Capítulo II

\vspace{-1em}

## Roteamento por Arquivos

\vspace{1em}

Num projeto React puro, cada rota precisa ser registrada em algum lugar: uma lista que diz "o endereço `/sobre` mostra o componente `Sobre`". No App Router, essa lista não existe. A própria estrutura de pastas dentro de `app/` é a lista de rotas, e um punhado de nomes de arquivo com significado especial decide o que aparece em cada endereço, o que envolve cada página, o que mostrar enquanto ela carrega e o que fazer quando ela quebra.

Este capítulo apresenta essas convenções uma por uma. Nenhuma delas é difícil; o que dá trabalho no começo é lembrar que o nome do arquivo não é detalhe estético, é instrução para o framework.

### 2.1 A Pasta Vira Endereço

A regra básica cabe numa frase: **cada pasta dentro de `app/` é um trecho do endereço, e o arquivo `page.js` dentro dela é a página daquele endereço**.

```bash
app/
  page.js
  sobre/
    page.js
  blog/
    page.js
    primeiro-post/
      page.js
```

| Arquivo                          | Endereço              |
| -------------------------------- | --------------------- |
| `app/page.js`                    | `/`                   |
| `app/sobre/page.js`              | `/sobre`              |
| `app/blog/page.js`               | `/blog`               |
| `app/blog/primeiro-post/page.js` | `/blog/primeiro-post` |

Repare que é a **pasta** que dá nome ao trecho do endereço, não o arquivo. Todo arquivo de página se chama `page.js`, sempre. Um arquivo `app/sobre.js` não cria rota nenhuma.

O contrário também vale: uma pasta sem `page.js` não é uma página. Ela pode existir só para organizar pastas mais fundas, e o endereço correspondente responde com a página de "não encontrado". Isso significa que você pode guardar outros arquivos dentro de `app/`, como um componente usado só por uma página, sem medo de que ele vire rota por acidente. Só `page.js` é público.

> **Nota do Autor:** muitos projetos preferem deixar componentes fora de `app/`, numa pasta `components/` na raiz, e reservar `app/` só para rotas. Quando um componente precisa mesmo morar ao lado da página que o usa, uma pasta com nome começando por sublinhado, como `app/blog/_componentes/`, é ignorada pelo roteamento por completo. É o jeito de dizer ao Next.js, e a quem lê o projeto, "isto aqui não é endereço".

### 2.2 Navegando Entre Páginas: `Link`

Para ligar uma página a outra, o Next.js oferece o componente `Link`:

```jsx
import Link from 'next/link'

export default function Home() {
  return (
    <nav className="flex gap-4">
      <Link href="/sobre">Sobre</Link>
      <Link href="/blog">Blog</Link>
    </nav>
  )
}
```

No HTML final, `Link` vira um `<a>` comum, com `href` e tudo. A diferença está no clique. Um `<a>` puro faz o navegador descartar a página atual e carregar a próxima do zero, com piscada de tela branca. O `Link` intercepta o clique e troca só o que mudou, sem recarregar a página inteira. Além disso, quando um `Link` aparece na tela, o Next.js já começa a buscar a página de destino em segundo plano, e quando o usuário clica, ela muitas vezes já está pronta.

Use `Link` para navegar dentro do seu próprio site. Para endereços externos, como o site de outra empresa, o `<a>` comum continua sendo a escolha certa.

### 2.3 Layouts: A Moldura Que Fica

O Capítulo I apresentou o layout raiz, `app/layout.js`, que envolve o site inteiro. A mesma ideia funciona em qualquer nível: um `layout.js` dentro de uma pasta envolve todas as páginas daquela pasta e das pastas abaixo dela.

```bash
app/
  layout.js
  page.js
  painel/
    layout.js
    page.js
    produtos/
      page.js
```

```jsx
import Link from 'next/link'

export default function PainelLayout({ children }) {
  return (
    <div className="flex min-h-screen">
      <nav className="flex w-56 flex-col gap-2 border-r p-4">
        <Link href="/painel">Início</Link>
        <Link href="/painel/produtos">Produtos</Link>
      </nav>
      <main className="flex-1 p-6">{children}</main>
    </div>
  )
}
```

Tanto `/painel` quanto `/painel/produtos` aparecem com essa barra lateral, e nenhuma das duas páginas precisou importá-la. Os layouts se encaixam como caixas dentro de caixas: o layout raiz envolve o layout do painel, que envolve a página. O `children` de cada layout é o espaço onde entra o nível de baixo.

O detalhe mais valioso é o que acontece na navegação. Ao ir de `/painel` para `/painel/produtos`, o layout do painel **não é refeito**: só o conteúdo do `children` troca. A barra lateral fica exatamente onde estava, e se ela tivesse algum estado, como um menu recolhido ou um campo de busca preenchido, esse estado sobreviveria à troca de página. É por isso que layout é o lugar certo para tudo o que é comum a uma seção inteira: navegação, cabeçalho, barra lateral.

> **Cuidado:** a mesma característica tem um lado B. Como o layout não é refeito ao navegar entre as páginas que ele envolve, ele não é o lugar para algo que deveria mudar a cada página. Um título que depende da página atual pertence à página, não ao layout.

### 2.4 Rotas Dinâmicas: `[id]`

Um blog com duzentos posts não vai ter duzentas pastas. Quando um trecho do endereço é variável, o nome da pasta vai entre colchetes:

```bash
app/
  produtos/
    page.js
    [id]/
      page.js
```

Agora a página dessa pasta responde a qualquer valor naquele trecho do endereço: `/produtos/1`, `/produtos/42`, `/produtos/teclado`. A página recebe esse valor através da propriedade `params`:

```jsx
export default async function ProdutoPage({ params }) {
  const { id } = await params

  return <h1>Produto {id}</h1>
}
```

O nome entre colchetes vira o nome da chave: a pasta `[id]` produz `params.id`; uma pasta `[slug]` produziria `params.slug`. Repare no `async` e no `await`. Nas versões atuais do Next.js, `params` não chega pronto: é uma promessa, que precisa ser esperada antes de ser usada.

> **Cuidado:** muitos tutoriais escritos até 2024 usam `params.id` direto, sem `await`. Era assim nas versões antigas; a versão 15 ainda aceitava esse acesso direto, com um aviso no terminal, e as versões seguintes deixaram de aceitar. Se o exemplo que você está seguindo lê `params` sem esperar, ele é anterior à mudança.

Existe ainda uma variação para trechos de tamanho variável. Uma pasta chamada `[...slug]` captura o resto do endereço inteiro, com quantas barras vier: `/docs/instalacao` e `/docs/guia/avancado/cache` caem na mesma página, e `params.slug` chega como uma lista, `['guia', 'avancado', 'cache']`. É útil para documentação e conteúdo com hierarquia livre, e raro fora disso.

### 2.5 Quando o Endereço Não Existe: `notFound`

Uma rota dinâmica aceita qualquer valor, mas nem todo valor corresponde a algo real. `/produtos/9999` cai na página do produto, e o produto 9999 pode simplesmente não existir. Para esse caso, o Next.js oferece a função `notFound`:

```jsx
import { notFound } from 'next/navigation'

const produtos = { 1: 'Teclado', 2: 'Mouse' }

export default async function ProdutoPage({ params }) {
  const { id } = await params
  const nome = produtos[id]

  if (!nome) {
    notFound()
  }

  return <h1>{nome}</h1>
}
```

Chamar `notFound()` interrompe a página na hora e mostra a tela de "não encontrado", com a resposta HTTP correta, o código 404. Isso importa mais do que parece: uma página de erro que responde com sucesso (o código 200) confunde buscadores e ferramentas de monitoramento, que acham que o endereço existe.

A tela padrão é bem simples. Para personalizá-la, crie um arquivo `not-found.js`:

```jsx
import Link from 'next/link'

export default function NaoEncontrado() {
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">Página não encontrada</h1>
      <Link href="/">Voltar para o início</Link>
    </div>
  )
}
```

Na raiz, em `app/not-found.js`, ele vale para o site inteiro, incluindo endereços que não existem em lugar nenhum. Dentro de uma pasta, como `app/produtos/[id]/not-found.js`, ele atende os `notFound()` chamados naquela parte do site, o que permite uma mensagem mais específica, como "este produto não existe mais".

### 2.6 Grupos de Rotas: `(pasta)`

Às vezes você quer organizar pastas sem mexer no endereço. Um site com uma parte pública (início, preços, contato) e uma parte logada (painel, configurações) normalmente quer layouts completamente diferentes para cada lado, mas não quer `/publico/precos` nem `/logado/painel` no endereço.

Uma pasta com o nome entre parênteses é um **grupo de rotas**: ela organiza, mas não entra no endereço.

\newpage

```bash
app/
  layout.js
  (site)/
    layout.js
    page.js
    precos/
      page.js
  (app)/
    layout.js
    painel/
      page.js
```

| Arquivo                     | Endereço  |
| --------------------------- | --------- |
| `app/(site)/page.js`        | `/`       |
| `app/(site)/precos/page.js` | `/precos` |
| `app/(app)/painel/page.js`  | `/painel` |

As páginas de `(site)` compartilham o layout com cabeçalho e rodapé de site institucional; as de `(app)` compartilham o layout com barra lateral de sistema. Os dois grupos continuam dentro do layout raiz, com o mesmo `globals.css`, e nenhum parêntese aparece para o usuário.

> **Cuidado:** como o grupo some do endereço, dois grupos não podem ter páginas que resultem no mesmo caminho. Um `app/(site)/sobre/page.js` e um `app/(app)/sobre/page.js` disputariam o endereço `/sobre`, e o Next.js recusa o projeto com um erro.

### 2.7 Enquanto Carrega: `loading.js`

No Capítulo IV, as páginas vão buscar dados de verdade, e buscar dados leva tempo. Um arquivo `loading.js` ao lado de uma página define o que mostrar enquanto ela não fica pronta:

```jsx
export default function Carregando() {
  return <p className="p-6 text-slate-500">Carregando...</p>
}
```

Com `app/painel/loading.js` no lugar, a navegação para `/painel` é imediata: o layout do painel aparece na hora, com a barra lateral completa, e o espaço do conteúdo mostra o "Carregando..." até a página terminar. Sem esse arquivo, o usuário clicaria no link e ficaria olhando para a página anterior, sem sinal de que alguma coisa está acontecendo.

Um texto simples funciona, mas é comum usar blocos cinzas com o formato aproximado do conteúdo que vai chegar, os chamados _skeletons_. Com Tailwind, um `div` com `h-4 w-48 animate-pulse rounded bg-slate-200` já resolve.

Por baixo, `loading.js` é um atalho para um recurso do React chamado `Suspense`, que o Capítulo IV apresenta com calma. Por enquanto, basta saber que ele existe e onde colocá-lo.

### 2.8 Quando Quebra: `error.js`

Se algo der errado dentro de uma página, como uma busca de dados que falha, o comportamento padrão é derrubar a tela inteira. Um arquivo `error.js` limita o estrago àquele pedaço:

```jsx
'use client'

export default function Erro({ reset }) {
  return (
    <div className="p-6">
      <p>Não foi possível carregar esta página.</p>
      <button onClick={() => reset()}>Tentar de novo</button>
    </div>
  )
}
```

Com `app/painel/error.js`, um erro numa página do painel mostra essa mensagem no lugar do conteúdo, mas o layout do painel continua de pé: a barra lateral funciona, e o usuário pode navegar para outra página. A função `reset` tenta mostrar o conteúdo de novo, útil para falhas passageiras, como uma conexão que caiu por um instante.

Duas coisas chamam atenção nesse arquivo. A primeira é a linha `'use client'` no topo. Ela é obrigatória em `error.js`, porque o componente precisa reagir a um clique, e o motivo exato é o assunto do próximo capítulo. A segunda é o alcance: `error.js` protege as páginas e pastas abaixo dele, mas não o `layout.js` da mesma pasta, porque o layout fica "por fora" dele. Um erro no layout do painel é capturado pelo `error.js` da pasta de cima.

> **Nota do Autor:** o componente de erro também recebe uma propriedade `error`, com a mensagem do erro. Em desenvolvimento, ela mostra o problema real; em produção, erros que acontecem no servidor chegam com a mensagem trocada por um texto genérico. Isso é proposital: a mensagem original pode conter detalhes internos, como nomes de tabela ou trechos de consulta, que não devem aparecer para qualquer visitante. O detalhe completo continua disponível no registro do servidor.

### 2.9 A Hierarquia Completa

Com todos os arquivos especiais no lugar, uma pasta de rota pode ter esta cara:

```bash
app/painel/
  layout.js
  error.js
  loading.js
  not-found.js
  page.js
```

E o Next.js os encaixa sempre na mesma ordem, de fora para dentro: o `layout` envolve tudo; dentro dele, o `error` protege o que vem abaixo; dentro do `error`, o `loading` cobre a espera; e no centro fica a `page`. Essa ordem explica os comportamentos das seções anteriores. O layout sobrevive a um erro na página porque está por fora do `error`. O layout aparece imediatamente durante o carregamento porque está por fora do `loading`. E o `error.js` não pega erros do próprio layout pelo mesmo motivo: o layout está do lado de fora da proteção.

Nenhum desses arquivos é obrigatório além do `page.js`. Comece só com páginas e layouts, e acrescente `loading.js` e `error.js` nas partes do site que buscam dados, que é exatamente onde esperas e falhas acontecem.

### 2.10 A Vitrine Até Aqui

Hora de aplicar o capítulo na Vitrine. Ao fim desta seção, o projeto tem esta estrutura:

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
  lib/
    produtos.js
```

A parte pública fica no grupo `(site)`, e o painel no grupo `(app)`, cada um com o seu layout, exatamente como a seção 2.6 descreveu. O `app/page.js` criado pelo instalador precisa sair da raiz e ir para dentro de `(site)/`: dois `page.js` respondendo pelo endereço `/` fariam o Next.js recusar o projeto. O `app/layout.js` do Capítulo I continua onde está, como layout raiz dos dois grupos, e o `not-found.js` da seção 2.5 vai direto em `app/`.

Os produtos ainda não vêm de lugar nenhum de verdade. Por enquanto, eles moram numa lista fixa, num arquivo fora de `app/`, que não é rota:

```js
const produtos = [
  {
    id: '1',
    nome: 'Teclado mecânico',
    preco: 350,
    descricao: 'Switches táteis e layout ABNT2.',
  },
  {
    id: '2',
    nome: 'Mouse sem fio',
    preco: 120,
    descricao: 'Sensor óptico e bateria para três meses.',
  },
  {
    id: '3',
    nome: 'Monitor 24 polegadas',
    preco: 900,
    descricao: 'Painel IPS com resolução Full HD.',
  },
]

export function listarProdutos() {
  return produtos
}

export function buscarProduto(id) {
  return produtos.find((produto) => produto.id === id)
}
```

As páginas nunca leem a lista diretamente: elas chamam `listarProdutos` e `buscarProduto`. Essa separação vai pagar o investimento no Capítulo IV, quando os produtos passarem a vir de uma fonte de dados de verdade. Só esse arquivo muda; nenhuma página precisa saber.

O layout de `(site)` traz o cabeçalho com a navegação:

```jsx
import Link from 'next/link'

export default function SiteLayout({ children }) {
  return (
    <>
      <header className="flex gap-4 border-b p-4">
        <Link href="/" className="font-bold">
          Vitrine
        </Link>
        <Link href="/produtos">Produtos</Link>
      </header>
      <main className="p-6">{children}</main>
    </>
  )
}
```

O `<>` vazio é um fragmento do React: um jeito de devolver dois elementos lado a lado sem criar uma `div` extra em volta deles.

A página inicial, `(site)/page.js`, pode ser tão simples quanto um título e um `Link` para os produtos. A lista de produtos, `(site)/produtos/page.js`, usa o grid responsivo do Capítulo IV do Livro II:

```jsx
import Link from 'next/link'
import { listarProdutos } from '@/lib/produtos'

export default function ProdutosPage() {
  const produtos = listarProdutos()

  return (
    <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {produtos.map((produto) => (
        <li key={produto.id} className="rounded-lg border p-4">
          <Link href={`/produtos/${produto.id}`}>{produto.nome}</Link>
        </li>
      ))}
    </ul>
  )
}
```

O `@/` no import é o atalho definido no `jsconfig.json`, apontando para a raiz do projeto: `@/lib/produtos` funciona igual, não importa quão funda seja a pasta de quem importa.

E a página de cada produto, `(site)/produtos/[id]/page.js`, junta a rota dinâmica da seção 2.4 com o `notFound` da seção 2.5:

```jsx
import { notFound } from 'next/navigation'
import { buscarProduto } from '@/lib/produtos'

export default async function ProdutoPage({ params }) {
  const { id } = await params
  const produto = buscarProduto(id)

  if (!produto) {
    notFound()
  }

  return (
    <article className="flex flex-col gap-2">
      <h1 className="text-2xl font-bold">{produto.nome}</h1>
      <p className="text-lg">R$ {produto.preco}</p>
      <p>{produto.descricao}</p>
    </article>
  )
}
```

No painel, `(app)/painel/layout.js` é o layout com barra lateral da seção 2.3, e `(app)/painel/page.js` por enquanto é só um título. O link "Produtos" da barra lateral ainda leva à tela de "não encontrado", e isso é esperado: a página de cadastro nasce no Capítulo V.

Com isso, a Vitrine responde a `/produtos`, a cada `/produtos/1`, `/produtos/2` e `/produtos/3`, e a um 404 correto em `/produtos/99`: tudo o que este capítulo ensinou funcionando junto, num projeto só. No seu projeto, o trabalho é tomar as mesmas decisões para o seu tema: quais grupos de rotas ele tem, qual trecho do endereço é dinâmico, e qual arquivo concentra o acesso aos dados.

### 2.11 O Que Levar Deste Capítulo

- cada pasta dentro de `app/` é um trecho do endereço, e só o `page.js` torna uma pasta acessível;
- `Link` navega sem recarregar a página e busca o destino antes do clique; `<a>` comum fica para endereços externos;
- `layout.js` envolve todas as páginas abaixo dele e não é refeito ao navegar entre elas, então preserva estado;
- `[id]` cria rotas dinâmicas; `params` é uma promessa e precisa de `await`;
- `notFound()` responde com 404 de verdade, e `not-found.js` personaliza a tela;
- `(grupo)` organiza pastas e separa layouts sem aparecer no endereço;
- `loading.js` mostra algo enquanto a página carrega, e `error.js` isola falhas sem derrubar o layout;
- a ordem de fora para dentro é sempre `layout`, `error`, `loading`, `page`;
- a Vitrine já tem parte pública e painel em grupos separados, e os produtos passam por `lib/produtos.js`, nunca direto pelas páginas.

O próximo capítulo explica a linha `'use client'` que apareceu no `error.js`, e com ela a decisão mais importante do App Router: o que roda no servidor e o que roda no navegador.
