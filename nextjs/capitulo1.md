\newpage
\pagestyle{fancy}
\pagenumbering{arabic}
\setcounter{page}{1}
\fancyhead[R]{\textit{Livro III: Next.js}}

# Capítulo I

\vspace{-1em}

## O Que o React Não Decide

\vspace{1em}

React é uma biblioteca para desenhar interfaces com componentes, e só isso. Ela não tem opinião sobre qual endereço mostra qual página, de onde vêm os dados, nem em que momento o HTML é montado: no servidor, no navegador, ou uma vez só, antes de o site ir para o ar. Um projeto React "puro" precisa responder a cada uma dessas perguntas escolhendo e amarrando bibliotecas por conta própria.

Este capítulo apresenta as três respostas clássicas para a pergunta mais importante, "onde o HTML é montado?", mostra o que cada uma custa, e explica por que o Next.js não escolhe uma delas: ele deixa cada página usar a que faz sentido. No fim, você abre o projeto criado pelo `create-next-app` e entende o papel de cada arquivo.

### 1.1 As Perguntas Que Sobram

Pense em tudo o que uma aplicação web precisa além de desenhar componentes:

| Pergunta                                   | Quem responde num projeto React puro       |
| ------------------------------------------ | ------------------------------------------ |
| qual endereço mostra qual página?          | uma biblioteca de rotas, à sua escolha     |
| de onde vêm os dados, e quando?            | você, com `fetch` e muito cuidado          |
| onde o HTML é montado?                     | o navegador, por padrão                    |
| como o código vira arquivos para produção? | uma ferramenta de build, configurada à mão |
| como otimizar imagens e fontes?            | mais bibliotecas, mais configuração        |

Nenhuma dessas perguntas é difícil sozinha. O problema é que cada projeto as responde de um jeito diferente, e as respostas precisam conversar entre si. Um framework de aplicação existe para responder todas de uma vez, com convenções. Você ganha menos liberdade em troca de não precisar tomar cinquenta decisões antes de escrever a primeira página.

### 1.2 Montado no Navegador: CSR

A resposta padrão do React puro é a renderização no cliente, ou _Client-Side Rendering_ (CSR). O servidor entrega um HTML praticamente vazio, e todo o resto é trabalho do navegador:

```html
<!doctype html>
<html>
  <head>
    <script src="/assets/app.js" defer></script>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
```

Esse `<div id="root">` vazio é tudo o que chega na primeira resposta. O navegador então baixa o JavaScript, executa o React, busca os dados e só depois desenha a página dentro da `div`. Pense num serviço que entrega um kit de refeição na sua porta: ingredientes e receita. A comida é boa, mas quem cozinha é você, e até terminar, não tem nada no prato.

Na prática, isso tem três custos:

- **tela em branco:** até o JavaScript baixar e rodar, o usuário vê uma página vazia, ou um indicador de carregamento. Num celular modesto, com internet ruim, isso pode levar segundos;
- **quem não executa JavaScript não vê nada:** o robô que gera a prévia do link quando alguém compartilha seu site num aplicativo de mensagens, por exemplo, muitas vezes lê só o HTML da primeira resposta, e encontra uma `div` vazia;
- **tudo depende do aparelho de quem acessa:** o trabalho de montar a página roda no dispositivo do usuário, rápido ou lento.

CSR não é errado. Um painel interno, atrás de login, que ninguém vai compartilhar nem buscar no Google, vive muito bem assim. Mas para uma página pública, a `div` vazia cobra caro.

### 1.3 Montado no Servidor, a Cada Pedido: SSR

A alternativa é inverter o trabalho: o servidor executa os componentes, monta o HTML completo e entrega a página pronta. É a renderização no servidor, _Server-Side Rendering_ (SSR). Na analogia da comida, é o restaurante: você pede, a cozinha prepara, e o prato chega pronto na mesa.

O navegador recebe algo como:

```html
<body>
  <h1>Pedidos de hoje</h1>
  <ul>
    <li>Pedido 1042 - entregue</li>
    <li>Pedido 1043 - a caminho</li>
  </ul>
</body>
```

O conteúdo já está lá na primeira resposta. O usuário vê a página antes de qualquer JavaScript rodar, e o robô de prévia de links encontra texto de verdade.

O custo muda de lugar. Agora é o servidor que trabalha, **a cada pedido**. Se mil pessoas abrem a página ao mesmo tempo, o servidor monta a mesma página mil vezes. Para uma lista de pedidos que muda a todo instante, ou uma página que depende de quem está logado, esse trabalho é inevitável: não há como preparar antes algo que só existe no momento do pedido. Para uma página que é igual para todo mundo, é desperdício.

### 1.4 Montado Uma Vez, Antes de Tudo: SSG

A terceira resposta é montar o HTML uma única vez, no momento em que o projeto é preparado para produção, o chamado _build_, e depois só entregar o arquivo pronto a quem pedir. É a geração estática, _Static Site Generation_ (SSG). É a padaria que assa o pão de madrugada: quando o cliente chega, o pão já está na prateleira, e entregar é só esticar o braço.

Nada é mais rápido do que isso. Não há trabalho por pedido, o arquivo pode ficar guardado em servidores espalhados pelo mundo, perto de quem acessa, e o custo de servir mil ou um milhão de visitas é praticamente o mesmo.

O limite é óbvio: o pão da prateleira é o de madrugada. Se o conteúdo muda depois do build, a página estática continua mostrando a versão antiga até alguém gerar o site de novo. Uma página "Sobre nós", um artigo de blog, a documentação de um produto: tudo isso muda raramente e é perfeito para SSG. Um carrinho de compras, não.

> **Nota do Autor:** existe um meio-termo entre "gerado uma vez" e "gerado a cada pedido": gerar estático e **refazer de tempos em tempos**, por exemplo a cada hora. A padaria que assa uma fornada nova a cada hora, em vez de uma vez por dia. O Capítulo IV mostra como o Next.js faz isso.

### 1.5 Hidratação: O HTML Pronto Ganha Vida

SSR e SSG resolvem a tela em branco, mas criam uma pergunta: se o HTML chegou pronto do servidor, como o botão responde ao clique? HTML puro não tem comportamento; quem cuida do `onClick` é o JavaScript.

A resposta é a **hidratação**. O HTML chega primeiro, e o usuário já vê a página. Em seguida, o JavaScript dos componentes chega, o React percorre o HTML que já existe e prende nele os comportamentos: os cliques, os estados, as animações. Ele não redesenha a página; só a "acorda". Por isso o nome: o HTML chega seco, e o JavaScript o hidrata.

Isso tem uma consequência que vai guiar o Capítulo III inteiro. Um componente que só exibe texto, sem nenhum clique ou estado, não precisa ser hidratado. Mandar o JavaScript dele para o navegador é peso morto. Boa parte da arquitetura moderna do Next.js existe para decidir, componente por componente, quem precisa ganhar vida no navegador e quem pode ficar só como HTML.

### 1.6 Um Framework, Três Estratégias

As três estratégias, lado a lado:

| Estratégia | Onde o HTML é montado | Quando        | Serve bem para                   |
| ---------- | --------------------- | ------------- | -------------------------------- |
| CSR        | no navegador          | a cada visita | painéis internos, atrás de login |
| SSR        | no servidor           | a cada pedido | dados que mudam sempre           |
| SSG        | no servidor, no build | uma vez       | conteúdo que muda raramente      |

O ponto central é que quase nenhum site real cabe inteiro numa linha dessa tabela. Uma loja virtual tem a página institucional (SSG), a página do produto (SSG, refeita de tempos em tempos quando o preço muda), o carrinho (SSR) e o painel do vendedor (que poderia muito bem ser CSR). Escolher uma estratégia para o projeto inteiro obriga você a errar em algum lugar.

O Next.js não obriga essa escolha. Cada rota usa a estratégia que o seu conteúdo pede, e na maior parte das vezes você nem escolhe explicitamente: o framework olha o que a página faz e decide. Uma página que não depende de nada do pedido é gerada estática no build; uma página que lê algo que só existe no momento do pedido, como um cookie de login, passa a ser montada a cada pedido. Os Capítulos III e IV mostram exatamente o que faz uma página mudar de lado.

### 1.7 App Router e Pages Router

Se você procurar tutoriais de Next.js, vai encontrar dois jeitos bem diferentes de escrever o mesmo projeto, e vale entender por quê antes de se confundir.

Até 2023, o Next.js organizava as páginas numa pasta chamada `pages/`, e buscava dados com funções especiais exportadas de cada página, como `getServerSideProps` e `getStaticProps`. Esse modelo hoje se chama **Pages Router**. A partir da versão 13, o framework ganhou um modelo novo, numa pasta chamada `app/`: o **App Router**, construído sobre os Server Components do React, com layouts aninhados e busca de dados direto dentro do componente.

O App Router é o modelo recomendado para projetos novos, e é o único deste livro. O Pages Router continua existindo e funcionando, principalmente em projetos antigos, mas a maior parte das novidades do framework chega só ao App Router.

> **Cuidado:** a regra prática para filtrar tutorial é simples. Se o exemplo tem uma pasta `pages/`, ou fala em `getServerSideProps`, `getStaticProps` ou `_app.js`, ele é do Pages Router. Não está errado, mas é outro modelo, e misturar os dois no mesmo raciocínio é a receita mais rápida para não entender nenhum.

### 1.8 Abrindo o Projeto

Com o projeto criado pelo `create-next-app`, como a Metodologia deste livro sugeriu, a estrutura é mais ou menos esta:

\newpage

```bash
meu-projeto/
  app/
    favicon.ico
    globals.css
    layout.js
    page.js
  public/
  jsconfig.json
  next.config.mjs
  package.json
  postcss.config.mjs
```

A pasta `app/` é onde mora tudo o que vira rota; o próximo capítulo é inteiro sobre ela. `public/` guarda arquivos servidos do jeito que estão, como imagens e o `robots.txt`: um arquivo `public/logo.png` fica disponível em `/logo.png`. `next.config.mjs` é a configuração do framework, que você raramente vai precisar tocar no começo. `postcss.config.mjs` é o que liga o Tailwind ao build, e `jsconfig.json` define atalhos de importação, como o `@/` que aparece nos imports.

Dois arquivos merecem atenção agora. O primeiro é `app/layout.js`:

\newpage

```jsx
import './globals.css'

export const metadata = {
  title: 'Meu Projeto',
}

export default function RootLayout({ children }) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  )
}
```

É o layout raiz: a moldura que envolve todas as páginas do site, e o único lugar do projeto onde aparecem as tags `<html>` e `<body>`. Repare na primeira linha. O `globals.css` que você aprendeu a escrever no Livro II, com o `@import 'tailwindcss'` e o seu `@theme`, entra no projeto exatamente aqui. Como o layout raiz envolve tudo, importar o CSS nele vale para o site inteiro. O `children` é o lugar onde cada página vai ser encaixada, e o objeto `metadata` define o título da aba do navegador, assunto do Capítulo VI.

O segundo é `app/page.js`:

```jsx
export default function Home() {
  return <h1 className="text-2xl font-bold">Olá, Next.js</h1>
}
```

É a página da rota `/`. Um componente React comum, exportado como padrão, com as mesmas classes Tailwind de sempre. Não há registro de rota em lugar nenhum: o arquivo se chamar `page.js` e estar direto em `app/` é o que o transforma na página inicial.

### 1.9 Os Três Comandos

O `package.json` traz três scripts que você vai usar o tempo todo:

```bash
npm run dev
npm run build
npm run start
```

`npm run dev` sobe o servidor de desenvolvimento em `http://localhost:3000`, recarregando a página a cada arquivo salvo. É o modo do dia a dia, otimizado para rapidez de edição, não para desempenho.

`npm run build` prepara o projeto para produção, e é aqui que a seção 1.6 fica visível. Ao terminar, o build imprime a lista de rotas do projeto, marcando cada uma como **estática** (gerada agora, no build) ou **dinâmica** (montada a cada pedido). Olhar essa lista depois de cada mudança importante é o jeito mais direto de saber qual estratégia o Next.js escolheu para cada página.

`npm run start` roda a versão gerada pelo build, do jeito que ela vai rodar em produção.

> **Nota do Autor:** faça um teste que vale mais do que qualquer explicação desta seção. Com o `npm run dev` rodando, abra a página inicial e use a opção "Exibir código-fonte da página" do navegador. Você vai encontrar o seu `<h1>` escrito ali, no HTML que veio do servidor, e não uma `div` vazia esperando o JavaScript. É a seção 1.3 acontecendo na sua frente.

### 1.10 Quando Next.js É Demais

Com a mesma honestidade dos livros anteriores: nem todo projeto precisa de um framework de aplicação.

Uma página estática de três seções, sem dados e sem formulário, fica perfeitamente bem em HTML e CSS puros, e o Livro I te deu tudo o que ela precisa. Um painel interno, atrás de login, sem nenhuma exigência de busca ou de prévia de link, pode ser uma aplicação React simples montada no navegador, com menos peças para entender. O Next.js compensa quando o projeto mistura as linhas da tabela da seção 1.6: páginas públicas que precisam aparecer rápido e bem indexadas, ao lado de páginas dinâmicas, formulários e dados vindos de um servidor. Que, não por acaso, é a descrição da maioria dos sites e sistemas que você vai construir.

### 1.11 O Que Levar Deste Capítulo

- React desenha componentes; rotas, dados, local de renderização e build são perguntas que um framework responde por você;
- CSR monta a página no navegador: simples, mas começa com uma `div` vazia;
- SSR monta no servidor a cada pedido: conteúdo pronto, com custo por visita;
- SSG monta uma vez, no build: o mais rápido possível, mas só muda quando o site é gerado de novo;
- hidratação é o JavaScript prendendo comportamento no HTML que já chegou pronto, e só componentes interativos precisam dela;
- o Next.js escolhe a estratégia por rota, não por projeto, e a saída do `npm run build` mostra qual foi escolhida em cada uma;
- o App Router (`app/`) é o modelo atual e o único deste livro; um tutorial com `pages/` ou `getServerSideProps` é do modelo antigo;
- `app/layout.js` é a moldura de todas as páginas, e é onde o `globals.css` do Livro II entra no projeto.

O próximo capítulo abre a pasta `app/` de verdade: como pastas viram endereços, como layouts se aninham, e o que acontece quando uma página demora ou quebra.
