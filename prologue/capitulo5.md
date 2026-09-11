\newpage

# Capítulo V

\vspace{-1em}

## A Primeira Viagem de Verdade

\vspace{1em}

Você tem uma direção (Capítulo I), um veículo (Capítulo II), sabe ler o trânsito (Capítulo III) e montou a oficina em volta da garagem (Capítulo IV). Falta uma coisa, e ela não é mais teoria: falta sair e dirigir.

Só que dirigir de verdade não é dar voltas num estacionamento vazio. Dá para passar anos girando entre as mesmas quatro vagas, cada vez com mais suavidade na embreagem, sem nunca ter enfrentado um cruzamento, uma chuva forte ou alguém no banco de trás pedindo pressa. É treino, mas não é viagem, e treino demais no estacionamento cria uma confiança que desmancha no primeiro semáforo de verdade.

Isso acontece porque todo curso, todo tutorial, precisa terminar. Uma aula tem que caber numa hora e fechar com alívio, então o exercício no final dela é sempre pequeno, sempre completo, sempre seguro. O resultado, depois de meses estudando assim, é uma gaveta cheia de calculadoras, listas de tarefas e conversores de unidade: cada um genuinamente terminado, cada um ensinando quase nada sobre o que de fato ocupa o trabalho de quem programa. Terminar coisas vicia. Terminar cinquenta vezes a mesma forma de coisa não é o mesmo tipo de progresso que terminar uma coisa só que reage, resiste e briga de volta.

Este capítulo não entrega um projeto pronto para copiar. Entrega as seis coisas que separam um estacionamento de uma viagem, para você montar a sua, na direção que escolheu, e saber reconhecer se ela é a viagem de verdade ou só mais uma volta na quadra.

### 5.1 Por Que a Calculadora Não Ensina Nada

Não há nada de errado em escrever uma calculadora. O problema é parar nela, ou emendar um projeto do mesmo tipo achando que aprendeu algo novo só por ter mudado o tema.

Abra uma calculadora de exercício e repare no que ela não te pediu. Você digitou dois números, viu o resultado, e fechou a janela: nada precisou ser lembrado depois. Só você usou aquilo, do início ao fim: nenhum outro papel, nenhuma outra pessoa. Ela nunca precisou perguntar nada a mais ninguém: nenhum sistema de fora, nenhuma resposta que pudesse demorar ou vir errada. E ela só rodou onde você mandou rodar, na sua máquina, sob suas condições. Um único personagem, um único ato, sem consequência depois e sem plateia. Dá para escrever cem desses, cada vez numa linguagem diferente, sem tocar uma vez sequer nos problemas que ocupam a maior parte do trabalho real: onde as coisas ficam guardadas, o que fazer quando algo de fora falha, como duas pessoas usam a mesma coisa sem pisar uma na outra.

O custo mais caro disso não é falta de ambição, é falta de exposição. Alguém que fez trinta tutoriais e finalmente encara um projeto de verdade costuma travar num lugar surpreendente: não na sintaxe, que ela já domina, mas na pergunta "por onde eu começo", porque todo tutorial anterior já vinha com o escopo inteiro definido, passo a passo, numerado. Isso não quer dizer que você precisa de um projeto gigante. Quer dizer que o projeto pequeno certo vale infinitamente mais que o projeto pequeno errado, e a diferença entre os dois não é o tamanho. É se ele tem, ou não, as seis propriedades a seguir.

### 5.2 Guarda Depois que Você Fecha

A primeira propriedade é a mais básica e a mais pulada: o projeto precisa lembrar de alguma coisa depois que você fecha e abre de novo. Se toda a informação vive só em memória, numa variável, ela morre junto com o programa, e você nunca precisou aprender a guardar nada: nem um arquivo, nem um banco de dados, nenhuma forma de fazer uma informação sobreviver ao próprio programa que a criou.

Você já sentiu a falta disso do lado de fora, como usuário, incontáveis vezes: o formulário que sumiu ao atualizar a página, o jogo sem espaço para salvar, o aplicativo de notas que esqueceu a sua nota. Esse incômodo mora exatamente no buraco que um projeto de treino nunca tapa, porque nunca precisou. Guardar informação parece trivial até você perceber que é uma decisão, com alternativas de verdade: um arquivo simples, um banco de dados, algo que sobrevive a fechar o programa mas não a um desligamento brusco. Cada alternativa tem um preço diferente, e você só aprende a pesar esse preço quando alguma coisa realmente precisa sobreviver.

É onde mora boa parte do trabalho real de qualquer direção: o jogo que lembra sua fase, o site que lembra seu carrinho, o aplicativo que sincroniza entre os seus dois aparelhos. Sem essa propriedade, o projeto nunca te obrigou a decidir onde as coisas ficam guardadas, nem o que fazer se esse lugar não estiver disponível na hora.

### 5.3 Mais de Uma Coisa, e Elas Se Relacionam

A segunda é ter mais de um tipo de informação guardada, e essas informações se referirem umas às outras. Não é só "uma lista de tarefas"; é "uma lista de tarefas, cada uma pertencendo a um projeto, e cada projeto pertencendo a uma pessoa".

A dificuldade aqui nunca foi guardar duas coisas. É decidir como uma aponta para a outra, e viver com as consequências dessa decisão. O que acontece quando você apaga um projeto que ainda tem tarefas dentro? E se uma tarefa precisar mudar de projeto no meio do caminho? Essas perguntas não têm uma resposta técnica difícil, mas têm uma resposta que, escolhida sem cuidado, vira o tipo de bagunça que só aparece semanas depois, quando o projeto já cresceu em cima da decisão errada. Um projeto sem entidades relacionadas nunca te faz essas perguntas, e por isso nunca te ensina a arrumar informação antes de agir sobre ela, o hábito que o Capítulo III já havia nomeado. O Capítulo VI inteiro é sobre modelar essas relações direito, antes de escrever a primeira linha que depende delas.

### 5.4 Fala com Algo que Você Não Manda

A terceira é o projeto conversar com um sistema de fora que você não escreveu e não controla: uma API na internet, um sensor, outro programa, um arquivo que alguém te mandou. Sistema de fora não segue as suas regras: sai do ar, muda de formato sem avisar, demora mais do que você esperava, ou simplesmente mente sobre o que devolve.

Isso muda o tipo de código que você escreve. Você para de confiar cegamente na resposta e passa a conferir; para de assumir que a documentação está certa e passa a testar; passa a escrever pensando em como o seu programa se comporta quando o outro lado decepciona, não só quando ele coopera. É uma postura inteira diferente da de quem só conversa consigo mesmo, e é exatamente a postura que separa alguém que sabe programar num ambiente controlado de alguém que sabe programar no mundo, que é o único lugar onde existe trabalho de verdade. O Capítulo VII volta a esse ponto com calma.

### 5.5 Alguma Coisa Pode Demorar ou Falhar

A quarta é ter, dentro do projeto, uma operação que não é instantânea nem garantida: uma busca que demora, um arquivo que pode não existir, uma conexão que pode cair no meio. E o projeto precisa fazer algo sensato enquanto espera e quando dá errado, em vez de travar ou fingir que aquilo nunca acontece.

Pense no que o usuário vê durante essa espera: nada? uma tela congelada? algum sinal de que o programa ainda está vivo e trabalhando? E pense no que acontece se a resposta nunca chegar: o programa inteiro morre junto, ou só aquela parte falha e o resto segue de pé? Um tutorial quase sempre mostra o caminho feliz, aquele em que tudo responde na hora e do jeito esperado. O trabalho real é, em boa medida, o caminho infeliz, tratado com cuidado, porque é ali que a experiência de um usuário de verdade mais costuma desandar. Um projeto sem essa propriedade nunca te obrigou a escrever essa outra metade do programa, a que só aparece quando as coisas não saem como o previsto.

### 5.6 Mais de Uma Pessoa no Banco

A quinta é ter mais de um papel, não só "você, o único usuário". Duas contas. Um dono e um visitante. Alguém que edita e alguém que só vê.

No instante em que existe mais de um ator, você é obrigado a enxergar o seu próprio projeto pelos olhos de outra pessoa: o que ela deveria poder ver, o que ela não deveria poder mudar, o que acontece quando duas pessoas mexem ao mesmo tempo. Esse exercício de sair da própria cabeça e habitar a de um segundo usuário é, em qualquer direção, um dos hábitos mais próximos do que separa um projeto usável de um projeto que só funciona na demonstração feita por quem o escreveu. Uma calculadora, sozinha na tela, nunca te pede esse exercício.

### 5.7 Alguém Além de Você Consegue Rodar

A sexta fecha o círculo do capítulo anterior: alguém que não é você consegue pegar o projeto e colocá-lo para funcionar, só com o que você deixou escrito. É dar a chave do carro para quem nunca dirigiu aquele carro e ver se ele sai da garagem sozinho.

É impressionante como um projeto pode parecer pronto e não sair do lugar na mão de outra pessoa: um caminho de arquivo que só existe no seu computador, uma senha guardada dentro do próprio código em vez de fora dele, um passo de preparação que você faz de cabeça e nunca escreveu em lugar nenhum. Nenhuma dessas falhas aparece enquanto só você usa o projeto, porque você já carrega a resposta sem perceber que carrega. Elas só aparecem no momento em que alguém tenta seguir as suas instruções sem ter a sua cabeça, e é exatamente esse momento que um projeto de treino nunca provoca. Se o seu projeto só roda na sua máquina, com as suas configurações, na sua cabeça, ele não está pronto. Está estacionado.

### 5.8 O Mesmo Roteiro, Quatro Destinos

As seis propriedades não pertencem a nenhuma direção específica. Elas só mudam de roupa.

Em **desenvolvimento web**, o projeto pode ser um pequeno sistema de agendamento: guarda os horários marcados, tem clientes e horários que pertencem a um prestador de serviço, envia uma confirmação por e-mail através de um serviço externo que pode falhar, atende tanto o cliente quanto o dono do negócio, e fica publicado num endereço que qualquer pessoa acessa sem precisar da sua ajuda para abrir.

Em **jogos**, pode ser um jogo pequeno com progresso salvo em arquivo, um inventário de itens que pertence a um personagem específico, um placar buscado de um servidor que pode não responder a tempo, um modo em que dois jogadores disputam a mesma partida e cada um vê a própria pontuação, e um executável que um amigo abre sem instalar nada além do que vocês combinaram.

Em **dados**, pode ser um painel que busca informações reais de uma fonte externa que pode mudar de formato ou cair no meio da tarde, grava um histórico validado num banco, relaciona os registros brutos com os já processados, decide o que fazer quando um dado chega incompleto ou errado, serve visões diferentes para quem analisa o detalhe e para quem só consome o resultado final, e roda a partir de instruções que outra pessoa consegue seguir sem te perguntar nada.

Em **mobile**, pode ser um aplicativo com conta e sincronização entre aparelhos, o que já cobre três propriedades de uma vez, porque sincronizar é guardar, conversar com um servidor e tratar falha ao mesmo tempo; uma lista compartilhada entre duas pessoas que editam em momentos diferentes; e um instalável que funciona no celular de alguém que nunca viu uma linha do seu código.

Quatro destinos completamente diferentes, a mesma lista de seis coisas. É por isso que a rubrica funciona antes de você saber qual projeto específico vai construir: ela não pergunta o que você vai fazer, pergunta se o que você vai fazer tem chão para te ensinar alguma coisa.

### 5.9 Tirar o Carro da Garagem

Nenhuma das seis propriedades exige um projeto grande. Um sistema pequeno com as seis vale infinitamente mais que um sistema grande sem nenhuma, e, na prática, um projeto que leva as seis a sério cresce sozinho, porque cada propriedade puxa decisões reais atrás de si, e cada decisão real abre espaço para a próxima.

Escolha o seu, no seu caminho, do tamanho que caiba num par de meses de trabalho sério. Garanta que ele guarda algo depois que você fecha, que tem mais de uma coisa relacionada, que fala com um sistema que você não manda, que trata o que acontece quando algo demora ou falha, que serve mais de um papel, e que alguém além de você consegue colocar para rodar. Depois disso, pare de procurar o projeto perfeito. **Ele não existe**. Existe o projeto certo, que é aquele que tem chão. Aquele que as idéias surgem naturalmente, porque você tem interesse genuíno.

Os próximos capítulos aprofundam três dessas seis propriedades: dados e relações primeiro, depois o que significa falar com o mundo de fora, depois o que significa entregar algo para alguém além de você. Mas a viagem, a partir de agora, já começou. Falta só você tirar o carro da garagem.
