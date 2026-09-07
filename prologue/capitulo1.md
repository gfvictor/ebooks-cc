\newpage
\pagestyle{fancy}
\pagenumbering{arabic}
\setcounter{page}{1}
\fancyhead[R]{\textit{Prólogo}}

# Capítulo I

\vspace{-1em}

## Antes da Jornada

\vspace{1em}

A primeira pergunta que quase todo iniciante faz é "qual linguagem eu devo aprender?". É a pergunta errada, e ela custa meses. Perguntar a linguagem primeiro é como escolher o veículo antes de decidir se você vai atravessar uma cidade, um oceano ou um deserto. A escolha do veículo vem depois da escolha da viagem.

Este capítulo é sobre a viagem: o território do software, o punhado de direções que dá para seguir, e como escolher uma sem passar um ano paralisado na entrada.

### 1.1 A Pergunta Errada

Linguagem de programação é ferramenta, e ferramenta é moldada pelo problema que ela resolve. Peça a três linguagens para escrever "olá" na tela:

```python
print("olá")
```

Em JavaScript, isso é `console.log("olá")`; em Go, `fmt.Println("olá")`. Muda o nome da função, alguns símbolos, uma palavra aqui e ali - não muda a ideia. Nos primeiros meses, é assim com quase tudo que você vai aprender: condição, repetição, função, lista. Os conceitos são os mesmos; a "roupa" que cada linguagem veste neles é diferente.

Quando você pergunta a linguagem antes do rumo, escolhe pelo motivo errado - a que estava na moda naquele mês, a que um influenciador jurou ser a melhor, a que apareceu primeiro na busca. Aí a curiosidade acaba em três semanas, você troca, recomeça do zero, e repete. Esse ciclo tem nome informal: **tutorial hell**, e o Capítulo IX inteiro é sobre sair dele. A raiz, quase sempre, é não ter escolhido para onde ir.

A pergunta certa vem antes: **o que eu quero ver funcionando?**

### 1.2 O Território

O software se divide, a grosso modo, em algumas direções. Nenhuma é uma prisão - as fronteiras são sutis e ninguém fica preso a uma para sempre -, mas você **começa** por uma. Um panorama honesto:

- **Front-end (interfaces web):** o que o usuário vê e clica no navegador. Começa em HTML, CSS e JavaScript, depois um framework. O retorno é visual e imediato - você mexe, atualiza, vê;
- **Back-end (servidores e APIs):** a lógica e os dados por trás do que o usuário vê; o que responde quando o aplicativo pede alguma coisa. Uma linguagem de propósito geral, um banco de dados, e um jeito de expor isso pela rede;
- **Mobile:** aplicativos de celular, para Android e iOS. Nativo (a linguagem de cada plataforma) ou multiplataforma (um código para as duas). O ciclo de testar e publicar na loja é mais pesado que o da web;
- **Jogos:** um motor (_engine_), um laço de renderização, física, arte, som. Matemática e desempenho aparecem cedo, e a barra de "parece um jogo de verdade" é alta;
- **Dados e aprendizado de máquina:** extrair resposta de dados - estatística, planilhas turbinadas, _notebooks_ (como Jupyter Notebooks, em Python), modelos que preveem. Menos "aplicativo", mais "pergunta, dado, gráfico ou modelo";
- **Infraestrutura e DevOps:** os canos por onde código, dados e _deploys_ passam. Automação, nuvem, _pipelines_, monitoramento. Pouca interface, muito sistema;
- **Sistemas e embarcado:** perto do metal - sistemas operacionais, drivers, dispositivos com pouca memória. Linguagens sem rede de segurança, onde um erro trava a máquina inteira.

Você não precisa entender todas agora. Precisa reconhecer qual delas te faz pensar "é isso que eu quero fazer".

### 1.3 Como Escolher a Direção

A escolha não é sobre qual direção paga mais ou qual está na moda neste trimestre. São três perguntas honestas:

1. **O que te faz abrir o computador por vontade própria num sábado?** Você já gravita para sites, jogos, planilhas, aparelhos, automações? O que você gosta de _consumir_ é uma pista forte do que vai gostar de _construir_;
2. **Que tipo de resultado te dá satisfação?** Algo visual que você mostra para alguém na hora? Um sistema que roda sozinho e você observa funcionar? Uma resposta certa arrancada de uma bagunça de dados? Cada direção entrega um desses prazeres mais que os outros;
3. **Onde você quer trabalhar, e o que esse mercado contrata de verdade?** O mercado da sua cidade, ou o remoto que você consegue acessar, tem vagas nessa direção? Não precisa ser a mais quente do mundo - precisa existir.

A resposta não é para a vida toda. É para os próximos seis a doze meses. Tempo suficiente para a direção render e curto o bastante para não ser um casamento.

### 1.4 O Custo de Não Escolher

Ficar "estudando um pouco de tudo" parece a atitude prudente. É o caminho mais lento que existe.

Cada vez que você troca de direção, o progresso específico - a linguagem, as ferramentas, o ecossistema daquela área - reinicia quase do zero. Sobra só o que era transferível (que você verá no Capítulo III), e a ironia é que você aprende o transferível **mais rápido** quando tem um alvo concreto na frente, não quando estuda no vácuo.

Cavar dez poços de um metro nunca te dá água. Um poço de dez metros dá. Escolher uma direção é decidir onde cavar fundo.

### 1.5 O Que Levar Deste Capítulo

- "Qual linguagem" é uma pergunta que vem _depois_; "o que eu quero ver funcionando" vem primeiro;
- o território tem cerca de sete direções; escolha **uma** para começar, sabendo que as fronteiras podem ser quebradas e ninguém fica preso;
- escolha por interesse genuíno, pelo tipo de resultado que te satisfaz, e pela realidade do mercado que você alcança - para os próximos seis a doze meses, não para sempre;
- estudar tudo ao mesmo tempo é o caminho mais lento: um poço fundo, não dez rasos.

Você escolheu um rumo. No próximo capítulo, a linguagem quase se escolhe sozinha a partir dele - e a gente fala de como parar de trocar de linguagem toda semana.
