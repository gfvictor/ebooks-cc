\newpage

# Capítulo II

\vspace{-1em}

## Anatomia de uma Classe

\vspace{1em}

Todo utilitário que você vai escrever neste livro sai de algum lugar. Este capítulo abre esse lugar: o arquivo que liga o Tailwind ao seu projeto, o motor que ele esconde por baixo, e as três escalas (espaço, cor e tipografia) que decidem o que cada classe de fato produz.

### 2.1 O Primeiro Arquivo: `globals.css`

Um projeto Tailwind precisa de um ponto de entrada: um arquivo CSS de verdade, de onde tudo o mais nasce. Por convenção ele se chama `globals.css`, e na versão 4 do Tailwind a linha inteira de configuração cabe assim:

```css
@import 'tailwindcss';
```

Isso é tudo. Se você já viu tutorial de versões antigas do Tailwind, deve estranhar a ausência de um arquivo `tailwind.config.js` cheio de `content: [...]` e `theme: { extend: {...} }`. Esse arquivo existiu até a versão 3 e foi aposentado na versão 4: a configuração inteira migrou de JavaScript para CSS, e mora dentro do próprio `globals.css`, como este capítulo mostra a seguir.

### 2.2 O Motor Por Baixo: De Onde Vêm os Valores

A linha `@import "tailwindcss";` não traz só as regras que geram cada utilitário. Ela também traz um tema padrão inteiro, pronto, com centenas de valores já definidos - as cores, os espaçamentos, as fontes que todo `p-6` e `bg-blue-600` deste livro usa. Abra as ferramentas de desenvolvedor do navegador, inspecione qualquer elemento e suba até o `:root`: você vai encontrar dezenas de propriedades como estas, aproximadamente:

```css
@theme {
  --spacing: 0.25rem;
  --color-blue-600: oklch(54.6% 0.245 262.881);
  --font-sans: ui-sans-serif, system-ui, sans-serif;
}
```

Reconhece essa sintaxe? É exatamente o Capítulo VI do Livro I: um nome começando com `--`, um valor, e a promessa de que ela é uma custom property de verdade - viva, herdável, inspecionável, a mesma coisa que você já usava para guardar a cor de marca do seu próprio projeto. O Tailwind não inventou um sistema de tema novo. Ele pegou o mecanismo que você já sabia usar, encheu de valores prontos, e gerou uma classe utilitária para cada um.

> **Nota do Autor:** isso muda a régua de como você deveria encarar cada utilitário daqui para frente. `p-6` não é um código secreto que o Tailwind decodifica; é uma classe CSS de verdade, com uma única declaração dentro (`padding: calc(var(--spacing) * 6)`), gerada a partir de uma custom property que já existia no tema. Sempre que uma classe parecer mágica, a pergunta certa é "que custom property está por trás dela", não "que regra oculta faz isso funcionar".

### 2.3 A Escala de Espaçamento

Toda distância no Tailwind - `padding`, `margin`, `gap`, `width` - deriva de uma única custom property, `--spacing`, que por padrão vale `0.25rem`. Um utilitário como `p-6` não tem "seis" gravado em lugar nenhum: ele calcula `--spacing` vezes o número no nome.

| Utilitário | Cálculo       | Valor final |
| ---------- | ------------- | ----------- |
| `p-1`      | `0.25rem × 1` | `0.25rem`   |
| `p-2`      | `0.25rem × 2` | `0.5rem`    |
| `p-4`      | `0.25rem × 4` | `1rem`      |
| `p-6`      | `0.25rem × 6` | `1.5rem`    |
| `p-8`      | `0.25rem × 8` | `2rem`      |

O mesmo número funciona para qualquer propriedade de espaço: `gap-4`, `m-4`, `w-4` valem sempre `1rem`, porque todos multiplicam a mesma `--spacing`. Aprender essa fórmula uma vez substitui decorar uma tabela de espaçamentos inteira - e, se um projeto precisar de um grid mais apertado ou mais largo, basta redefinir `--spacing` no `@theme` do próprio projeto, e toda a escala muda de uma vez. O Capítulo V volta a esse ponto para mostrar como.

### 2.4 A Paleta de Cores

Cada cor no Tailwind não é um valor só - é uma escala de onze tons, numerados de `50` (quase branco) a `950` (quase preto), com `500` ou `600` costumando ser o tom "sólido" usado em botões e destaques:

| Tom   | Uso típico                           |
| ----- | ------------------------------------ |
| `50`  | fundo bem claro, quase imperceptível |
| `100` | fundo claro, hover sutil             |
| `600` | cor sólida - botão, link, destaque   |
| `700` | hover ou estado ativo sobre o `600`  |
| `950` | texto ou fundo bem escuro            |

O nome da classe segue sempre `propriedade-cor-tom`: `bg-blue-600` pinta o fundo, `text-blue-600` pinta o texto, `border-blue-600` pinta a borda - mesma cor, mesmo tom, prefixo diferente para dizer onde aplicar. Isso substitui a pergunta "que hexadecimal eu uso aqui" por uma pergunta muito mais fácil de responder de cabeça: "que tom, nessa escala, é claro ou escuro o suficiente para este lugar".

### 2.5 Tipografia

Texto tem três famílias de utilitário que costumam ser usadas juntas: tamanho, peso e espaçamento.

| Utilitário      | Controla                                                    |
| --------------- | ----------------------------------------------------------- |
| `text-sm`       | tamanho da fonte **e** a altura de linha proporcional a ele |
| `text-base`     | o tamanho padrão do corpo de texto                          |
| `text-lg`       | tamanho maior, com a mesma proporção de linha               |
| `font-medium`   | peso da fonte (de `thin` a `black`)                         |
| `leading-tight` | substitui a altura de linha calculada por uma menor         |
| `tracking-wide` | espaçamento entre letras                                    |

O detalhe que costuma surpreender é que `text-sm`, `text-base` e `text-lg` não mexem só no tamanho: cada um já vem com uma altura de linha combinada, pensada para ficar legível sem você precisar ajustar `line-height` à parte toda vez. Quando você precisa de uma altura de linha diferente da que veio junto, é aí que entra `leading-*`, sobrescrevendo só essa parte.

### 2.6 O Que Levar Deste Capítulo

- `globals.css` com `@import "tailwindcss";` é toda a configuração que a v4 exige - o antigo `tailwind.config.js` em JavaScript não existe mais;
- por trás de cada utilitário existe um tema padrão inteiro, escrito como custom properties dentro de um `@theme` - o mesmo mecanismo do Capítulo VI do Livro I, só que cheio de valores prontos;
- espaçamento é sempre `--spacing` vezes o número no nome da classe - aprenda a fórmula, não a tabela;
- cor segue `propriedade-cor-tom`, numa escala de `50` a `950`, com `600` como o tom sólido mais comum;
- tamanhos de texto já vêm com altura de linha proporcional embutida; `leading-*` sobrescreve quando precisar.

O próximo capítulo usa essas mesmas classes de outro jeito: prefixadas, para que só se apliquem numa tela grande, num hover, ou quando o sistema está em tema escuro.
