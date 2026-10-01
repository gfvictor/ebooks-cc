\newpage

# Capítulo V

\vspace{-1em}

## Enviando Dados: Server Actions

\vspace{1em}

O Capítulo IV ensinou o caminho de ida: o servidor busca os dados e entrega a página pronta. Este capítulo faz o caminho de volta. Um formulário preenchido no navegador precisa chegar ao servidor, ser conferido, salvo, e a página precisa mostrar o resultado sem exibir uma versão velha guardada no cache.

Durante muito tempo, esse caminho exigia três peças separadas: uma rota de API no servidor para receber os dados, um `fetch` no navegador para enviá-los, e código à mão para tratar o carregamento, o erro e a resposta. O App Router encurta tudo isso com as **Server Actions**: funções que moram no servidor e que um formulário chama diretamente, como se fossem locais.

### 5.1 Uma Função Que Mora no Servidor

A **Nota do Autor** da seção 3.4 avisou que existia uma diretiva `'use server'`, e que ela não servia para marcar Server Components. É aqui que ela entra. Uma função `async` com `'use server'` na primeira linha vira uma Server Action:

```jsx
export default function ContatoPage() {
  async function enviar(formData) {
    'use server'

    const email = formData.get('email')
    console.log('Novo contato:', email)
  }

  return (
    <form action={enviar} className="flex gap-2 p-6">
      <input name="email" type="email" className="rounded border p-2" />
      <button className="rounded border px-4">Enviar</button>
    </form>
  )
}
```

Repare no `action={enviar}`. No HTML tradicional, o atributo `action` de um formulário recebe um endereço, para onde os dados vão. Aqui, ele recebe uma função. Quando o formulário é enviado, o Next.js empacota os campos num objeto `FormData`, manda para o servidor, e chama `enviar` lá, com esse objeto como argumento. O `console.log` aparece no terminal, não no navegador: a função nunca saiu do servidor. `formData.get('email')` lê o valor do campo pelo atributo `name` do `<input>`. É por isso que todo campo do formulário precisa de um `name`: sem ele, o valor simplesmente não é enviado.

Há um detalhe que parece pequeno e não é. Esse formulário funciona **mesmo antes de o JavaScript da página carregar**, e até com o JavaScript desligado. Por baixo, o Next.js gera um formulário HTML comum, que o navegador sabe enviar sozinho desde os anos 1990. Quando o JavaScript chega, ele assume o envio e evita o recarregamento da página; enquanto não chega, o formulário continua funcionando do jeito antigo. Num celular lento, isso é a diferença entre um botão que funciona e um botão que não faz nada nos primeiros segundos.

### 5.2 Depois de Salvar: `revalidatePath` e `redirect`

Salvar o dado é só metade do trabalho. A outra metade é a página mostrar o resultado, e aqui o Capítulo IV cobra o seu preço. A lista de produtos da Vitrine é uma fornada de um minuto: se o dono cadastra um produto, a lista guardada continua sem ele até o minuto acabar.

`revalidatePath` resolve isso. Ele descarta, na hora, a versão guardada de um endereço, sem esperar o tempo da fornada:

```js
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

export async function cadastrar(formData) {
  'use server'

  await salvarNaApi(formData)

  revalidatePath('/produtos')
  redirect('/produtos')
}
```

Depois do `revalidatePath('/produtos')`, o próximo visitante de `/produtos` recebe uma página montada com os dados novos. A padaria jogou fora a fornada antiga no momento em que chegou o pão novo, em vez de esperar o horário.

`redirect` faz o navegador ir para outro endereço quando a ação termina, o que é útil depois de um cadastro: mostrar a lista, com o item recém-criado lá dentro.

> **Cuidado:** `redirect` funciona lançando um erro especial, que o Next.js intercepta para fazer o redirecionamento. Se você chamá-lo dentro de um `try`, o `catch` engole esse erro, e o redirecionamento nunca acontece. Chame `redirect` sempre por último, fora de qualquer `try...catch`.

### 5.3 Ações num Arquivo Próprio

Escrever a ação dentro do componente, como na seção 5.1, funciona para Server Components. Mas uma Server Action também pode ser chamada de um Client Component, e um Client Component não pode conter código de servidor. A solução é mover as ações para um arquivo próprio, com `'use server'` no topo:

```js
'use server'

export async function salvarProduto(formData) {
  console.log('Salvando', formData.get('nome'))
}

export async function removerProduto(id) {
  console.log('Removendo', id)
}
```

Com a diretiva no topo do arquivo, toda função exportada por ele vira uma Server Action. Qualquer componente, de servidor ou de cliente, pode importá-las normalmente. Quando um Client Component importa uma delas, o código da função não vai para o navegador; vai só uma referência, uma espécie de endereço que diz ao Next.js qual função chamar no servidor. É a exceção que a seção 3.7 prometeu: funções não atravessam a fronteira, mas Server Actions atravessam como referência.

Uma regra do arquivo: como tudo o que ele exporta vira ação, ele só pode exportar funções `async`. Constantes, objetos e funções auxiliares podem existir dentro dele, desde que não sejam exportados.

### 5.4 Nunca Confie no Formulário

O HTML já oferece validação: `required` impede o envio de um campo vazio, `type="email"` exige um e-mail com cara de e-mail, `min="1"` barra números menores que um. Use, porque melhora a experiência de quem preenche. Mas não confunda isso com segurança.

Toda validação do navegador pode ser contornada em segundos. Basta abrir as ferramentas de desenvolvedor e apagar o `required`, ou enviar os dados sem formulário nenhum. A seção 5.7 volta a esse ponto com mais força. Por enquanto, a regra é: **o servidor confere tudo de novo, sempre**, como se o formulário não tivesse validado nada.

Conferir campo por campo com `if` fica longo e repetitivo rápido. A biblioteca Zod, instalada com `npm install zod`, permite descrever o formato esperado dos dados uma vez só, e depois conferir qualquer objeto contra essa descrição:

```js
import { z } from 'zod'

const esquemaProduto = z.object({
  nome: z.string().trim().min(3, 'Use pelo menos 3 letras'),
  preco: z.coerce.number().positive('Informe um preço maior que zero'),
  descricao: z.string().trim().max(300, 'Use no máximo 300 letras'),
})
```

Cada linha é uma regra legível: o nome é um texto, sem espaços nas pontas, com pelo menos três letras; o preço é um número positivo; a descrição tem no máximo trezentas letras. O `coerce` do preço existe porque tudo o que vem de um formulário chega como texto, até o que foi digitado num campo `type="number"`, e ele converte `'350'` em `350` antes de conferir.

Para validar, `safeParse`:

```js
const resultado = esquemaProduto.safeParse(Object.fromEntries(formData))

if (!resultado.success) {
  const erros = z.flattenError(resultado.error).fieldErrors
}
```

`Object.fromEntries(formData)` transforma os campos do formulário num objeto comum, `{ nome: '...', preco: '...' }`. `safeParse` confere esse objeto contra o esquema e nunca lança erro: devolve `success` verdadeiro, com os dados limpos e convertidos em `resultado.data`, ou falso, com os problemas em `resultado.error`. `z.flattenError(...).fieldErrors` organiza esses problemas por campo, no formato `{ nome: ['Use pelo menos 3 letras'] }`, pronto para mostrar ao lado de cada `<input>`.

> **Nota do Autor:** isto é só o mínimo de Zod que uma Server Action precisa. O Livro IV dedica um capítulo inteiro a ele, porque validar dados que vêm de fora, sejam de um formulário, de uma API ou de um arquivo, é um dos pontos mais importantes de qualquer sistema, e um dos que o TypeScript sozinho não resolve.

### 5.5 Devolvendo o Resultado: `useActionState`

Validar no servidor só serve se o usuário ficar sabendo do que deu errado. Para isso, a ação precisa devolver alguma coisa, e o formulário precisa exibir o que voltou. O React oferece um hook para exatamente isso, `useActionState`, usado num Client Component:

```jsx
const [estado, acao, pendente] = useActionState(salvarProduto, {})
```

Ele recebe a Server Action e um estado inicial, aqui um objeto vazio, e devolve três coisas: o `estado`, que é o que a ação devolveu da última vez; a `acao`, uma versão da Server Action que vai no `action` do formulário; e `pendente`, verdadeiro enquanto o envio está em andamento, útil para desabilitar o botão e evitar cliques duplos.

Com `useActionState`, a assinatura da Server Action muda: ela passa a receber o estado anterior como primeiro argumento, e o `FormData` como segundo. E o que ela devolver vira o novo `estado`:

```js
export async function salvarProduto(estadoAnterior, formData) {
  const valores = Object.fromEntries(formData)
  const resultado = esquemaProduto.safeParse(valores)

  if (!resultado.success) {
    const erros = z.flattenError(resultado.error).fieldErrors

    return { valores, erros }
  }

  return { sucesso: true }
}
```

> **Cuidado:** depois que uma ação termina, o React limpa os campos do formulário automaticamente. No sucesso, é o que você quer. No erro, é desastroso: o usuário erra uma letra no nome e perde tudo o que digitou nos outros campos. É por isso que a ação devolve `valores` junto com `erros`: o formulário usa esses valores como `defaultValue` de cada campo, e o que foi digitado volta para o lugar.

### 5.6 Passando Argumentos: `bind`

Uma ação de excluir precisa saber **qual** produto excluir, e essa informação não vem de um campo digitado: vem da página, que sabe o `id` de cada item da lista. O jeito de amarrar um valor a uma Server Action é o `bind` do JavaScript:

```jsx
<form action={removerProduto.bind(null, produto.id)}>
  <button className="text-sm text-red-600">Excluir</button>
</form>
```

`removerProduto.bind(null, produto.id)` cria uma nova versão da função com o primeiro argumento já preenchido. O `null` é um detalhe técnico do `bind`, que pode ser ignorado aqui. Quando esse formulário é enviado, o servidor chama `removerProduto('2')`, com o `id` certo, e o `FormData` vem depois, como segundo argumento, sem atrapalhar.

O valor amarrado atravessa a fronteira até o navegador e volta, então segue a regra da seção 3.7: só dados simples, como textos e números. Um `id` é o caso perfeito.

### 5.7 Toda Action É uma Porta Aberta

Este é o ponto mais importante do capítulo, e o mais fácil de esquecer. Uma Server Action parece uma função comum, chamada só pelo seu formulário. Não é. Por baixo, ela é um endereço no servidor que recebe pedidos, e **qualquer pessoa** que descubra como chamá-la pode chamá-la, com os dados que quiser, sem passar pelo seu formulário nem pela sua página.

Isso tem duas consequências diretas:

- **validação no servidor não é opcional:** a seção 5.4 não era excesso de zelo. Sem ela, um preço negativo ou um nome com dez mil caracteres entra direto na API da loja;
- **autorização também mora dentro da ação:** esconder o botão "Excluir" de quem não é dono da loja não impede ninguém de chamar `removerProduto`. A pergunta "quem está pedindo isso tem permissão?" precisa ser feita dentro da própria ação, a cada chamada.

O Next.js dificulta a vida de quem tenta chamar uma ação de fora, com endereços difíceis de adivinhar e outras proteções, mas nenhuma delas substitui as duas verificações acima.

> **Nota do Autor:** a Vitrine, de propósito, não tem login. Autenticação é um assunto grande, que merece mais espaço do que caberia aqui, e a demonstração ficaria soterrada por ele. Isso significa que o painel da Vitrine, publicado do jeito que está, permitiria a qualquer visitante cadastrar e excluir produtos. Num projeto de verdade, incluindo o seu, o painel precisa de login, e cada ação precisa conferir se quem chama está logado e tem permissão. A documentação oficial do Next.js tem um guia de autenticação que é o ponto de partida certo.

### 5.8 A Vitrine Até Aqui

O painel da Vitrine ganha vida: um formulário para cadastrar produtos, e uma lista com botão de excluir. O link "Produtos" da barra lateral, que desde o Capítulo II levava ao "não encontrado", finalmente aponta para uma página que existe.

\newpage

```bash
vitrine/
  app/
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

Primeiro, `lib/produtos.js` ganha as duas funções que enviam dados para a API da loja, com o mesmo cuidado de conferir `resposta.ok` do Capítulo IV:

```js
export async function criarProduto(dados) {
  const resposta = await fetch(`${API_URL}/produtos`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(dados),
  })

  if (!resposta.ok) {
    throw new Error('Falha ao cadastrar o produto')
  }
}

export async function excluirProduto(id) {
  const resposta = await fetch(`${API_URL}/produtos/${id}`, {
    method: 'DELETE',
  })

  if (!resposta.ok) {
    throw new Error('Falha ao excluir o produto')
  }
}
```

`method` diz à API o que fazer: `POST` cria, `DELETE` remove. O `body` leva os dados do produto convertidos em texto JSON, e o cabeçalho `Content-Type` avisa à API que é isso que está chegando.

\newpage

As Server Actions ficam em `lib/acoes.js`, juntando tudo o que o capítulo mostrou:

```js
'use server'

import { revalidatePath } from 'next/cache'
import { z } from 'zod'
import { criarProduto, excluirProduto } from '@/lib/produtos'

const esquemaProduto = z.object({
  nome: z.string().trim().min(3, 'Use pelo menos 3 letras'),
  preco: z.coerce.number().positive('Informe um preço maior que zero'),
  descricao: z.string().trim().max(300, 'Use no máximo 300 letras'),
})

function atualizarLoja() {
  revalidatePath('/produtos')
  revalidatePath('/produtos/[id]', 'page')
  revalidatePath('/painel/produtos')
}

export async function salvarProduto(estadoAnterior, formData) {
  const valores = Object.fromEntries(formData)
  const resultado = esquemaProduto.safeParse(valores)

  if (!resultado.success) {
    const erros = z.flattenError(resultado.error).fieldErrors

    return { valores, erros }
  }

  await criarProduto(resultado.data)
  atualizarLoja()

  return { sucesso: true }
}

export async function removerProduto(id) {
  await excluirProduto(id)
  atualizarLoja()
}
```

A função `atualizarLoja` descarta as três versões guardadas que mostram produtos: a lista pública, todas as páginas de produto e a lista do painel. Para as páginas de produto, o caminho é escrito com os colchetes, `'/produtos/[id]'`, e o segundo argumento, `'page'`, diz que todas as páginas daquela rota dinâmica devem ser descartadas, e não um endereço só. Como ela não é exportada, a regra da seção 5.3 continua respeitada.

O formulário é um Client Component, porque usa `useActionState`. Para não repetir o mesmo trio de rótulo, campo e mensagem de erro três vezes, ele tem um componente local, `Campo`:

```jsx
'use client'

import { useActionState } from 'react'
import { salvarProduto } from '@/lib/acoes'

function Campo({ rotulo, name, estado, ...props }) {
  const erros = estado.erros?.[name]

  return (
    <label className="flex flex-col gap-1">
      {rotulo}
      <input
        name={name}
        defaultValue={estado.valores?.[name]}
        className="rounded border p-2"
        {...props}
      />
      {erros && <p className="text-sm text-red-600">{erros[0]}</p>}
    </label>
  )
}

export default function FormularioProduto() {
  const [estado, acao, pendente] = useActionState(salvarProduto, {})

  return (
    <form action={acao} className="flex max-w-md flex-col gap-3">
      <Campo rotulo="Nome" name="nome" estado={estado} required />
      <Campo
        rotulo="Preço"
        name="preco"
        type="number"
        min="1"
        step="0.01"
        estado={estado}
        required
      />
      <Campo rotulo="Descrição" name="descricao" estado={estado} />
      {estado.sucesso && <p>Produto cadastrado.</p>}
      <button
        type="submit"
        disabled={pendente}
        className="rounded bg-black p-2 text-white disabled:opacity-50"
      >
        {pendente ? 'Salvando...' : 'Cadastrar produto'}
      </button>
    </form>
  )
}
```

O `?.` em `estado.erros?.[name]` é o encadeamento opcional do JavaScript: se `estado.erros` não existir, como na primeira vez que o formulário aparece, a expressão vale `undefined` em vez de quebrar. Os `required`, o `min` e o `step` são a validação do navegador da seção 5.4, que o Zod repete no servidor, e o `disabled:opacity-50` é o prefixo de estado do Capítulo III do Livro II, deixando o botão apagado enquanto `pendente` for verdadeiro.

Por fim, a página `(app)/painel/produtos/page.js` junta o formulário e a lista, com um botão de excluir para cada produto:

```jsx
import FormularioProduto from '@/components/formulario-produto'
import { listarProdutos } from '@/lib/produtos'
import { removerProduto } from '@/lib/acoes'

export default async function PainelProdutosPage() {
  const produtos = await listarProdutos()

  return (
    <div className="flex flex-col gap-8">
      <FormularioProduto />
      <ul className="flex flex-col gap-2">
        {produtos.map((produto) => (
          <li key={produto.id} className="flex justify-between">
            {produto.nome}
            <form action={removerProduto.bind(null, produto.id)}>
              <button className="text-sm text-red-600">Excluir</button>
            </form>
          </li>
        ))}
      </ul>
    </div>
  )
}
```

A página é um Server Component que busca os produtos como qualquer outra; só o `FormularioProduto` cruza para o navegador. Cada formulário de exclusão continua sendo HTML comum, com a ação amarrada ao `id` do produto. Cadastre um produto, abra `/produtos` numa outra aba, e ele já está lá, sem esperar o minuto da fornada.

No seu projeto, as perguntas deste capítulo são: quais dados o usuário cria, altera ou remove; quais regras cada campo precisa cumprir no servidor; quais páginas mostram esses dados e precisam ser revalidadas depois de cada mudança; e quem tem permissão para fazer cada uma dessas coisas. A última pergunta é a que a Vitrine deixou de propósito sem resposta, e a que o seu projeto não pode deixar.

### 5.9 O Que Levar Deste Capítulo

- uma função `async` com `'use server'` vira uma Server Action, chamada direto pelo `action` de um formulário, que recebe os campos num `FormData`;
- formulários com Server Actions funcionam até antes de o JavaScript carregar;
- `revalidatePath` descarta na hora a versão guardada de um endereço; `redirect` vai sempre por último, fora de `try...catch`;
- um arquivo com `'use server'` no topo transforma todas as suas exportações em ações, que Client Components podem importar como referência;
- validação do navegador é conforto, não segurança: o servidor confere tudo de novo, e o Zod descreve as regras uma vez só;
- `useActionState` devolve o resultado da ação ao formulário e informa se o envio está pendente; devolva os valores junto com os erros para não apagar o que foi digitado;
- `bind` amarra argumentos, como um `id`, a uma Server Action;
- toda Server Action é uma porta aberta: valide os dados e confira a permissão dentro dela, a cada chamada.

O próximo capítulo fecha o livro levando a Vitrine para fora do seu computador: título e prévia de compartilhamento, imagens e fontes otimizadas, variáveis de ambiente de verdade, e a publicação.
