\newpage

# Capítulo IV

\vspace{-1em}

## Do Editor ao Mundo

\vspace{1em}

O Capítulo III usou a imagem de aprender a dirigir: o carro é a linguagem, e a parte que fica com você para sempre é saber ler o trânsito. Falta um terceiro nível, e ele não é sobre você nem sobre o carro. É tudo que existe em volta da viagem sem ser a viagem: as estradas, que alguém construiu; o combustível, que você não refinou; as placas, as regras, um posto para parar quando algo esquenta. Pegue o melhor motorista do mundo, tire a estrada, o combustível e o mapa, e ele não sai do lugar.

Programar tem esse terceiro nível. Escrever código no editor é dirigir. Em volta disso existe uma infraestrutura inteira que transforma o que você digitou em algo que de fato anda: um jeito de falar direto com o computador, um passo que converte o seu texto em comportamento, uma forma de aproveitar o que outras pessoas já construíram, um registro de tudo que o projeto já foi, e a consciência de que a sua garagem não é o mundo.

Os tutoriais quase nunca mostram essa parte. Um tutorial precisa caber num vídeo e terminar com algo na tela, então ele te leva do editor ao resultado pelo caminho mais curto e não olha para os lados. O que fica de fora é justamente o que separa quem consegue seguir um tutorial de quem consegue fazer uma coisa existir e mantê-la de pé. Este capítulo é o mapa desse entorno, e ele vale para qualquer direção que você tenha escolhido, porque essas peças são as mesmas em web, em jogos, em dados, em qualquer lugar.

### 4.1 O Editor Não É a Habilidade

A ferramenta onde você digita o código tem nome: editor, ou ambiente de desenvolvimento quando vem cheio de recursos. Um editor decente faz bem mais do que guardar texto. Ele pinta o código em cores para você enxergar a estrutura, aponta erros de digitação antes de você rodar qualquer coisa, pula direto para o lugar onde um nome foi definido, e deixa você executar o projeto sem sair dele.

Aprender a usar bem o seu editor vale a pena. Mas duas armadilhas moram aqui. A primeira é confundir o editor com a habilidade, do mesmo jeito que ninguém confunde um painel de carro caprichado com saber dirigir. A segunda é a discussão sobre qual editor é o melhor, que na internet tem temperatura de guerra religiosa. Escolha um em que você se sinta confortável, aprenda os atalhos dele, e não entre nessa briga. Trocar de editor daqui a um ano custa uma tarde, e tudo que você aprendeu de programação vai junto sem perder nada.

### 4.2 O Terminal

Você está acostumado a mandar no computador clicando: ícones, botões, menus. Existe uma forma mais antiga e mais direta de dar as mesmas ordens, que é digitá-las como texto numa janela sem gráficos chamada terminal. Você escreve o nome de uma tarefa, aperta enter, ela acontece.

Quase todo mundo trava na primeira vez. A janela não tem botão, não tem menu que revele o que é possível fazer, não perdoa um erro de digitação, e passa a impressão de que um comando errado formata o disco. Essa impressão é falsa. As ações de verdade destrutivas são poucas, específicas e difíceis de disparar por acidente. O terminal, no dia a dia, é um vocabulário pequeno: andar entre pastas, olhar o que tem dentro delas, rodar uma ferramenta, ligar o resultado de uma coisa na entrada de outra. Você pega o essencial em uma semana de uso e resolve a maior parte das tarefas com umas dez ordens.

O que muda quando você para de recuar da janela preta não é só técnica. É a sua relação com a máquina. Você deixa de ser alguém que usa os programas que aparecem na tela e vira alguém que opera o computador por baixo deles. E não dá para desviar disso por muito tempo, seja qual for a direção: servidores não têm tela para clicar, boa parte das ferramentas de programação só existe em forma de comando, e toda tarefa repetitiva mais cedo ou mais tarde vira uma linha que você guarda e reaproveita.

### 4.3 De Texto a Coisa Que Roda

O código que você escreve é um arquivo de texto. Um arquivo de texto, sozinho, não faz nada, do mesmo jeito que a planta de uma casa não abriga ninguém. Alguma coisa precisa pegar aquele texto e transformá-lo em instruções que o computador de fato executa.

As linguagens fazem isso de dois jeitos principais. Umas traduzem o texto inteiro de uma vez, antes de rodar, num passo que costuma se chamar "build" ou compilação, e no fim entregam um programa pronto para executar. Outras vão traduzindo aos poucos, linha por linha, no instante em que o programa roda. Você não precisa decorar em qual grupo a sua linguagem está. Precisa saber que esse momento existe: entre "salvei o arquivo" e "a coisa aconteceu" há um passo, e é por isso que salvar, sozinho, muitas vezes não muda nada na tela.

Há ainda um detalhe que economiza semanas de confusão. Quem faz essa tradução e execução não é o seu código; é um outro programa, instalado na sua máquina, que entende a sua linguagem. Esse programa tem uma versão, pode estar desatualizado, pode até não estar instalado. Boa parte do "funcionava ontem e hoje não" e do "no seu computador roda e no meu não" nasce aí, na diferença entre esse programa na sua máquina e na do outro. O que você escreve depende de coisas que não estão dentro dos seus arquivos, e a primeira delas é aquilo que dá vida ao seu código.

Saber que essa dependência existe é só metade do caminho. A outra metade é você conseguir dizer, com precisão, o que o seu projeto precisa para rodar: qual linguagem, qual versão dela, o que mais precisa estar instalado. Isso não é informação para guardar de cabeça, nem para redescobrir toda vez que alguém perguntar; é algo que você aprende a deixar explícito, por escrito, desde o início do projeto. Onde exatamente isso se declara é assunto para mais adiante, quando o livro chegar em repositórios; por ora, o hábito que importa é a pergunta: "o que precisa existir, além do meu código, para isso rodar em outro lugar?", respondida por escrito, não de memória.

### 4.4 Você Não Escreve Tudo

Um dia, cedo, você vai precisar de algo comum: conversar com a internet, lidar com fusos de data, desenhar um gráfico, ler um formato de arquivo. E vai descobrir que outra pessoa já resolveu isso, empacotou a solução, e deixou disponível para qualquer um usar. Cada pedaço de código de terceiros que o seu projeto inclui é uma dependência.

O primeiro instinto de muita gente é achar que usar isso é trapaça, que programador de verdade escreveria tudo. É o contrário. Ninguém que dirige pavimentou a própria estrada, refinou o próprio combustível ou forjou o motor a partir do minério; usar o que os outros construíram não é vergonha, é a única forma de alguém chegar a algum lugar. O julgamento que você desenvolve com o tempo é sobre a dose: não puxar uma biblioteca inteira para resolver três linhas, e não reescrever à mão uma categoria de problema que claramente já tem uma solução madura.

Como um projeto sério acumula dezenas ou centenas dessas peças, existe uma ferramenta, o gerenciador de dependências, que mantém a lista do que o projeto pega emprestado e busca a versão certa de cada coisa quando alguém for rodar o projeto de novo, em outra máquina. Anotar a versão exata de cada dependência não é preciosismo. Código emprestado muda: ganha recursos, corrige defeitos, e às vezes muda de comportamento de um lançamento para o outro. Sem a versão travada, o seu projeto que funcionava passa a se comportar diferente sem você ter tocado numa linha. O incômodo que sobra é o de dirigir um carro montado com peças de mil fornecedores: quase sempre está tudo bem, mas uma peça pode ser recolhida pelo fabricante, sair de linha, ou, raramente, vir adulterada. Nada disso é motivo para deixar de usar dependências. É motivo para saber quais você usa e por quê.

### 4.5 O Programa Não É Só o Código

Quando um iniciante fala "o programa", ele quase sempre quer dizer "o arquivo de código que eu escrevi". Um projeto real é mais largo que isso, do mesmo jeito que uma viagem é mais do que a linha traçada no mapa.

Junto do código vêm: os arquivos de configuração, que dizem como o programa deve se comportar em cada situação; os dados, que ele lê e grava; os recursos, como imagens, sons e fontes; a lista de dependências; e as instruções de como colocar tudo isso para rodar. Passar só o arquivo de código para outra pessoa é como passar a rota sem o carro, sem o combustível e sem os documentos: tirar qualquer uma dessas partes costuma ser suficiente para o projeto não sair do lugar na mão dela.

Alargar a sua definição de "o programa" para incluir tudo isso é, por si só, uma virada de chave. Ela muda o que você considera parte do trabalho: a configuração deixa de ser um detalhe esquecível, as instruções de execução deixam de ser algo que "está na minha cabeça", e você começa a tratar o projeto como um conjunto que precisa viajar inteiro para ser útil.

### 4.6 A História do Projeto

Um projeto não é uma foto, é uma sequência de mudanças ao longo do tempo. Quando você não guarda essa sequência, três coisas ruins acontecem, e você provavelmente já viveu a primeira delas com trabalhos de faculdade. A pasta vira um cemitério de cópias com nomes como "versão boa", "versão boa de verdade" e "essa NÃO apagar". Você não consegue dizer o que mudou entre ontem e hoje, nem apontar o momento exato em que algo que funcionava parou de funcionar. E duas pessoas não conseguem mexer no mesmo projeto sem uma passar por cima do trabalho da outra.

Controle de versão é o registro que resolve os três problemas de uma vez, e ele te dá de brinde três capacidades. Uma rede de segurança: como todo estado anterior está guardado, desfazer é sempre possível, e por isso apagar e experimentar deixam de dar medo. Um método de investigação: quando um defeito aparece, dá para percorrer a história para trás e encontrar a mudança exata que o introduziu. E um canal de comunicação: cada alteração vem com uma frase sua explicando por que ela foi feita, o que transforma a história do projeto num diário de decisões.

A ferramenta que praticamente todo mundo usa para isso se chama Git, e ela é o assunto inteiro da trilogia irmã desta coletânea, então aqui não vou repetir os comandos. O que precisa ficar deste capítulo é a atitude: desde o seu primeiro projeto de verdade, a história do projeto é uma coisa que você guarda de propósito, desde a primeira linha, e não um cuidado que dá para adotar "mais para a frente".

### O Que Fica

O seu computador tem uma configuração única: uma certa versão de cada coisa instalada, arquivos em certos lugares, ajustes que você mexeu meses atrás e esqueceu. Quando um programa funciona nessa máquina, ele está funcionando naquele conjunto exato de circunstâncias, não no mundo, e é a mesma ideia da seção 4.3, só que num raio maior: lá era sobre a linguagem e a versão certa; aqui é sobre tudo o mais que a sua máquina tem e a do outro pode não ter.

É a diferença entre dirigir nas ruas da sua cidade, decoradas, e dirigir num lugar onde você nunca esteve. Rodar o projeto de novo no seu próprio computador depois de uma formatação já mostra o que você tinha instalado sem lembrar. No computador de um colega, somam-se as diferenças entre as duas máquinas. Num servidor, some a tela, a sua sessão, os seus atalhos: é pegar uma estrada sem placas à noite. No celular de um usuário desconhecido, é dirigir num país cuja lei de trânsito você não conhece. Sempre o mesmo vão entre "aqui" e "lá", só que mais largo a cada degrau. Levar um projeto de "roda aqui" até "roda em qualquer lugar previsto" tem nome, deploy, e é assunto de um capítulo mais adiante.

Escrever código no editor é dirigir. Em volta disso: uma forma de falar direto com o computador, a noção de que outro programa transforma o seu texto em comportamento, um jeito de aproveitar o trabalho dos outros sem se enforcar nele, uma definição de "o programa" larga o suficiente para ele viajar inteiro, um registro da vida do projeto, e a consciência de que a sua garagem não é o mundo.

Nada disso é difícil, e nada disso pertence a uma linguagem. Também não envelhece: a estrada, o posto e as placas que você monta agora servem para o segundo projeto, para o décimo, e para uma troca inteira de veículo. É a diferença entre "eu consigo seguir um tutorial" e "eu consigo fazer uma coisa existir e mantê-la de pé", e essa segunda frase, no fundo, já é uma descrição de cargo.

Com a direção escolhida, o veículo definido, o trânsito lido e a estrada montada, falta uma coisa só: dirigir para algum lugar. O próximo capítulo é sobre o projeto que junta tudo isto, e sobre por que ele não pode ser mais uma calculadora.
