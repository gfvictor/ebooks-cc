\newpage

# Capítulo II

\vspace{-1em}

## A Briga Pelo Estilo

\vspace{1em}

Você escreve `.botao { background: blue }`, salva, atualiza a página e o botão continua cinza. Você abre o DevTools e vê a sua regra lá, riscada com uma linha no meio, como se o navegador tivesse lido, achado graça e ignorado. Frustrado, você joga um `!important` no final e segue a vida. Três semanas depois, ninguém no time consegue mudar a cor de nada sem colocar mais um `!important`, e o CSS do projeto virou uma competição de quem grita mais alto.

O navegador não estava te ignorando. Ele estava resolvendo um conflito - duas ou mais regras querendo mandar na mesma propriedade do mesmo elemento - usando um critério de desempate que você nunca estudou. Este capítulo é esse critério: como o CSS escolhe qual regra vence, por que herança existe, e por que `!important` é quase sempre a resposta errada.

### 2.1 Os Seletores Que Você Realmente Usa

Um seletor é a parte antes das chaves: ele responde "esta regra se aplica a quais elementos?". Os que aparecem no dia a dia:

- **Tipo:** `p`, `button`, `h1` - todos os elementos daquela tag;
- **Classe:** `.card`, `.btn-primario` - todos os elementos com aquele `class`. É o que você usa 90% do tempo;
- **ID:** `#header` - o único elemento com aquele `id`. Evite estilizar por ID (explico em 2.3);
- **Atributo:** `[type="email"]`, `[disabled]` - elementos com aquele atributo;
- **Pseudo-classe:** `:hover`, `:focus`, `:first-child`, `:nth-child(2n)` - um estado ou posição do elemento;
- **Pseudo-elemento:** `::before`, `::after`, `::placeholder` - uma parte gerada ou interna do elemento.

E os **combinadores**, que ligam seletores para expressar relação de parentesco:

| Seletor       | Seleciona                                                           |
| ------------- | ------------------------------------------------------------------- |
| `.menu a`     | descendente: todo `<a>` dentro de `.menu`, em qualquer profundidade |
| `.menu > a`   | filho direto: só os `<a>` que são filhos imediatos de `.menu`       |
| `.titulo + p` | irmão adjacente: o primeiro `<p>` logo depois de `.titulo`          |
| `.titulo ~ p` | irmãos gerais: todos os `<p>` depois de `.titulo`, no mesmo pai     |

Noventa por cento do CSS bem escrito é uma classe só, sem combinador. Quanto mais longo o seletor, mais frágil ele fica - qualquer mudança no HTML pode desligá-lo.

### 2.2 A Cascata

O "C" de CSS é de _Cascading_. Quando duas regras definem a mesma propriedade para o mesmo elemento, o navegador decide o vencedor nesta ordem, parando no primeiro critério que desempata:

1. **Origem e importância:** de onde a regra vem (folha do navegador, do usuário, da sua página) e se tem `!important`. A sua folha normal ganha da folha padrão do navegador; `!important` sobe de patamar (seção 2.5);
2. **Especificidade:** o "peso" do seletor. Uma classe pesa mais que uma tag, um ID pesa mais que uma classe (seção 2.3);
3. **Ordem de aparição:** em caso de empate nos dois anteriores, **a última regra escrita vence**.

O critério 3 é o mais esquecido e o que mais salva. Se `.btn` aparece duas vezes no seu CSS com a mesma especificidade, a de baixo ganha. É por isso que a ordem dos seus arquivos e dos `@import` importa, e é por isso que colar uma regra "depois" às vezes resolve sem precisar de nenhum truque.

### 2.3 Especificidade

A especificidade é contada como três números, `(a, b, c)`, da esquerda (mais forte) para a direita:

- **a** - quantidade de IDs no seletor;
- **b** - quantidade de classes, atributos e pseudo-classes;
- **c** - quantidade de tipos (tags) e pseudo-elementos.

Compara-se da esquerda para a direita, como número de versão: `(1, 0, 0)` ganha de `(0, 5, 0)` sempre - um ID bate qualquer quantidade de classes.

| Seletor              | Especificidade |
| -------------------- | -------------- |
| `a`                  | `(0, 0, 1)`    |
| `.menu a`            | `(0, 1, 1)`    |
| `.menu a:hover`      | `(0, 2, 1)`    |
| `#nav .menu a:hover` | `(1, 2, 1)`    |

Um estilo `style="..."` no HTML (inline) vale mais que qualquer seletor de folha. O seletor universal `*` e os combinadores (`>`, `+`, `~`, espaço) valem **zero** - não entram na conta.

> **Nota do Autor:** estilizar por `#id` te dá um `(1, 0, 0)` que só outra regra com ID (ou `!important`) consegue sobrescrever. Você acha que está sendo específico; na verdade está criando um bloco de concreto que ninguém do time vai conseguir ajustar depois. Prefira classes. Deixe os IDs para âncoras de link e alvos de JavaScript.

### 2.4 Herança

Algumas propriedades passam do pai para os filhos automaticamente; a maioria não. Herdam por padrão as ligadas a texto: `color`, `font-family`, `font-size`, `font-weight`, `line-height`, `text-align`, `letter-spacing`, `visibility`. É por isso que definir `color` e `font-family` no `body` propaga para a página inteira.

**Não** herdam: `margin`, `padding`, `border`, `background`, `width`, `height`, `display`, `position` - tudo que é layout e caixa. Faria bagunça se herdasse.

Você pode forçar o comportamento com quatro palavras-chave, válidas em qualquer propriedade:

- `inherit` - pega o valor computado do pai, mesmo em propriedade que normalmente não herda;
- `initial` - volta ao valor padrão da especificação (não ao do navegador);
- `unset` - herda se a propriedade herda por natureza; senão, vira `initial`;
- `revert` - volta ao que a folha do navegador definiria.

### 2.5 `!important` e Por Que Evitar

Adicionar `!important` a uma declaração a tira da disputa normal de especificidade e a joga num patamar acima:

```css
.alerta {
  color: red !important;
}
```

Agora a única coisa que sobrescreve essa cor é **outro** `!important` com especificidade igual ou maior, escrito depois. O resultado previsível: quando duas pessoas do time usam `!important` para vencer uma da outra, começa a corrida armamentista, e o CSS perde a única mecânica que o torna gerenciável - a cascata.

O problema real que `!important` mascara é quase sempre um destes:

- **Ordem de _source_ errada:** sua regra vem antes da que você quer sobrescrever. Mova-a para depois;
- **Especificidade insuficiente:** o outro seletor é mais específico. Suba a sua um degrau (`.card .titulo` em vez de `.titulo`), sem exagero;
- **Você está lutando contra CSS de terceiros:** aí um `!important` pontual é aceitável, ou isole o componente.

Ferramentas modernas como as _cascade layers_ (`@layer`) resolvem a disputa de forma organizada, definindo qual camada de estilo vence antes mesmo de olhar a especificidade - vale conhecer quando o projeto cresce. Mas a regra de ouro continua: se você **precisa** de `!important` para um estilo seu vencer outro estilo seu, pare e conserte a causa.

### 2.6 O Que Levar Deste Capítulo

- Conflito de estilo se resolve por origem/importância, depois especificidade, depois ordem - a última regra vence no empate;
- Especificidade é `(IDs, classes, tipos)`, comparada da esquerda para a direita; `*` e combinadores valem zero;
- Prefira classes; IDs e `!important` criam estilos que ninguém consegue sobrescrever depois;
- Propriedades de texto herdam; propriedades de caixa e layout não;
- `!important` quase sempre esconde um problema de ordem ou de especificidade - conserte a causa.

No próximo capítulo a gente para de falar de qual regra vence e começa a posicionar as caixas de verdade, com o primeiro dos dois sistemas de layout modernos: o Flexbox.
