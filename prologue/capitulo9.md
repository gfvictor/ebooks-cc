\newpage

# Capítulo IX

\vspace{-1em}

## Não Está Pronto Até Alguém Rodar

\vspace{1em}

Você já escreveu o projeto. As seis propriedades do Capítulo V estão lá. O modelo de dados do Capítulo VI aguenta o mundo real. Ele conversa com sistemas de fora, do jeito descrito no Capítulo VII, e você já sabe, pelo Capítulo VIII, que não precisa se preocupar com escala ainda. Depois de tanto capítulo, é tentador achar que o trabalho terminou. Não terminou. Ele só está pronto para a única prova que de fato importa, e essa prova ainda não aconteceu: alguém que não seja você abrir esse projeto e usá-lo sem você do lado explicando nada.

Este capítulo é sobre a distância entre "funciona na minha máquina" e "está pronto", e sobre o punhado de hábitos que fecham essa distância.

### 9.1 O Que "Pronto" Realmente Significa

A definição de pronto que a maioria dos iniciantes usa, sem perceber, é "eu consigo rodar". É uma definição confortável e enganosa, porque você carrega, sem saber que carrega, uma dúzia de coisas que fazem o projeto funcionar na sua mesa: a versão certa do que ele precisa já instalada há meses, um arquivo de configuração que você criou numa terça-feira qualquer e nunca mais olhou, uma pasta específica onde você sempre guarda esse tipo de projeto, uma senha que você digitou uma vez e o seu computador lembra por você.

Nenhuma dessas coisas está escrita em lugar nenhum. Elas moram na sua cabeça e no histórico da sua máquina, e é exatamente por isso que "funciona para mim" é a frase mais enganosa que existe em programação: ela é sincera e, ao mesmo tempo, quase sempre falsa para qualquer outra pessoa. A definição que interessa é outra: pronto é quando alguém que nunca viu o seu projeto consegue colocá-lo para rodar usando só o que está escrito, sem perguntar nada a você. Entre essas duas definições existe uma lista de tarefas que ninguém ensina num tutorial, porque tutorial termina exatamente no ponto em que o professor já tem tudo configurado de antemão. Esta lista é o assunto do resto do capítulo.

### 9.2 Empacotar: Tirar a Cópia da Sua Mesa

O primeiro passo é transformar o projeto, do jeito solto que ele vive no seu editor, numa forma que possa viajar: um pacote instalável, um aplicativo publicado, um endereço que responde na internet, um executável que roda sozinho. O nome exato dessa etapa muda conforme a direção que você escolheu no Capítulo I, e por isso este livro não ensina o passo a passo dela; um site publica de um jeito, um aplicativo de celular de outro, um jogo de outro ainda.

O que é universal é a existência da etapa, e o que ela faz de fato: pega tudo que o seu projeto precisa para existir, código, dependências, recursos, e reúne isso numa forma fechada que não depende mais do seu editor aberto, das suas ferramentas de desenvolvimento instaladas, do seu jeito específico de rodar as coisas. Muito do que ajuda você a programar todo santo dia, os avisos de depuração, os atalhos de desenvolvimento, as portas abertas só para teste, não deveria viajar junto nessa forma final; empacotar bem também é saber o que deixar para trás.

Pular essa etapa e considerar o projeto pronto porque ele roda no seu ambiente de desenvolvimento é como terminar de cozinhar e nunca tirar o prato do fogão para servir. A comida existe, está pronta, mas ninguém além de quem cozinhou consegue chegar perto dela.

### 9.3 Um Endereço Que Não É a Sua Mesa

Depois de empacotado, o projeto precisa de um lugar para morar que não seja o seu computador pessoal, ligado só quando você está usando ele. Um servidor que fica ligado, uma loja de aplicativos, um serviço de hospedagem: o nome muda, o papel é sempre o mesmo, dar ao projeto um endereço estável que continua existindo mesmo quando o seu notebook está desligado, guardado na mochila, sem internet.

Essa permanência quase sempre custa algo, mesmo que pequeno: existem opções gratuitas para projeto de aprendizado, mas em algum ponto da escala alguém paga pela máquina que fica ligada vinte e quatro horas por dia esperando alguém acessar. Não é um detalhe menor para adiar para sempre; é parte da conta de ter algo de verdade no ar, do mesmo jeito que manter um carro rodando custa combustível, e ninguém acha isso surpreendente.

Essa é a diferença mais concreta entre um projeto de portfólio de verdade e um projeto que só existe enquanto está aberto na tela de quem fez. Um link que você manda para alguém e que só funciona se, coincidentemente, o seu computador estiver ligado e conectado naquele instante não é um projeto entregue, é uma demonstração ao vivo. Um link que funciona à uma da manhã, com você dormindo, é um projeto de verdade.

### 9.4 Dois Ambientes, Não Um

Uma vez que o projeto tem um endereço de verdade, com gente de verdade podendo usar, surge um problema novo: onde você testa uma mudança antes de mostrá-la para essas pessoas? Alterar o projeto diretamente no lugar onde ele está no ar, torcendo para não quebrar nada na frente de quem está usando naquele momento, é o tipo de aposta que só dá certo até o dia em que não dá.

A prática que resolve isso é manter dois ambientes separados: um de teste, onde você experimenta livremente, quebra à vontade e ninguém além de você percebe; e um de produção, o endereço real que outras pessoas usam, que só recebe uma mudança depois dela já ter passado pelo primeiro. É a diferença entre ensaiar um espetáculo com o teatro vazio e estrear com a plateia sentada; o ensaio existe exatamente para que os erros aconteçam onde não custam caro. Projetos pequenos costumam ter uma versão simplificada disso, às vezes só a própria máquina do desenvolvedor fazendo esse papel de ensaio, mas a separação entre "onde eu testo" e "onde as pessoas usam" existe mesmo na escala mais modesta, e ignorá-la é o tipo de economia que cobra juros altos na primeira vez que dá errado.

### 9.5 Segredos Não Viajam no Bolso do Casaco

O Capítulo VII já avisou: chaves de acesso a sistemas de fora não vão dentro do código que você compartilha. Na hora de entregar o projeto, esse cuidado vira ainda mais concreto, porque o mesmo projeto frequentemente precisa rodar com segredos diferentes em lugares diferentes: uma chave de teste enquanto você desenvolve, uma chave de verdade quando o projeto está no ar valendo, e nenhuma das duas escrita dentro dos arquivos que qualquer pessoa pode abrir.

A prática padrão é manter essas informações fora do código, num lugar que muda de ambiente para ambiente sem exigir reescrever nada, geralmente chamado de variável de ambiente. É o código perguntando "qual é a minha chave desta vez?" ao lugar onde está rodando, em vez de já saber a resposta de cor, escrita firme dentro de si.

E vale saber, com antecedência, o que fazer no dia em que uma chave vazar mesmo assim, porque um dia, para alguém, isso acontece: assim como se troca a fechadura de uma porta depois de perder uma cópia da chave, uma chave de acesso vazada se invalida e se substitui por uma nova, o quanto antes. O erro caro não costuma ser o vazamento em si, que acontece até com gente cuidadosa; é deixar a chave antiga continuar valendo por vergonha ou pressa de resolver, dando tempo de sobra para quem a encontrou primeiro.

### 9.6 O Texto Que Fala Por Você Quando Você Não Está

Todo projeto entregue precisa de um texto que explique, para alguém que nunca conversou com você, o que aquilo faz, o que precisa estar instalado antes, como se roda, e o que configurar antes de rodar. Esse texto costuma se chamar README, e ele é a versão escrita de você respondendo às perguntas que a pessoa teria feito se pudesse te procurar.

Um README que realmente ajuda responde, nesta ordem, ao que o projeto faz em duas frases, ao que precisa existir na máquina de quem for rodar antes de começar, ao comando ou passo exato para colocá-lo de pé, e ao que configurar para ele funcionar de verdade, não só abrir uma tela em branco. Faltar qualquer uma dessas respostas transfere para quem tenta usar o projeto o trabalho de adivinhar o que você sabia de cabeça e nunca escreveu, exatamente a falha que o Capítulo V já havia descrito na sexta propriedade.

Existe ainda um perigo mais silencioso que a ausência total: um README desatualizado, que descreve um passo que já mudou há dois meses. Ele é pior do que não ter README nenhum, porque mente com confiança; quem segue instruções erradas, escritas com ar de certeza, demora muito mais para desconfiar delas do que demoraria para admitir que não tinha instrução nenhuma. Manter esse texto atualizado junto com o projeto, não como tarefa separada para "quando sobrar tempo", é parte do trabalho, não um anexo dispensável dele.

### 9.7 O Teste do Primeiro Estranho

Existe um jeito simples e desconfortável de descobrir se um projeto está de fato pronto: entregar as instruções para alguém que nunca viu o projeto, sem ajudar, sem estar por perto, e ver se essa pessoa consegue colocá-lo para rodar sozinha, só com o que está escrito. Quase sempre alguma coisa falha, e falha exatamente nos pontos que você nunca teria adivinhado sozinho, porque você já tinha resolvido aquele obstáculo há tanto tempo que esqueceu que ele existia.

Esse teste vale mais do que qualquer revisão que você faça olhando para o próprio trabalho, porque você é, estruturalmente, incapaz de notar o que falta no que escreveu: falta exatamente aquilo que você já sabe e por isso não vê a ausência. Um amigo dez minutos tentando seguir as suas instruções encontra, com frequência incômoda, o que semanas de revisão sozinho não encontrariam. Se não tiver ninguém disponível para esse papel, a segunda melhor opção, bem mais fraca mas ainda útil, é fazer o teste você mesmo numa máquina limpa, sem nenhuma das suas configurações antigas, forçando-se a seguir o próprio texto ao pé da letra em vez de completar as lacunas de memória.

### 9.8 Quando Já Está no Ar e Alguma Coisa Quebra

Entregar não é o fim da responsabilidade; é o início de uma nova, mais discreta. Depois que o projeto está no ar com gente de verdade usando, duas perguntas passam a valer o tempo todo: como você fica sabendo que algo quebrou antes que um usuário precise te avisar, e como você volta rápido para a última versão que funcionava, se a mudança mais recente foi a causa.

A primeira pergunta pede algum tipo de vigilância, ainda que simples: um alerta, um registro que você olha de vez em quando, algo que grite mais alto que o silêncio de ninguém reclamar. A segunda pede que voltar atrás seja fácil, e é aqui que o controle de versão do Capítulo IV paga o próprio investimento de volta: se cada mudança está registrada como um passo separado e reversível, desfazer a última é uma operação conhecida, não uma reconstrução às pressas. Projetos entregues sem nenhuma das duas coisas sobrevivem enquanto nada dá errado, e algo sempre acaba dando, mais cedo do que se espera.

### 9.9 Dois Projetos que Rodam Valem Mais que Vinte Tutoriais

Chegamos ao ponto que fecha o argumento do livro inteiro. Quando alguém avalia se você sabe o que diz saber, seja um recrutador, um cliente ou um colaborador em potencial, a pergunta nunca é "quantos cursos você terminou". É "o que você consegue me mostrar rodando, agora, que eu possa abrir e usar". Vinte projetos de tutorial, cada um uma calculadora ou variação dela, respondem a essa pergunta com silêncio, porque nenhum deles sobrevive fora da tela de quem os fez. Dois projetos que seguem as seis propriedades do Capítulo V, empacotados, hospedados, com segredo fora do código e um README que se basta, respondem a essa pergunta na hora, com um link que qualquer pessoa, a qualquer hora, consegue abrir sozinha.

Não é sobre quantidade nem sobre impressionar com escopo grandioso. É sobre a diferença entre ter praticado e ter entregue, e só a segunda coisa é verificável por outra pessoa sem precisar confiar na sua palavra.

Você tem uma direção, uma linguagem, uma forma de pensar que atravessa as duas, uma oficina montada, um projeto com chão, um modelo de dados que aguenta, uma postura para o mundo de fora, uma noção honesta de escala e, agora, o hábito de entregar de verdade, com um jeito de saber quando algo quebra e voltar atrás sem pânico. Falta pouco para fechar este mapa: um último aviso sobre o buraco onde a maioria fica presa antes mesmo de chegar até aqui. É o assunto do capítulo que fecha este livro.
