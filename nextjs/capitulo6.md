\newpage

# Capítulo VI

\vspace{-1em}

## Do Projeto ao Ar

\vspace{1em}

A Vitrine funciona: lista produtos, mostra cada um, cadastra e exclui. Mas funciona no seu computador, com um título de aba genérico, sem foto de produto, com a fonte padrão do sistema, e com o endereço da API escrito num arquivo que só existe na sua máquina. Entre "funciona aqui" e "está no ar" existe uma lista de detalhes que ninguém vê quando estão certos, e que todo mundo vê quando estão errados.

Este capítulo percorre essa lista: o título de cada página e a prévia que aparece quando alguém compartilha um link, imagens e fontes que não pesam nem fazem a página pular, variáveis de ambiente que separam o seu computador do servidor de verdade, e, por fim, a publicação.

### 6.1 O Título da Aba: `metadata`

O Capítulo I mostrou, sem se aprofundar, um objeto `metadata` exportado do layout raiz. É assim que o App Router define o que vai na `<head>` da página, sem você escrever uma tag sequer:

```jsx
export const metadata = {
  title: 'Sobre a loja',
  description: 'Conheça a história da Vitrine.',
}
```

Esse objeto pode ser exportado de qualquer `page.js` ou `layout.js`. O `title` vira o texto da aba do navegador e o título que aparece nos resultados de busca; o `description` vira o resumo que os buscadores costumam mostrar logo abaixo do título.

Num site com muitas páginas, repetir o nome da loja em todo título fica cansativo. O layout raiz pode definir um modelo, e cada página preenche só a parte dela:

```jsx
export const metadata = {
  title: {
    template: '%s | Vitrine',
    default: 'Vitrine',
  },
}
```

Com isso, uma página que exporta `title: 'Produtos'` aparece na aba como "Produtos | Vitrine". O `%s` é o lugar onde entra o título da página, e o `default` vale para as páginas que não definem título nenhum.

### 6.2 Metadados Que Dependem do Dado: `generateMetadata`

A página de um produto não tem título fixo: ele depende de qual produto está sendo exibido. Para esses casos, em vez de um objeto, a página exporta uma função assíncrona, que recebe os mesmos `params` da página:

```jsx
export async function generateMetadata({ params }) {
  const { id } = await params
  const produto = await buscarProduto(id)

  return {
    title: produto.nome,
    description: produto.descricao,
  }
}
```

Repare que essa função chama `buscarProduto`, e a página, logo abaixo no mesmo arquivo, chama de novo. Parece um pedido duplicado à API, e é aqui que a **Nota do Autor** da seção 4.9 paga a promessa: dentro de uma mesma montagem de página, chamadas de `fetch` iguais são feitas uma vez só. A API recebe um pedido, e as duas funções recebem a mesma resposta.

### 6.3 A Prévia do Link: `openGraph`

Lembra do robô do Capítulo I, que lê só o HTML da primeira resposta para montar a prévia quando alguém compartilha um link num aplicativo de mensagens? Agora que a Vitrine entrega HTML pronto, falta dizer a esse robô o que mostrar. As informações da prévia seguem um padrão chamado _Open Graph_, e o objeto de metadados tem uma chave só para ele:

```jsx
return {
  title: produto.nome,
  description: produto.descricao,
  openGraph: {
    title: produto.nome,
    description: produto.descricao,
    images: [produto.imagem],
  },
}
```

Com isso, colar o link de um produto numa conversa mostra um cartão com o nome, a descrição e a foto do produto, em vez de um endereço sem graça. Para uma loja, essa diferença vale vendas.

> **Nota do Autor:** para a página inicial e outras páginas sem foto própria, não precisa nem de código. Um arquivo de imagem chamado `opengraph-image.png`, colocado dentro de uma pasta de rota, vira automaticamente a imagem de prévia daquela rota e das que estão abaixo dela. É a mesma ideia do `page.js` e do `layout.js`: o nome do arquivo é a instrução.

### 6.4 Imagens: `next/image`

Uma foto de produto tirada com um celular moderno pode passar de cinco megabytes. Colocá-la direto num `<img>` faz todo visitante baixar esses cinco megabytes, mesmo vendo a foto num espaço de trezentos pixels de largura, no celular, com internet ruim. O componente `Image` do Next.js resolve isso:

```jsx
import Image from 'next/image'

export default function FotoProduto({ produto }) {
  return (
    <Image
      src={produto.imagem}
      alt={produto.nome}
      width={800}
      height={600}
      className="rounded-lg"
    />
  )
}
```

Por fora, parece um `<img>` com dois atributos a mais. Por dentro, ele faz três trabalhos:

- **entrega o tamanho certo:** o servidor gera versões menores da imagem e o navegador baixa a que serve para a tela de quem está vendo, em vez do arquivo original;
- **entrega no formato certo:** converte para formatos mais leves, como WebP e AVIF, quando o navegador suporta;
- **carrega só quando aparece:** imagens fora da tela só são baixadas quando o usuário rola até perto delas.

`width` e `height` não definem o tamanho em que a imagem aparece; isso continua sendo trabalho do CSS. Eles informam a **proporção** da imagem, para o navegador reservar o espaço certo antes de ela chegar. Sem isso, o texto abaixo da foto aparece primeiro, e depois pula para baixo quando a imagem carrega, exatamente na hora em que o usuário ia tocar num botão. E `alt` é obrigatório: é o texto lido por leitores de tela e mostrado quando a imagem falha.

Quando as imagens vêm de outro endereço, como o servidor de arquivos da loja, o Next.js precisa de permissão explícita para otimizá-las. Sem isso, ele se recusa, para não virar um otimizador gratuito de imagens de qualquer site da internet. A permissão fica no `next.config.mjs`:

```js
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'imagens.exemplo.com',
      },
    ],
  },
}

export default nextConfig
```

### 6.5 Fontes: `next/font`

O Capítulo V do Livro II carregou uma fonte com `@import url(...)` no topo do `globals.css`, e uma **Nota do Autor** avisou que esse não era o jeito mais rápido, e que o Livro III voltaria ao assunto. Voltou.

Carregar uma fonte do Google Fonts pelo `@import` obriga o navegador de cada visitante a buscar o arquivo num servidor externo, depois de já ter começado a desenhar a página. Enquanto a fonte não chega, o texto aparece com a fonte do sistema, e depois troca, mudando de largura e empurrando o resto da página. O `next/font` baixa a fonte **uma vez, no build**, e a serve junto com o próprio site:

```jsx
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' })

export default function RootLayout({ children }) {
  return (
    <html lang="pt-BR" className={inter.variable}>
      <body className="bg-fundo text-texto">{children}</body>
    </html>
  )
}
```

`subsets: ['latin']` baixa só os caracteres do alfabeto latino, incluindo os acentos do português, em vez da fonte inteira com alfabetos que o site nunca vai usar. `variable: '--font-inter'` faz o `next/font` expor a fonte como uma custom property, e `className={inter.variable}` no `<html>` declara essa propriedade para a página inteira.

Agora falta ligar essa propriedade ao Tailwind, e é exatamente o caso que a outra **Nota do Autor** do Capítulo V do Livro II descreveu: um token que aponta para uma variável definida por outra ferramenta. No `globals.css`:

```css
@theme inline {
  --font-sans: var(--font-inter);
}
```

Sem o `inline`, o Tailwind tentaria resolver `var(--font-inter)` no `:root`, mas quem declara essa variável é a classe que o `next/font` pôs no `<html>`. Com o `inline`, o utilitário usa a referência à variável direto, e ela é resolvida no lugar certo. Como `--font-sans` é a fonte base do documento, o site inteiro passa a usar a Inter, sem nenhuma classe a mais.

### 6.6 Variáveis de Ambiente

A Vitrine lê o endereço da API em `process.env.API_URL`, definido no `.env.local` desde o Capítulo IV. Esse arquivo tem três características que importam agora:

- **ele não vai para o repositório:** o `.gitignore` criado pelo `create-next-app` já ignora arquivos `.env`. É de propósito: é ali que moram chaves de API e senhas, que nunca devem ser versionadas;
- **cada ambiente tem o seu:** no seu computador, `API_URL` aponta para a API local; no servidor de produção, para a API de verdade. O código é o mesmo, e só a variável muda;
- **é lido quando o servidor inicia:** mudou o arquivo, reinicie o `npm run dev`.

A regra mais importante é sobre quem pode ler cada variável. Por padrão, toda variável de ambiente existe **só no servidor**. Um Client Component que tente ler `process.env.API_URL` recebe `undefined`, e isso é uma proteção, não um defeito: é o que impede uma chave secreta de ir parar no JavaScript do navegador.

Quando uma variável precisa mesmo chegar ao navegador, como o número de WhatsApp da loja usado por um botão interativo, o nome dela começa com `NEXT_PUBLIC_`:

```bash
API_URL=http://localhost:4000
NEXT_PUBLIC_WHATSAPP_LOJA=5511999999999
```

O prefixo faz o Next.js escrever o valor direto no JavaScript enviado ao navegador, no momento do build. Por isso, a regra é simples: `NEXT_PUBLIC_` só em valores que você publicaria num cartaz na porta da loja. Endereço de API interna, chave de serviço, senha de banco: nunca.

Como o `.env.local` não vai para o repositório, quem clonar o projeto não sabe quais variáveis ele precisa. A convenção é versionar um `.env.example`, com os nomes e sem os valores secretos:

```bash
API_URL=
NEXT_PUBLIC_WHATSAPP_LOJA=
```

É a mesma ideia de "declarar por escrito o que o projeto precisa para rodar" que o Prólogo desta coletânea defendeu: o projeto avisa o que falta, em vez de quebrar com uma mensagem misteriosa.

### 6.7 Antes de Publicar: O Build Local

O `npm run dev` perdoa muita coisa. Ele monta cada página só quando é visitada, e uma página com erro que ninguém abriu passa despercebida. O `npm run build` não perdoa: ele monta todas as páginas estáticas, confere o projeto inteiro, e para no primeiro erro.

Por isso, antes de qualquer publicação, rode o build na sua máquina, seguido de `npm run start`, e confira:

- o build termina sem erro;
- a lista de rotas no fim mostra cada página com a estratégia que você esperava, estática ou dinâmica, como o Capítulo IV ensinou;
- as páginas abrem, as imagens aparecem e os formulários funcionam rodando o `start`, que é o modo de produção, e não o `dev`.

Um erro descoberto aqui custa um minuto. O mesmo erro descoberto depois da publicação custa o constrangimento de um site quebrado no ar.

### 6.8 Publicando

O jeito mais direto de publicar um projeto Next.js é a Vercel, a empresa que criou e mantém o framework. O caminho cabe em poucos passos:

1. o projeto precisa estar num repositório no GitHub, ou num serviço equivalente;
2. no site da Vercel, você cria um projeto novo e escolhe esse repositório. Ela reconhece que é um projeto Next.js e preenche sozinha os comandos de build;
3. antes de publicar, você cadastra as variáveis de ambiente de produção no painel do projeto, com os mesmos nomes do `.env.example`;
4. a Vercel roda o `npm run build` nos servidores dela e publica o resultado num endereço próprio.

Daí em diante, cada envio para a branch principal do repositório publica uma versão nova sozinho. Envios para outras branches, ou pedidos de merge, geram uma **versão de prévia**, com endereço próprio, para testar a mudança antes de ela chegar ao site principal. Se você seguiu a trilogia de Git, o fluxo de branches e pedidos de merge encaixa aqui sem nenhuma adaptação.

> **Cuidado:** o plano gratuito da Vercel é para projetos pessoais e não comerciais. Um site que gera receita, como a loja de um cliente, exige um plano pago. Leia os termos antes de publicar algo que não é só seu.

A Vercel não é a única opção. Um projeto Next.js roda em qualquer servidor com Node.js: `npm run build` seguido de `npm run start` é tudo o que ele precisa, e é assim que ele roda em serviços de hospedagem genéricos, em contêineres ou num servidor próprio. A Vercel só automatiza o caminho e cuida de detalhes como o cache e a distribuição pelo mundo.

### 6.9 A Vitrine Até Aqui

A Vitrine chega à versão final do livro. A estrutura completa:

\newpage

```bash
vitrine/
  .env.example
  next.config.mjs
  app/
    globals.css
    layout.js
    not-found.js
    (site)/
      layout.js
      page.js
      produtos/
        error.js
        loading.js
        page.js
        [id]/
          page.js
    (app)/
      painel/
        layout.js
        page.js
        produtos/
          page.js
  components/
    botao-comprar.js
    botao-tema.js
    formulario-produto.js
  lib/
    acoes.js
    produtos.js
```

O layout raiz ganha a fonte da seção 6.5 e o modelo de título da seção 6.1, com uma descrição para o site inteiro:

```jsx
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' })

export const metadata = {
  title: {
    template: '%s | Vitrine',
    default: 'Vitrine',
  },
  description: 'Periféricos para quem passa o dia no computador.',
}

export default function RootLayout({ children }) {
  return (
    <html lang="pt-BR" className={inter.variable}>
      <body className="bg-fundo text-texto">{children}</body>
    </html>
  )
}
```

O `globals.css` ganha o bloco `@theme inline` da mesma seção, ao lado dos tokens de cor do Capítulo III. A API da loja passa a devolver, para cada produto, um campo `imagem` com o endereço da foto, hospedada no servidor de arquivos da loja, e o `next.config.mjs` da seção 6.4 autoriza esse endereço.

A página do produto é a que mais mudou desde o Capítulo II, e vale vê-la inteira, com tudo o que o livro acrescentou a ela:

```jsx
import Image from 'next/image'
import { notFound } from 'next/navigation'
import BotaoComprar from '@/components/botao-comprar'
import { buscarProduto, listarProdutos } from '@/lib/produtos'

export async function generateStaticParams() {
  const produtos = await listarProdutos()

  return produtos.map((produto) => ({ id: produto.id }))
}

export async function generateMetadata({ params }) {
  const { id } = await params
  const produto = await buscarProduto(id)

  if (!produto) {
    return { title: 'Produto não encontrado' }
  }

  return {
    title: produto.nome,
    description: produto.descricao,
    openGraph: {
      title: produto.nome,
      description: produto.descricao,
      images: [produto.imagem],
    },
  }
}

export default async function ProdutoPage({ params }) {
  const { id } = await params
  const produto = await buscarProduto(id)

  if (!produto) {
    notFound()
  }

  return (
    <article className="flex flex-col gap-2">
      <Image
        src={produto.imagem}
        alt={produto.nome}
        width={800}
        height={600}
        className="rounded-lg"
      />
      <h1 className="text-2xl font-bold">{produto.nome}</h1>
      <p className="text-lg">R$ {produto.preco}</p>
      <p>{produto.descricao}</p>
      <BotaoComprar />
    </article>
  )
}
```

São seis capítulos num arquivo só: a rota dinâmica e o `notFound` do Capítulo II, o `BotaoComprar` cruzando a fronteira do Capítulo III, o `generateStaticParams` e a busca com cache do Capítulo IV, a revalidação do Capítulo V agindo por trás quando um produto muda, e os metadados e a imagem deste capítulo.

O `.env.example` da seção 6.6 vai para o repositório só com `API_URL=`, e na Vercel essa variável recebe o endereço público da API da loja. Esse detalhe é fácil de esquecer: o `json-server` do Capítulo IV, rodando no seu computador, não é alcançável por um servidor na internet. A Vitrine publicada precisa de uma API publicada.

E um lembrete que o Capítulo V já deu, mas que agora deixa de ser teoria: publicada assim, sem login, o painel da Vitrine fica aberto para qualquer visitante. Para uma demonstração, tudo bem. Para o seu projeto, o painel publicado sem autenticação é uma porta da loja deixada aberta durante a noite.

No seu projeto, este capítulo pede uma última lista: o título e a descrição de cada tipo de página, a imagem que representa cada uma quando compartilhada, quais variáveis de ambiente ele precisa e quais delas o navegador pode ver, e onde ele vai morar depois de publicado. Quando essa lista estiver respondida, e o build local passar limpo, o projeto está pronto para alguém além de você usar.

### 6.10 O Que Levar Deste Capítulo

- `metadata` define título e descrição de cada página; um `template` no layout raiz evita repetir o nome do site;
- `generateMetadata` gera metadados a partir do dado, e a memoização do `fetch` evita buscar o mesmo dado duas vezes;
- `openGraph` controla a prévia que aparece quando alguém compartilha o link;
- `next/image` entrega cada imagem no tamanho e no formato certos, carrega só quando aparece, e usa `width` e `height` para reservar o espaço;
- `next/font` baixa a fonte no build e a serve junto com o site; com `@theme inline`, ela vira a fonte base do Tailwind;
- variáveis de ambiente existem só no servidor, a menos que comecem com `NEXT_PUBLIC_`; um `.env.example` documenta o que o projeto precisa;
- o `npm run build` local é a última conferência antes de publicar;
- a Vercel publica a cada envio e cria uma prévia para cada branch, mas qualquer servidor com Node.js roda um projeto Next.js.

Com este capítulo, a Vitrine saiu do seu computador, e o livro chega ao fim do caminho que prometeu: do componente solto do Livro II a uma aplicação publicada.
