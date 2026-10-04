\newpage

# Capítulo IV

\vspace{-1em}

## Buscando Dados

\vspace{1em}

Até aqui, os produtos da Vitrine moravam numa lista fixa, escrita à mão dentro de `lib/produtos.js`. Nenhum site de verdade funciona assim: os dados vivem em outro lugar, mudam sem avisar, e às vezes demoram para chegar ou simplesmente não chegam.

Este capítulo mostra como um Server Component busca dados, e depois enfrenta a pergunta que de fato dá trabalho: por quanto tempo guardar o que foi buscado. É o retorno das três estratégias do Capítulo I, agora com código. A padaria que assa de madrugada, a fornada de hora em hora e o restaurante que cozinha a cada pedido viram, cada um, uma linha de configuração.

### 4.1 Buscar Dados É Só `await`

O Capítulo III mostrou que um Server Component pode ser uma função `async`. É só isso que buscar dados exige:

```jsx
export default async function CotacaoPage() {
  const resposta = await fetch('https://api.exemplo.com/cotacao')
  const cotacao = await resposta.json()

  return <p className="p-6">Dólar hoje: R$ {cotacao.valor}</p>
}
```

O componente espera a resposta, lê o JSON e devolve o HTML já com o valor dentro. Não há tela de "carregando" controlada à mão, nem estado guardando o resultado, nem efeito rodando depois que a página aparece.

Se você já viu React montado no navegador, sabe que lá a história é outra: o componente aparece vazio, dispara a busca depois de desenhado, guarda o resultado num estado e se desenha de novo quando os dados chegam. Três etapas, um estado intermediário para tratar, e o conteúdo sempre chegando depois da página. No Server Component, a busca acontece **antes** de o HTML existir, e o que chega ao navegador já é a página completa.

### 4.2 Onde Esse `fetch` Roda

O `fetch` de um Server Component roda no servidor, e isso muda mais do que parece:

- **segredos ficam protegidos:** o endereço da API, a chave de acesso, o cabeçalho de autorização, nada disso aparece no navegador, porque o código não vai até lá;
- **a rede é outra:** o servidor do site costuma estar perto do servidor da API, numa conexão rápida e estável, em vez de depender do Wi-Fi de quem está acessando;
- **não há bloqueio entre origens:** a regra que impede o navegador de chamar APIs de outros domínios sem permissão, o chamado CORS, não se aplica a uma chamada feita de servidor para servidor.

É por isso que a Vitrine concentra as buscas em `lib/produtos.js`, com o `import 'server-only'` do Capítulo III no topo. Esse arquivo vai falar com a API da loja, e nenhuma linha dele deve chegar ao navegador.

### 4.3 O Pão da Madrugada

Aqui está o detalhe que mais surpreende quem chega ao Next.js. Pegue a página de cotação da seção 4.1, rode `npm run build` e olhe a lista de rotas no fim: ela aparece como **estática**.

Faz sentido quando você lembra do Capítulo I. A página não lê nada que dependa do pedido, como cookies ou o endereço exato visitado, então o Next.js a gera uma vez, no build, como a padaria que assa de madrugada. O `fetch` roda nesse momento, a cotação daquele instante fica gravada dentro do HTML, e todo visitante recebe exatamente essa página. Amanhã, com o dólar em outro valor, a página continua mostrando o de ontem, até alguém rodar o build de novo.

Para uma página "Sobre nós", isso é perfeito. Para uma cotação, é um bug. O Next.js não tem como adivinhar qual dos dois é o seu caso; é você quem precisa dizer por quanto tempo o pão pode ficar na prateleira.

> **Nota do Autor:** no `npm run dev`, esse comportamento não aparece. O servidor de desenvolvimento monta cada página a cada pedido, para você ver na hora o efeito de cada arquivo salvo. Por isso, toda decisão deste capítulo só pode ser conferida de verdade com `npm run build` seguido de `npm run start`. Muita gente descobre que a página "não atualiza" só depois de publicar.

### 4.4 A Fornada de Hora em Hora: `revalidate`

A resposta mais comum é um meio-termo: continuar estático, mas refazer a página de tempos em tempos. A **Nota do Autor** da seção 1.4 chamou isso de fornada de hora em hora, e no código é uma opção do `fetch`:

```jsx
const resposta = await fetch('https://api.exemplo.com/cotacao', {
  next: { revalidate: 3600 },
})
```

O número é em segundos. Com `3600`, a resposta da API vale por uma hora. O funcionamento exato tem uma sutileza que vale entender:

1. no build, a página é gerada com a cotação daquele momento;
2. durante a hora seguinte, todo visitante recebe essa página pronta, sem nenhuma chamada à API;
3. passada a hora, o primeiro visitante **ainda recebe a página antiga**, na hora, sem esperar, e esse pedido dispara, em segundo plano, a geração de uma página nova;
4. quando a nova fica pronta, ela substitui a antiga para todos os visitantes seguintes.

O passo 3 é o que torna essa estratégia tão boa: ninguém espera. O custo é que um visitante, uma vez por hora, vê um valor que acabou de vencer. Para catálogo de produtos, artigo de blog, cardápio, quase sempre é uma troca excelente.

A mesma configuração pode valer para a página inteira, em vez de para um `fetch` só, exportando uma constante do arquivo da página:

```jsx
export const revalidate = 3600
```

### 4.5 Quando Tem Que Ser na Hora

Há dados que não admitem nem uma hora de atraso: o saldo de uma conta, o status de um pedido que o cliente acabou de fazer, o estoque na hora de fechar a compra. Para esses, a opção é dizer ao `fetch` que a resposta não deve ser guardada:

```jsx
const resposta = await fetch('https://api.exemplo.com/saldo', {
  cache: 'no-store',
})
```

Agora a página vira o restaurante do Capítulo I: montada a cada pedido, sempre com o dado mais recente, e com o custo de uma chamada à API por visita.

Existe um segundo jeito de uma página se tornar dinâmica, e ele costuma acontecer sem você perceber: ler algo que só existe no momento do pedido. Os casos mais comuns são as funções `cookies()` e `headers()`, importadas de `next/headers`, e a propriedade `searchParams` da página, que traz o que vem depois do `?` no endereço, como em `/produtos?busca=teclado`. Nenhuma delas tem valor no build, porque no build não existe visitante. Basta usar uma delas para a rota inteira passar a ser montada a cada pedido.

As três escolhas, lado a lado:

| Configuração              | Estratégia                   | Na analogia               |
| ------------------------- | ---------------------------- | ------------------------- |
| nenhuma                   | estática, gerada no build    | o pão da madrugada        |
| `next: { revalidate: N }` | estática, refeita a cada N s | a fornada de hora em hora |
| `cache: 'no-store'`       | dinâmica, a cada pedido      | o prato feito na hora     |

A regra prática é começar pela linha do meio. Quase todo dado aceita algum atraso, e o `revalidate` entrega quase toda a velocidade do estático com dados razoavelmente frescos. Suba para `no-store` só quando o atraso for inaceitável de verdade, e não por precaução.

> **Nota do Autor:** as versões mais recentes do Next.js oferecem, como opção a ser ativada no projeto, um modelo novo de cache baseado numa diretiva `'use cache'`, que marca funções e componentes inteiros como guardáveis. A sintaxe muda, mas as perguntas deste capítulo continuam exatamente as mesmas: o dado pode ser guardado? Por quanto tempo? O que invalida a cópia guardada? Quem entende as três respostas aqui entende o modelo novo em meia hora de documentação.

### 4.6 Páginas Dinâmicas Geradas Antes: `generateStaticParams`

A rota `/produtos/[id]` tem um problema particular. No build, o Next.js não sabe quais `id` existem, então não tem como gerar a página de cada produto de antemão. Sem mais nenhuma informação, ele trata a rota como dinâmica, e monta a página a cada pedido, mesmo que o dado por trás dela esteja guardado.

Se você sabe quais produtos existem, pode contar ao Next.js no próprio arquivo da página:

```jsx
export async function generateStaticParams() {
  const produtos = await listarProdutos()

  return produtos.map((produto) => ({ id: produto.id }))
}
```

A função devolve uma lista de objetos, um para cada página a gerar, com as mesmas chaves dos colchetes do nome da pasta. No build, o Next.js chama essa função, recebe algo como `[{ id: '1' }, { id: '2' }, { id: '3' }]`, e gera as três páginas na hora, junto com o resto do site. Um produto cadastrado depois do build não fica de fora: a página dele é gerada na primeira visita, como antes, e guardada a partir daí.

### 4.7 Em Paralelo, Não em Fila

Quando uma página precisa de mais de uma informação, o jeito mais natural de escrever é também o mais lento:

```jsx
const produto = await buscarProduto(id)
const avaliacoes = await buscarAvaliacoes(id)
```

A segunda busca só começa quando a primeira termina. Se cada uma leva meio segundo, a página leva um segundo inteiro, e não havia motivo nenhum para isso: uma não depende da outra. É a fila do banco com um caixa só, embora houvesse dois livres.

O conserto é disparar as duas antes de esperar qualquer uma:

```jsx
const buscas = [buscarProduto(id), buscarAvaliacoes(id)]
const [produto, avaliacoes] = await Promise.all(buscas)
```

Chamar uma função `async` sem `await` não espera nada: a chamada começa e devolve na hora uma promessa do resultado. Na primeira linha, então, as duas buscas já estão a caminho, ao mesmo tempo. `Promise.all` recebe as duas promessas e espera até que ambas terminem, devolvendo os resultados na mesma ordem.

Agora a página leva o tempo da busca mais lenta, não a soma de todas. A fila só se justifica quando uma busca depende do resultado da outra, como buscar o produto para descobrir o `id` da categoria, e só então buscar a categoria.

### 4.8 Mostrar o Que Já Está Pronto: `Suspense`

Mesmo em paralelo, às vezes uma parte da página é muito mais lenta que o resto. As avaliações de um produto podem vir de um serviço externo que leva dois segundos, enquanto o nome, o preço e a descrição chegam em cem milissegundos. Fazer o visitante esperar dois segundos para ver o preço é desperdício.

O `Suspense` do React resolve isso. Ele envolve a parte lenta e define o que mostrar no lugar dela enquanto ela não fica pronta:

```jsx
import { Suspense } from 'react'

export default async function ProdutoPage({ params }) {
  const { id } = await params
  const produto = await buscarProduto(id)

  return (
    <article>
      <h1>{produto.nome}</h1>
      <Suspense fallback={<p>Carregando avaliações...</p>}>
        <Avaliacoes id={id} />
      </Suspense>
    </article>
  )
}
```

`Avaliacoes` é um Server Component `async` que faz a própria busca. O servidor envia imediatamente o HTML de tudo o que está pronto, com o texto do `fallback` no lugar das avaliações, e **mantém a conexão aberta**. Quando `Avaliacoes` termina, o servidor envia o pedaço que faltava, e ele entra no lugar certo da página. Isso se chama _streaming_: a página chega em partes, na ordem em que fica pronta, em vez de esperar pela parte mais lenta.

Lembra do `loading.js` do Capítulo II, e da promessa de que ele era um atalho para algo que este capítulo apresentaria? Era isso. `loading.js` é um `Suspense` em volta da página inteira, com o conteúdo do arquivo como `fallback`. O `Suspense` escrito à mão é a mesma ideia com mais precisão: em vez da página toda esperar, só o pedaço lento espera.

### 4.9 Quando a API Falha

Uma chamada de rede pode falhar de muitos jeitos, e o `fetch` só reclama sozinho de um deles: quando nem consegue se conectar. Se a API responde com erro, como um 500 ou um 404, o `fetch` considera que a conversa aconteceu, e devolve a resposta normalmente. Quem precisa conferir é você:

```jsx
const resposta = await fetch(`${API_URL}/produtos`)

if (!resposta.ok) {
  throw new Error('Falha ao buscar produtos')
}
```

`resposta.ok` é verdadeiro só para respostas de sucesso, os códigos da faixa 200. Sem essa verificação, a página tenta ler como produtos a mensagem de erro da API e quebra num lugar bem mais confuso, ou pior, exibe uma lista vazia como se a loja não tivesse nada à venda.

Lançar o erro com `throw` não é deixar a página quebrar sem controle. É entregar o problema para quem sabe lidar com ele: o `error.js` do Capítulo II, que mostra uma mensagem no lugar do conteúdo e mantém o layout de pé. O 404 é um caso à parte, porque não é falha: é a resposta certa para um produto que não existe. Para ele, o caminho é devolver `null` e deixar a página chamar o `notFound()`, também do Capítulo II.

> **Nota do Autor:** um detalhe que o Capítulo VI vai aproveitar: durante a montagem de uma mesma página, chamadas de `fetch` para o mesmo endereço, com as mesmas opções, são feitas uma vez só. Se o layout e a página chamarem `buscarProduto('1')` cada um, a API recebe um pedido, não dois. Você pode chamar a função onde precisar do dado, sem inventar um jeito de passá-lo de um componente para outro só para economizar chamadas.

### 4.10 A Vitrine Até Aqui

A Vitrine deixa a lista fixa para trás e passa a buscar os produtos na API da loja. Essa API é o backend da loja: um servidor separado, com o seu próprio banco de dados, que guarda os produtos e responde a pedidos. Construí-lo não é assunto deste livro, e é exatamente assim que muitos projetos reais funcionam, com o Next.js cuidando da interface e um backend separado cuidando dos dados. A Vitrine só precisa saber o endereço dessa API, que fica num arquivo `.env.local` na raiz do projeto:

```bash
API_URL=http://localhost:4000
```

O Capítulo VI explica esse arquivo em detalhe. Por enquanto, basta saber que `process.env.API_URL` lê o valor dele, e que o Next.js precisa ser reiniciado para enxergar uma mudança ali.

> **Nota do Autor:** se quiser ver a Vitrine rodando sem backend nenhum, o pacote `json-server` sobe uma API de mentira a partir de um arquivo JSON. Com os três produtos do Capítulo II num arquivo `db.json`, dentro de uma chave `"produtos"`, o comando `npx json-server db.json --port 4000` já responde em `/produtos` e em `/produtos/1`. Serve para experimentar; não serve para produção.

\newpage

Com isso, `lib/produtos.js` troca a lista por chamadas à API, com a fornada de um minuto da seção 4.4 e o tratamento de falhas da seção 4.9:

```js
import 'server-only'

const API_URL = process.env.API_URL

export async function listarProdutos() {
  const resposta = await fetch(`${API_URL}/produtos`, {
    next: { revalidate: 60 },
  })

  if (!resposta.ok) {
    throw new Error('Falha ao buscar produtos')
  }

  return resposta.json()
}

export async function buscarProduto(id) {
  const resposta = await fetch(`${API_URL}/produtos/${id}`, {
    next: { revalidate: 60 },
  })

  if (resposta.status === 404) {
    return null
  }

  if (!resposta.ok) {
    throw new Error('Falha ao buscar o produto')
  }

  return resposta.json()
}
```

Um minuto é pouco para um catálogo, mas mantém a demonstração ágil: um produto novo aparece na loja no máximo um minuto depois de cadastrado. O Capítulo V vai mostrar como fazer ele aparecer na hora, sem esperar a fornada.

A separação do Capítulo II paga o investimento aqui. As funções mudaram por dentro, mas os nomes e o que elas devolvem continuam os mesmos. A única mudança nas páginas é que as funções agora são assíncronas: `(site)/produtos/page.js` vira `async` e ganha um `await` na frente de `listarProdutos()`, e a página do produto ganha o `await` na frente de `buscarProduto(id)`. A página do produto recebe também o `generateStaticParams` da seção 4.6, que gera no build as páginas dos produtos que já existem.

A estrutura ganha dois arquivos, nos lugares que o Capítulo II indicou para eles: onde se busca dado.

```bash
app/
  (site)/
    produtos/
      error.js
      loading.js
      page.js
      [id]/
        page.js
```

O `error.js` é o do Capítulo II, com a mensagem adaptada para "não foi possível carregar os produtos". O `loading.js` usa os blocos cinzas que a seção 2.7 mencionou, no formato aproximado da grade de produtos:

```jsx
function Bloco() {
  return <li className="h-24 animate-pulse rounded-lg bg-slate-200" />
}

export default function Carregando() {
  return (
    <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {[1, 2, 3].map((item) => (
        <Bloco key={item} />
      ))}
    </ul>
  )
}
```

Rode `npm run build` e confira a lista de rotas: `/produtos` e as três páginas de produto aparecem como estáticas, com revalidação a cada minuto. A Vitrine continua tão rápida quanto era com a lista fixa, só que agora mostra o que a loja realmente tem.

No seu projeto, as perguntas deste capítulo são as mesmas, e a resposta depende de cada dado: quanto atraso ele aceita, o que acontece quando a fonte falha, e quais páginas valem ser geradas antes da primeira visita. Anote a resposta para cada tipo de dado antes de escrever o primeiro `fetch`.

### 4.11 O Que Levar Deste Capítulo

- um Server Component busca dados com `await fetch(...)`, antes de o HTML existir, sem estado nem efeito;
- o `fetch` do servidor protege segredos, usa a rede do servidor e não sofre com CORS;
- uma página sem nada que dependa do pedido é gerada no build, e o dado fica congelado até alguém rodar o build de novo;
- `next: { revalidate: N }` refaz a página a cada N segundos sem fazer ninguém esperar; é a escolha padrão para quase todo dado;
- `cache: 'no-store'`, `cookies()`, `headers()` e `searchParams` tornam a rota dinâmica, montada a cada pedido;
- `generateStaticParams` gera no build as páginas de uma rota dinâmica;
- buscas independentes vão em `Promise.all`, não uma depois da outra;
- `Suspense` envia primeiro o que está pronto e deixa o pedaço lento chegar depois; `loading.js` é um `Suspense` da página inteira;
- `fetch` não falha sozinho com um 500: confira `resposta.ok` e lance o erro para o `error.js`.

O próximo capítulo faz o caminho inverso: em vez de buscar dados da API, envia dados para ela. É a vez do painel da Vitrine, e do formulário que cadastra produtos de verdade.
