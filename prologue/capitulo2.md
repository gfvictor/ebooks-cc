\newpage

# Capítulo II

\vspace{-1em}

## A Linguagem Vem Depois

\vspace{1em}

Você fechou o capítulo anterior com uma direção na mão. Front-end, back-end, jogos, dados, o que tenha sido. E quase no mesmo instante a velha ansiedade voltou, vestindo roupa nova: _certo, mas qual linguagem, dentro dessa direção?_

O padrão que vem a seguir é sempre parecido. Você abre um vídeo de comparação. Ele te convence de uma opção nos primeiros cinco minutos e da opção contrária nos cinco seguintes. Você abre outro vídeo para desempatar. Abre um artigo de blog de 2019 que jura que uma das linguagens está morta, e um comentário embaixo dele, de 2023, dizendo que nunca esteve tão viva. Você cai num tópico de fórum onde dois desconhecidos estão sinceramente irritados um com o outro por causa de ponto e vírgula. Duas horas depois, você tem quatorze abas abertas, nenhuma linha de código escrita, e a sensação nova e desagradável de que essa decisão é enorme e você está prestes a errá-la.

Ela não é enorme. A direção que você já escolheu fez a maior parte do trabalho. O que sobra é uma lista curta - quase sempre dois ou três nomes - e alguns critérios de desempate que cabem num guardanapo. Este capítulo é sobre fazer essa escolha depressa e com a consciência tranquila. E é sobre a parte genuinamente difícil, que vem depois: não desfazer essa escolha toda semana.

### 2.1 A Lista Curta

Cada direção já chega com as linguagens que ela de fato usa. Não são duzentas. São poucas, são conhecidas, e a comunidade daquela área concorda com elas sem muito drama - o drama fica por conta de quem observa de fora.

**Front-end de web.** É JavaScript, e mais adiante TypeScript, que é o mesmo JavaScript com uma camada de tipos por cima. Aqui não existe escolha real a fazer: JavaScript é a única linguagem que o navegador executa nativamente. Tudo que você vê descrito como "framework de front-end" (os nomes mudam a cada poucos anos) roda em cima dessa base. Seu primeiro mês vai ser feito de mexer numa página, salvar, atualizar o navegador e ver o resultado na hora. Esse laço curto entre ação e efeito é o que torna o front-end tão bom de aprender.

**Back-end.** Aqui o leque é mais largo, e está tudo bem que seja. Python, JavaScript rodando no Node, Go, Java, C#, Ruby, PHP. Todos constroem sistemas de servidor sérios, todos pagam contas, todos têm vaga júnior aberta em algum lugar. Nenhum deles é uma aposta errada. A escolha entre eles quase não é sobre a linguagem, e sim sobre qual ecossistema e qual mercado você quer ter por perto nos próximos anos. Volto a isso na seção dos desempates, porque é o caso em que eles mais importam.

**Mobile.** Duas rotas. A nativa, em que você usa a linguagem oficial de cada plataforma - Swift no iOS, Kotlin no Android - e aceita manter dois códigos se quiser as duas lojas. Ou a multiplataforma, um código só para as duas, e aí normalmente é Dart com o framework Flutter, ou JavaScript com React Native. Iniciante que quer ver um app rodando no próprio celular rápido (e grátis, pois cada loja requer uma conta de desenvolvedor, que é paga) costuma se dar melhor começando pela rota multiplataforma.

**Jogos.** Aqui quem decide a linguagem é o motor, não você. Unity fala C#. Unreal fala C++, com uma camada visual para quem não quer escrever tudo. Godot, que é livre e leve, fala uma linguagem própria, GDScript, deliberadamente parecida com Python. Você escolhe o motor pelo tipo de jogo que sonha em fazer e pelo peso que a máquina aguenta, e a linguagem vem no pacote.

**Dados e aprendizado de máquina.** É Python, com folga. R (não confundir com Rust) ainda aparece em nichos de estatística acadêmica, e SQL você vai aprender de qualquer jeito porque os dados moram em bancos. Mas o centro de gravidade da área é Python: praticamente toda biblioteca, todo tutorial e todo exemplo assume que é nele que você escreve.

**Infraestrutura e DevOps.** Go e Python dividem esse espaço, com shell script permeando tudo que existe. Você vai escrever menos "programa" e mais automação: coisas que pegam um sistema e o colocam de pé sozinho.

**Sistemas e embarcado.** C continua sendo a língua franca, a que quase todo o resto foi construído em cima. Rust é a resposta moderna aos mesmos problemas, com muito menos armadilhas de memória, ao custo de uma curva de entrada mais íngreme. C++ domina onde já existe uma base de código enorme que ninguém vai reescrever.

Releia a lista. Quase toda entrada te deu uma ou duas opções, não vinte. Você não está diante de um oceano de escolhas equivalentes. Está diante de uma bifurcação, no máximo de uma escolha entre três.

### 2.2 O Mito da Melhor Primeira Linguagem

Antes dos desempates, é preciso desarmar uma pergunta que consome bastante tempo de iniciante: _qual é a melhor primeira linguagem para aprender?_

A resposta honesta é que a pergunta está malformada. Não existe uma melhor primeira linguagem no vácuo, do mesmo jeito que não existe uma melhor primeira ferramenta numa oficina - depende do que você vai construir. O que existe é a melhor primeira linguagem _para a sua direção_ e _para o seu contexto_, e essas duas coisas você já consegue responder.

As brigas que você encontra online quase sempre são entre quatro candidatas, e vale saber o que cada campo está realmente defendendo. Quem defende Python está falando de rampa suave: pouco cerimonial, código que se lê quase como inglês, resultado rápido. Quem defende JavaScript está falando de onipresença: é a linguagem da web, está em todo lugar, e você não precisa instalar nada além do navegador para começar. Quem defende C está falando de fundamento: aprender onde a memória mora e o que o computador de fato faz, sofrendo agora para não ter buracos depois. Quem defende Java ou C# está falando de estrutura e empregabilidade: linguagens que te obrigam a organizar as coisas e que sustentam uma quantidade gigante de software corporativo.

Nenhum desses campos está mentindo. Eles só estão respondendo a perguntas diferentes, e nenhuma dessas perguntas é a sua enquanto você não fixar a direção. Depois de fixar, a discussão evapora: se você vai fazer dados, a "melhor primeira linguagem" é Python e ponto; se vai fazer front-end, é JavaScript e ponto; e assim por diante. A pergunta parecia filosófica só porque estava sendo feita sem contexto.

Um detalhe que tranquiliza: a sua primeira linguagem vai te ensinar a programar, não a usar aquela linguagem. Os primeiros meses são sobre conceitos - condição, repetição, função, coleção de dados, erro - e todos eles existem em todas as linguagens. Você está usando uma linguagem específica como veículo para aprender a dirigir. O veículo importa bem menos que o fato de você estar, finalmente, dirigindo.

### 2.3 Os Três Desempates

Quando a direção te entrega mais de uma candidata de verdade (back-end é o caso clássico, mobile às vezes) três perguntas resolvem. Nenhuma delas é "qual é tecnicamente superior", porque nesse nível todas são superiores o suficiente.

**Primeiro: o mercado que você alcança.** Abra os anúncios de vaga da sua região, ou os das empresas remotas que contratam de onde você mora, e conte de verdade. Filtre por júnior. Veja quais linguagens se repetem. Se a maioria esmagadora das vagas acessíveis a você pede uma linguagem específica, é essa, mesmo que a internet inteira ache outra mais elegante. Você está aprendendo para trabalhar, não para ganhar uma discussão sobre design de linguagens.

Vale um exemplo de como esse raciocínio corre na prática. Digamos que você escolheu back-end. Abriu as vagas júnior da sua região e viu, a grosso modo, metade pedindo Java, um terço pedindo Python e o resto espalhado entre Node e C#. A leitura não é "Java ganhou". A leitura é: Java te dá o maior número de portas, mas com a rampa de entrada mais longa; Python te dá quase tantas portas com a rampa mais curta. Se você tem pressa de empregar e disposição para o cerimonial inicial, Java. Se você precisa ver progresso rápido para não desistir, Python - e você ainda alcança um terço do mercado, que é muita vaga. Nenhuma das duas leituras é errada. O que seria errado é escolher Ruby porque um artigo disse que a sintaxe é a mais bonita, e depois descobrir que a sua área tem duas vagas de Ruby por ano.

**Segundo: a rampa de entrada.** Algumas linguagens deixam você escrever algo que funciona no primeiro dia. Outras cobram uma semana de configuração e conceitos antes do primeiro "olá" na tela. Nenhuma das duas filosofias é errada - a segunda te dá hábitos de organização mais cedo - mas quando você está começando e a motivação ainda é um fio fino, ver a coisa funcionar depressa vale mais do que parece no papel. Python e JavaScript são generosas nesse quesito. Java e C# pedem mais paciência no começo e devolvem mais estrutura em troca. Go fica no meio: pouca cerimônia, mas te obriga a arrumar certas coisas desde já.

**Terceiro: onde o material de estudo da sua direção mora.** Se você escolheu dados, os tutoriais, os livros, as respostas de fórum, os exemplos de cada biblioteca - tudo vai estar em Python. Insistir em fazer ciência de dados em outra linguagem porque você gosta mais dela é assinar para fazer a versão difícil de cada passo, sozinho, sem material para consultar quando travar. Vá com a corrente da sua área. A corrente foi formada por muita gente que já resolveu os problemas que você ainda vai ter. Não tente ser "_o diferente_" por ego.

Note o que _não_ está na lista: "qual eu acho mais bonita". Gosto pessoal por sintaxe é real e legítimo, mas nos primeiros meses você ainda não tem repertório para tê-lo de forma informada. **O que parece feio ou estranho hoje vira invisível de tão familiar em três semanas de uso**. Escolher a primeira linguagem por estética é como escolher um idioma para aprender pelo formato das letras.

### 2.4 A Economia Emocional da Escolha

Vale nomear uma coisa que os guias técnicos costumam pular: essa decisão _sente-se_ muito maior do que é, e entender por quê ajuda a não travar nela.

Ela sente-se grande porque parece definir quem você vai ser. "Pessoa de Python", "dev JavaScript", "programador de sistemas" - soam como identidades, não como escolhas de ferramenta. E porque você provavelmente está entrando nisso mais velho do que gostaria, com a impressão de que todo mundo começou aos treze anos e você está correndo atrás de um trem que já saiu. Nesse estado, cada escolha parece ser a diferença entre alcançar o trem e ficar na estação para sempre.

Quase nada disso é verdade. A maioria das pessoas que trabalham com isso não começou criança; começou adulta, confusa, escolhendo mais ou menos no escuro, como você agora. E a identidade vem do que você constrói e de como você pensa, não da linguagem no seu editor - programadores experientes trocam de linguagem várias vezes na carreira, para se adaptar às mudanças do mercado, sem trocar de identidade nenhuma vez.

O jeito mais saudável de encarar a escolha é como uma _hipótese_, não um voto. Você está dizendo: "minha aposta é que essa linguagem, nessa direção, é um bom lugar para eu passar os próximos seis meses". Hipóteses são feitas para serem testadas e, se necessário, revisadas com o que você aprendeu. Ninguém vai te cobrar coerência eterna com uma decisão que você tomou sabendo pouco. O que seria um problema é nunca testar hipótese nenhuma porque você ficou paralisado escolhendo qual testar.

### 2.5 A Doença de Trocar

Escolhida a linguagem, começa o teste que realmente importa, e ele não é técnico.

Umas semanas depois de começar, você vai esbarrar num vídeo intitulado "por que larguei" a sua linguagem. Ou num post afirmando que ela está em declínio. Ou no anúncio de uma linguagem nova que promete resolver exatamente aquilo que vem te irritando esta semana. E vai sentir uma coisa muito precisa: a suspeita de que talvez você tenha escolhido errado, e de que quem foi na outra opção já está metros à sua frente.

Antes de acreditar nessa suspeita, entenda de onde vem o suprimento infinito desse tipo de conteúdo. "Por que eu larguei X" rende visualização - é conflito, é reviravolta, é a promessa de um atalho. "Continuei usando X e terminei meu projeto" não rende nada, então quase ninguém publica. O que você está vendo não é um retrato equilibrado do estado das linguagens; é uma seleção enviesada para o que prende atenção. A internet vai te mostrar mil motivos para trocar e nenhum para ficar, porque ficar não dá bom título.

E trocar cobra um preço concreto. Toda vez que você troca, a camada específica reinicia: a sintaxe que já estava virando reflexo, as bibliotecas que você já sabia onde procurar, os erros que você já sabia ler de relance, o pequeno ecossistema de ferramentas que você já tinha domado. Você volta para a casa da frustração no tabuleiro. E como trocar vem disfarçado de progresso - "estou explorando, estou me mantendo atualizado" - dá para gastar um ano inteiro girando nesse ciclo sem nunca ter levado nada até o fim.

Compare dois anos possíveis. No primeiro, você começa em Python, troca para Go no mês dois porque um vídeo te convenceu, troca para Rust no mês cinco porque o Go pareceu "sem graça", volta para Python no mês nove porque era onde tinha material, e termina o ano tendo escrito, em todas as linguagens somadas, três exercícios de tutorial. No segundo, você começa em Python, aguenta o tédio e a irritação dos meses dois a cinco, e no mês nove tem um projeto de verdade rodando, com bugs que você mesmo caçou, mais uma noção clara do que você gosta e não gosta - noção suficiente, agora sim, para escolher a próxima linguagem com critério, se quiser. O segundo ano custou mais desconforto e entregou incomparavelmente mais.

O incômodo de seguir na mesma linguagem mesmo quando ela te irrita não é sinal de que você errou a escolha. É só a aparência do processo de aprender de verdade. Aprender a primeira linguagem a fundo é difícil uma vez. Aprender três pela metade é difícil três vezes e te deixa em lugar nenhum.

### 2.6 O Que Você Não Perde

O medo de escolher errado encolhe bastante quando você entende o que de fato acontece quando um programador experiente troca de linguagem. Porque eles trocam, e a cena não tem o drama que você imagina.

O que reinicia é a superfície: as palavras reservadas, a pontuação, os nomes das funções da biblioteca padrão, os comandos das ferramentas. Isso se reaprende em semanas, porque é memorização com contexto - você já sabe que existe um jeito de percorrer uma lista, só precisa descobrir como _essa_ linguagem escreve isso.

Veja o mesmo programa mínimo - somar os números de uma lista - em duas linguagens que parecem, à distância, muito diferentes.

```python
numeros = [3, 7, 2, 8]
total = 0
for n in numeros:
    total = total + n
print(total)
```

```javascript
const numeros = [3, 7, 2, 8]
let total = 0
for (const n of numeros) {
  total = total + n
}
console.log(total)
```

Conte o que realmente mudou: alguns símbolos, uma palavra aqui e ali, chaves no lugar de indentação, o nome do comando que imprime na tela. O _gesto_ é idêntico - criar uma lista, zerar um acumulador, percorrer, somar, mostrar o resultado. Quem já entendeu esse gesto numa linguagem não está aprendendo de novo na outra; está só traduzindo.

E é isso que fica quando você troca: a capacidade de quebrar um problema em partes, de perceber quando um trecho repetido está pedindo uma função, de sentir que a estrutura de dados escolhida está errada para o caso, de ler uma mensagem de erro sem entrar em pânico, de desconfiar do próprio código no ponto certo. Nada disso está escrito em Python ou em JavaScript. Está escrito em você. A primeira semana de um programador experiente numa linguagem nova é quase toda "como se escreve, aqui, aquilo que eu já sei fazer" - e essa pergunta se responde rápido.

O Capítulo III é inteiro sobre essa camada permanente: o que exatamente ela contém e como cultivá-la de propósito. Por ora, basta saber que ela existe, que é a maior parte do que você está construindo agora, e que ela viaja com você para onde você for. Escolher uma linguagem hoje não é assinar nada em cartório. É decidir onde assentar o primeiro alicerce - e alicerce se aproveita mesmo quando o resto da casa muda.

### 2.7 Quando Trocar é Certo

Nada disso quer dizer "nunca troque de linguagem". Programadores experientes trocam, e por bons motivos. A diferença está inteira na origem da decisão.

Trocar faz sentido quando **o trabalho que você quer fazer pede outra linguagem**. Você começou em Python fazendo automação, descobriu que quer mesmo é construir jogos, e o motor que te empolga fala C#. Isso não é indecisão; é a direção se afinando, e a linguagem seguindo a direção, exatamente como neste capítulo.

Faz sentido quando **você esgotou o que aquela linguagem tinha a te ensinar naquele momento**. Você passou os seis meses, entregou o projeto, entende o que está fazendo, e há uma segunda linguagem que abre uma porta concreta - um tipo de trabalho, um jeito de pensar, uma vaga específica. Aí a troca é um passo à frente, não um recomeço.

O que esses casos têm em comum é que a decisão vem de dentro do seu trabalho, com informação que você só tem depois de ter construído algo. O caso ruim é o oposto: a decisão vem de fora, de um conteúdo feito para te dar inveja, antes de você ter construído qualquer coisa.

Um teste simples para diferenciar, quando a vontade de trocar bater: pergunte se você consegue explicar o motivo sem citar nada que viu na internet nos últimos dias. "Preciso de C# porque o Godot fala GDScript e eu quero mesmo é Unity" passa. "Ouvi dizer que Rust é o futuro" não passa. O primeiro é uma razão sua; o segundo é o eco de outra pessoa.

### 2.8 O Compromisso

O combinado, então, é este.

Escolha uma linguagem - da lista curta da sua direção, usando os três desempates se houver empate de verdade. Reserve um tempo definido para essa escolha: uma tarde, não uma quinzena. No fim da tarde, você tem uma linguagem, e a discussão está encerrada.

Fique com ela por seis meses e um projeto de verdade. Não um projeto de tutorial: um que seja seu, que resolva as suas dores ou de alguém próximo, com as propriedades que o Capítulo V vai detalhar, difícil o bastante para você bater a cabeça algumas vezes e sair do outro lado sabendo mais.

Durante esses seis meses, quando aparecer o vídeo do "larguei tal linguagem", feche. Quando lançarem a linguagem nova e reluzente, anote o nome numa lista e siga em frente - ela vai continuar existindo daqui a meio ano, e você vai estar em condições muito melhores de julgar se vale a sua atenção. Trate a curiosidade por outras linguagens como você trataria a vontade de comer besteira no meio de um treino: não é proibida para sempre, só não é para agora.

Faça, de vez em quando, uma verificação honesta consigo mesmo. Distinga "isto está difícil porque aprender é difícil" de "isto está difícil porque a ferramenta é errada para o problema". Na esmagadora maioria das vezes, nos primeiros meses, é a primeira, e continua sendo até nào seja mais. Se for genuinamente a segunda, você vai conseguir explicar o porquê em uma frase, sem apelar para nada que leu online. Até lá, o desconforto é só o preço da entrada.

**A jornada de verdade, aquela da epígrafe, começou quando você parou de vagar e escolheu uma direção**. Escolher a linguagem é o segundo passo na mesma caminhada - menor do que o primeiro, reversível, e bem menos importante do que a indústria de conteúdo precisa que você acredite. Dado esse passo, o chão para de escorregar debaixo dos seus pés. E aí, com um rumo definido e uma ferramenta na mão, dá para começar a olhar para o que você está de fato construindo quando aprende a programar - a parte que nenhuma troca de linguagem, agora ou daqui a dez anos, tira de você. É disso que trata o próximo capítulo.
