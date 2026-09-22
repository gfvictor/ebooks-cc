\newpage
\pagestyle{fancy}
\pagenumbering{arabic}
\setcounter{page}{1}
\fancyhead[R]{\textit{Livro II: Tailwind}}

# Capítulo I

\vspace{-1em}

## O Fim do Cemitério de Classes

\vspace{1em}

Todo projeto CSS começa pequeno e organizado. Seis meses depois, ele é um cemitério de classes: `.card`, `.card-2`, `.card-novo`, `.card-produto-v2-final`, cada uma quase igual à anterior, e ninguém tem coragem de apagar nenhuma, porque ninguém sabe ao certo onde mais ela está sendo usada. Apagar uma classe CSS é como desarmar uma bomba sem saber qual fio é qual - às vezes dá certo, às vezes quebra uma página que ninguém testou.

Este capítulo explica por que isso acontece, o que o Tailwind muda na raiz do problema, e - com a mesma honestidade que este livro promete desde o prefácio - onde essa abordagem não é a resposta certa.

### 1.1 O Problema Real: CSS Que Só Cresce

CSS tradicional cresce porque **deletar dói mais do que adicionar**. Quando você precisa de um card parecido com outro que já existe, mas com uma cor diferente, o caminho de menor resistência não é editar o card original (e arriscar quebrar todo lugar que já usa ele); é copiar, colar, e criar `.card-produto`:

```css
.card-produto {
  display: flex;
  flex-direction: column;
  padding: 1.5rem;
  border-radius: 0.5rem;
  background: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.card-usuario {
  display: flex;
  flex-direction: column;
  padding: 1.5rem;
  border-radius: 0.5rem;
  background: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  border: 2px solid #2563eb;
}
```

Repare: `.card-usuario` repete cinco das seis propriedades de `.card-produto`, só para acrescentar uma borda. Multiplique isso por dois anos de projeto e um time de cinco pessoas, e você tem um arquivo CSS de dez mil linhas onde noventa por cento do conteúdo é repetição disfarçada de nome diferente.

> **Nota do Autor:** isso não é falha de quem escreveu o código. É a consequência natural de nomear classes pelo que elas _são_ (`card-produto`) em vez de pelo que elas _fazem_ (`flex`, `p-6`, `rounded-lg`). Nomear pelo significado obriga a criar um nome novo toda vez que o significado muda um pouco.

### 1.2 O Modelo Mental do Utilitário

O Tailwind inverte a pergunta. Em vez de "que nome eu dou para este conjunto de estilos", a pergunta vira "que estilos, individualmente, eu preciso aqui". Cada utilitário faz uma coisa só, e o nome dele descreve exatamente o que ele faz. O card de produto vira:

```html
<div class="flex flex-col p-6 rounded-lg bg-white shadow-sm"></div>
```

E o card de usuário, que antes exigia uma classe nova, agora só acrescenta o que muda de fato:

```html
<div
  class="flex flex-col p-6 rounded-lg bg-white shadow-sm 
            border-2 border-blue-600"
></div>
```

Nenhuma classe nova foi inventada. O segundo card reaproveita cem por cento do primeiro e só acrescenta `border-2 border-blue-600` no fim. Não existe arquivo CSS para crescer, porque não existe CSS customizado sendo escrito - existe composição de peças que já existem, e cada peça só existe uma vez no mundo inteiro, não uma vez por projeto.

Isso não é mágica nem um substituto do CSS: por trás de cada `p-6` ou `rounded-lg` existe uma regra CSS de verdade, gerada por uma ferramenta de build que olha o seu HTML, vê quais utilitários você realmente usou, e gera só o CSS correspondente a eles - nada a mais. Você continua escrevendo CSS; só parou de dar nome a ele.

### 1.3 O Preço: HTML Mais Verboso

Nenhuma solução vem de graça. A primeira vez que você vê uma linha como

```html
<button
  class="inline-flex items-center gap-2 rounded-md bg-blue-600 px-4 py-2 
        text-sm font-medium text-white hover:bg-blue-700"
></button>
```

a reação normal é susto. É muito texto para um botão. A objeção é justa, e a resposta é: você não escreve essa linha duas vezes. Em qualquer projeto real, feito com componentes (React, Vue ou o que for), você extrai esse botão para um componente `<Botao>` uma única vez, e usa `<Botao>` no resto do projeto inteiro. A verbosidade existe num lugar só; o resto do código chama esse lugar pelo nome, exatamente como você faria com uma classe CSS tradicional bem escrita.

Sem componentização nenhuma, copiando HTML cru de página em página, a dor é real e o Tailwind fica pior de usar. O Capítulo VI deste livro é inteiro sobre como extrair esse padrão direito.

Falta uma peça para fechar o quadro: todo esse motor - o que olha o seu HTML e decide qual CSS gerar - precisa de um ponto de entrada dentro do projeto, um arquivo onde ele é ligado a tudo o mais. Esse arquivo costuma se chamar `globals.css`, e é nele que mora, literalmente, a fundação que o Livro I te ensinou a ler. O próximo capítulo abre esse arquivo.

### 1.4 Contra-Argumentos Honestos

Três objeções aparecem sempre, e merecem resposta séria, não um "confia, é melhor":

**"Isso mistura estrutura e apresentação, quebra a separação de responsabilidades."** A separação clássica sempre foi mais sobre manutenção do que sobre arquivos ficarem fisicamente separados. Uma classe `.card-produto` já acopla a estrutura HTML ao nome escolhido no CSS; mudar o visual de um card já exige tocar nos dois lugares mesmo com arquivos separados. Utilitário só torna esse acoplamento visível em vez de escondido atrás de um nome.

**"Isso é estilo inline com passos extras."** Não é. Estilo inline (`style="..."`) não tem estado: não existe jeito de escrever `style="cor azul no hover"` ou `style="essa regra só em telas grandes"`. Utilitários são classes CSS de verdade, geradas por um processo de build, e por isso suportam `:hover`, `:focus`, media queries e tema escuro - assunto do Capítulo III. Estilo inline não chega nem perto disso.

**"Trocou nome de classe por nome de utilitário - ainda é decoreba."** Parcialmente verdade, com uma diferença que importa: o vocabulário de classe tradicional muda de projeto para projeto, porque cada equipe inventa o próprio. O vocabulário de utilitário é fixo e compartilhado entre qualquer projeto que use Tailwind no mundo - uma vez decorado, ele serve para sempre, não só para este emprego.

### 1.5 Quando Utilitário Não É a Resposta

Honestidade completa: existem casos onde essa abordagem custa mais do que ajuda. Uma página de marketing com seções visualmente únicas, cada uma com um design que não se repete em lugar nenhum, ganha pouco com utilitários e sofre com HTML longo sem o benefício da repetição. O mesmo vale para uma página estática de três elementos, onde qualquer abordagem resolve igualmente bem.

> **Cuidado:** utilitário-primeiro compensa quando existe repetição e consistência para explorar - painéis, aplicativos, sistemas de design com muitos componentes parecidos. Quanto mais único e artesanal for cada pedaço de interface, menor a vantagem. Escolha a ferramenta pelo formato do problema, não por hype.

### 1.6 O Que Levar Deste Capítulo

- CSS tradicional cresce porque deletar é arriscado; copiar e renomear é o caminho de menor resistência;
- utilitário nomeia pelo que a classe faz, não pelo que ela representa - por isso não precisa de nome novo a cada variação;
- por trás de cada utilitário existe CSS de verdade, gerado só para o que você realmente usa;
- o preço é HTML mais verboso, pago uma vez por componente extraído, não por página;
- utilitário-primeiro rende mais em sistemas com repetição; rende menos em designs únicos e artesanais.

O próximo capítulo abre o capô: a escala de espaçamento, as cores e a tipografia que decidem, por baixo de cada `p-6` e `bg-blue-600`, exatamente que CSS sai dali.
