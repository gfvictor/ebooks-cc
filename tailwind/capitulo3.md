\newpage

# Capítulo III

\vspace{-1em}

## Responsividade e Estados

\vspace{1em}

Até aqui, cada utilitário produzia sempre a mesma regra CSS, valendo o tempo todo. Este capítulo apresenta os prefixos: um jeito de dizer "esse utilitário só vale numa tela grande", "só quando o mouse está em cima", ou "só quando o sistema está em tema escuro" - sem escrever uma linha de media query ou pseudo-classe à mão.

### 3.1 Prefixos Responsivos

Tailwind define cinco pontos de quebra, cada um com um prefixo curto:

| Prefixo | Largura mínima   |
| ------- | ---------------- |
| `sm:`   | `40rem` (640px)  |
| `md:`   | `48rem` (768px)  |
| `lg:`   | `64rem` (1024px) |
| `xl:`   | `80rem` (1280px) |
| `2xl:`  | `96rem` (1536px) |

Um utilitário sem prefixo vale para qualquer largura de tela. Um utilitário prefixado só entra em ação a partir daquela largura para cima:

```html
<h1 class="text-lg md:text-xl lg:text-2xl">Título</h1>
```

Lido em voz alta: "o título é `text-lg` por padrão; a partir de `md`, vira `text-xl`; a partir de `lg`, vira `text-2xl`." Repare que a base, sem prefixo, é a tela pequena, e os prefixos vão adicionando ajustes para telas maiores - exatamente a mentalidade mobile-first do Capítulo V do Livro I, só que expressa em classe em vez de `@media (min-width: ...)`.

> **Nota do Autor:** por baixo, `md:text-xl` não é mágica: o Tailwind gera uma regra `@media (min-width: 48rem) { .md\:text-xl { ... } }` de verdade. Você está escrevendo a mesma media query de sempre, só que ao lado da classe em vez de num bloco separado.

### 3.2 Estados de Interação

Os prefixos de estado seguem o mesmo princípio, mas amarrados a uma pseudo-classe em vez de a uma largura de tela:

```html
<button
  class="bg-blue-600 hover:bg-blue-700 focus:ring-2 focus:ring-blue-400 
        disabled:bg-slate-300 disabled:text-slate-500"
>
  Enviar
</button>
```

Cada prefixo corresponde a uma pseudo-classe que você já conhece do Livro I: `hover:` vira `:hover`, `focus:` vira `:focus`, `disabled:` vira `:disabled`. A vantagem de escrever assim é ter o estado normal e os estados especiais do mesmo elemento visíveis lado a lado, na mesma linha, em vez de espalhados em regras separadas num arquivo CSS.

### 3.3 Estilizar a Partir de Outro Elemento: `group` e `peer`

Às vezes o elemento que muda de aparência não é o mesmo que recebe o `hover`. Um ícone dentro de um card deveria reagir quando o mouse passa sobre o card inteiro, não só sobre o ícone. Para isso, marque o pai com a classe `group` e use `group-hover:` no filho:

```html
<div class="group rounded-lg border p-4 hover:border-blue-600">
  <span class="text-slate-400 group-hover:text-blue-600">→</span>
</div>
```

`peer` resolve o problema equivalente entre irmãos: marque um elemento com `peer`, e qualquer irmão depois dele pode reagir ao estado dele com `peer-*`. O exemplo clássico é um campo de formulário mudando a aparência do texto de ajuda ao lado:

```html
<input type="email" class="peer border" />
<p class="text-sm text-slate-500 peer-invalid:text-red-600">
    Digite um e-mail válido
</p>
```

Quando o campo fica num estado inválido, o parágrafo depois dele reage - sem uma linha de JavaScript, porque `:invalid` já é uma pseudo-classe nativa do navegador, e `peer-invalid:` só a aplica no vizinho.

### 3.4 Tema Escuro

O prefixo `dark:` aplica um utilitário só quando o tema escuro está ativo:

```html
<div class="bg-white text-slate-900 dark:bg-slate-900 dark:text-white">
    Conteúdo
</div>
```

Por padrão, "ativo" segue a preferência do sistema operacional do usuário - o mesmo `@media (prefers-color-scheme: dark)` que o Livro I já apresentou. Se o projeto precisar de um botão manual para alternar o tema, independente do sistema, é preciso trocar a estratégia dentro do próprio `globals.css`:

```css
@custom-variant dark (&:where(.dark, .dark *));
```

Com essa linha, `dark:` passa a valer sempre que existir uma classe `dark` em algum ancestral do elemento (tipicamente no `<html>`), e alternar o tema vira uma questão de adicionar ou remover essa classe via JavaScript, em vez de depender da configuração do sistema operacional.

> **Nota do Autor:** em projetos com essa alternância manual, é comum existir um componente próprio só para o botão de troca de tema, que cuida da própria lógica de ícone e estado. Raramente é dentro desse componente que você mais usa `dark:` - ele costuma ser pequeno e resolver a si mesmo. Onde `dark:` de fato se espalha é no resto da interface: cards, textos, fundos, tudo que precisa reagir à troca. Aplicar `dark:` direto no próprio componente de troca de tema, sem essa separação, é mais comum em aplicações simples e curtas, onde criar um componente dedicado só para isso seria exagero.

### 3.5 Empilhando Prefixos

Os prefixos combinam livremente. `dark:md:hover:bg-blue-700` lê-se de fora para dentro: em tema escuro, a partir da tela `md`, no hover, o fundo fica `blue-700`. Não existe uma ordem obrigatória entre eles na string da classe; o Tailwind entende qualquer combinação, e a leitura mais clara costuma ser da condição mais ampla (tema, tela) para a mais específica (o estado momentâneo, como hover).

### 3.6 O Que Levar Deste Capítulo

- prefixo de largura (`sm:` a `2xl:`) só aplica o utilitário a partir daquela largura - a base sem prefixo é sempre a tela pequena, mobile-first;
- prefixo de estado (`hover:`, `focus:`, `disabled:`) mapeia direto para a pseudo-classe CSS equivalente;
- `group`/`group-hover:` estiliza um filho a partir do estado do pai; `peer`/`peer-*` estiliza um irmão a partir do estado do outro;
- `dark:` segue a preferência do sistema por padrão; um `@custom-variant` no `globals.css` troca para alternância manual por classe;
- prefixos empilham sem ordem obrigatória, lidos da condição mais ampla para a mais específica.

O próximo capítulo tira essas classes do papel e monta layouts de verdade: Flexbox e Grid, com o Tailwind fazendo a mesma coisa que o Livro I já ensinou, só que sem escrever uma declaração CSS à parte.
