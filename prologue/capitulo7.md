\newpage

# Capítulo VII

\vspace{-1em}

## Falar com o Mundo

\vspace{1em}

O capítulo anterior te ensinou a desenhar o que o seu projeto guarda dentro de si. Mas nenhum projeto de verdade vive fechado dentro de si mesmo. Mais cedo ou mais tarde, ele precisa conversar com alguma coisa que você não escreveu, não controla e que segue as próprias regras: um serviço na internet, outro programa, um dispositivo, um arquivo que chegou de fora. É a quarta propriedade do Capítulo V, e este capítulo volta a ela com calma, porque é exatamente aqui que a maioria dos projetos de treino nunca pisou, e é aqui que a maioria dos projetos reais passa boa parte do tempo.

Falar com o mundo de fora é diferente de falar consigo mesmo. Dentro do seu próprio projeto, você é dono das duas pontas: se uma parte promete devolver um número, ela devolve um número, porque foi você quem escreveu quem pede e quem responde. Fora dele, você só é dono da sua metade da conversa. A outra metade pertence a alguém que não te consultou antes de mudar de ideia, e é justamente essa falta de controle que separa programar num ambiente fechado de programar no mundo real.

### 7.1 O Contrato: O Que Foi Combinado

Toda integração começa com um contrato: uma descrição, documentada em algum lugar, do que você pode pedir e do que vai receber de volta. É parecido com um cardápio de restaurante. Ele te diz o que existe para pedir e mais ou menos o que vai chegar na mesa; ele não é a comida em si, e a cozinha pode, em algum dia ruim, entregar algo diferente do prometido sem avisar ninguém.

Ler o contrato antes de escrever qualquer código que dependa dele parece óbvio e é o passo que mais gente pula, na pressa de ver alguma coisa funcionando. O contrato diz o que é obrigatório e o que é opcional, o que acontece quando você pede algo que não existe, os limites do que o outro lado aceita. Programar contra um sistema de fora sem ter lido o contrato dele é como fazer um pedido num idioma que você não fala direito, torcendo para que o garçom entenda a intenção.

### 7.2 A Língua da Conversa

Depois do contrato vem o formato: o jeito como a informação viaja de um lado para o outro. Duas pessoas só trocam cartas se concordarem num alfabeto comum; dois sistemas só trocam dado se concordarem numa estrutura comum para representar as mesmas ideias, o formato mais comum hoje sendo um texto estruturado chamado JSON, embora existam vários outros.

O detalhe que costuma pegar iniciante desprevenido é que o formato descreve a forma, não o significado. Duas integrações podem usar exatamente o mesmo formato de texto e ainda assim não se entenderem, porque uma chama um campo de "preço" e a outra de "valor", ou porque uma espera datas num jeito e a outra manda no jeito oposto. Concordar no alfabeto não é o mesmo que concordar na língua; o contrato da seção anterior é quem define a língua, o formato só empresta o papel em que ela é escrita.

### 7.3 Confiar, mas Conferir

Existe uma diferença enorme entre "a documentação diz que vou receber isto" e "eu conferi que recebi isto". A primeira é uma expectativa; a segunda é um fato, e programar bem para o mundo de fora significa tratar a primeira como uma hipótese, não como uma garantia.

É a mesma prudência de assinar um contrato de aluguel: a maioria das pessoas confia na palavra do corretor, e a minoria que lê a letra miúda é quem não é surpreendida seis meses depois. Documentação de sistema de fora envelhece, tem erro de digitação, descreve um comportamento antigo que ninguém atualizou. Conferir o que realmente chegou antes de usar não é desconfiança gratuita; é reconhecer que a outra ponta da conversa não trabalha para você, e que o único jeito de saber com certeza o que ela mandou é olhar.

### 7.4 O Que Pode Dar Errado

Um sistema de fora pode estar fora do ar. Pode responder devagar demais para o seu projeto esperar. Pode devolver uma resposta incompleta, cortada no meio. Pode devolver algo num formato ligeiramente diferente do combinado, porque alguém do outro lado mudou uma coisa sem avisar. Pode simplesmente recusar te atender por um tempo, porque você pediu informação demais rápido demais e esbarrou num limite de uso que você nem sabia que existia.

Nenhuma dessas situações é exótica; são, juntas, o dia a dia normal de qualquer sistema que fala com outro. Um projeto de treino nunca te expõe a nada disso, porque nunca conversou com ninguém de verdade. Um projeto real precisa decidir, para cada uma dessas situações, o que fazer: tentar de novo, avisar o usuário, seguir com um valor padrão, desistir com elegância. A pergunta que separa quem já apanhou de verdade de quem só viu o caminho feliz é sempre a mesma: "e se isso aqui não vier como eu esperava?"

### 7.5 O Outro Lado Muda Sem Te Avisar

Um sistema de fora evolui no próprio ritmo, seguindo prioridades que não são as suas. Ele ganha recursos novos, corrige comportamentos antigos, e de vez em quando aposenta uma forma de conversa inteira, substituindo por outra.

É como uma rodovia que renumera as saídas depois de anos: quem aprendeu o caminho de cor pela saída antiga se perde, mesmo sem nada ter mudado na estrada em si, só na forma de se referir a ela. Sistemas sérios avisam essas mudanças com antecedência e mantêm as duas formas funcionando por um tempo, mas o aviso só serve para quem presta atenção. Depender de um sistema de fora é aceitar que parte da manutenção do seu projeto, dali em diante, é acompanhar o que o outro lado está mudando, não só o que você mesmo escreveu.

### 7.6 Esperar Não É Perder Tempo

Uma pergunta feita a alguém na sua frente tem resposta quase instantânea. Uma pergunta feita a um sistema do outro lado do mundo, por uma rede que você não controla, leva um tempo real para ir e voltar, e esse tempo não é zero mesmo quando tudo funciona perfeitamente.

Um projeto que conversa com o mundo de fora precisa decidir o que mostrar enquanto espera essa resposta, e essa decisão faz parte do produto tanto quanto qualquer outra tela. Fingir que a espera não existe, deixando a interface travada e muda até a resposta chegar, é a marca mais clara de quem nunca precisou lidar com uma latência de verdade. A quinta propriedade do Capítulo V, a operação que pode demorar, quase sempre nasce exatamente aqui, na conversa com alguém que não mora dentro do seu computador.

### 7.7 A Chave da Casa de Outra Pessoa

Muita integração exige que você prove quem é antes de conversar: uma chave, um token, uma senha de acesso que identifica o seu projeto para o sistema de fora. Essa chave costuma valer dinheiro real, ou dar acesso a dado sensível, e vazá-la é como deixar a chave de uma casa que não é sua pendurada do lado de fora da porta.

A disciplina básica é simples de enunciar: **essa chave nunca vai dentro do código que você compartilha ou versiona, mora fora dele, num lugar separado**, do mesmo jeito que o Capítulo IV já havia pedido para você manter a configuração fora do programa em si. A tentação de colar a chave direto no meio do código, "só para testar rápido", é enorme, e é também a forma mais comum de uma chave vazar para o mundo inteiro sem que ninguém tenha feito por querer.

### 7.8 O Mundo Não Espera Por Você

Some as sete ideias deste capítulo e sobra uma postura só: o sistema de fora não trabalha para você, não segue o seu calendário, e não existe para te fazer a vida fácil. Ele tem os próprios interesses, os próprios problemas, e a própria data de validade para tudo que promete hoje.

Programar bem para o mundo de fora não é sobre pessimismo. É sobre projetar o seu programa como se ele fosse, de fato, dirigir num trânsito de verdade, cheio de outros carros que não combinaram nada com você e não vão frear só porque seria conveniente. Quem já leu o contrato, conferiu a resposta, tratou a falha e respeitou o tempo de espera constrói algo que aguenta o mundo real; quem só testou no caminho feliz constrói algo que funciona exatamente uma vez, na demonstração, na frente de quem menos importa impressionar.

Falar com sistemas de fora tem um custo que este livro ainda não olhou de frente: o que acontece quando não é um usuário, nem dez, mas milhares batendo à sua porta ao mesmo tempo. É o assunto do próximo capítulo.
