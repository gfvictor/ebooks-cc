\newpage

# Capítulo VIII

\vspace{-1em}

## Escala

\vspace{1em}

Esta é a palavra que mais aparece em conversa de gente que está começando, e a que menos deveria preocupar quem está começando. "Será que isso escala?" é pergunta de quem já tem gente demais batendo à porta, e o seu primeiro projeto de verdade, aquele do Capítulo V, quase certamente não vai ter esse problema tão cedo. Ainda assim, entender o que essa palavra significa muda como você escreve código desde a primeira linha, mesmo sem nenhuma fila de gente esperando. É esse o equilíbrio que este capítulo tenta acertar: nem alarmar você com um problema que não é seu ainda, nem deixar você chegar nele sem nenhuma bagagem.

### 8.1 Uma Máquina, Um Teto

Todo projeto começa rodando numa máquina só, e essa máquina tem um teto composto de várias peças ao mesmo tempo: uma quantidade de memória para guardar o que está em uso agora, uma velocidade de processamento para executar instruções, uma capacidade de disco para ler e escrever, uma capacidade de rede para conversar com quem está do lado de fora. Cada uma dessas peças tem o próprio limite, e o projeto sente o aperto na primeira que estourar, não necessariamente na mais óbvia.

Enquanto pouca gente usa o projeto, esse teto nem aparece no horizonte. Conforme mais gente usa ao mesmo tempo, cada uma delas disputa a mesma fatia dos mesmos recursos, e em algum ponto essa máquina começa a demorar mais para responder, depois a engasgar em horários de pico, depois a recusar gente na porta com erros que ninguém pediu. Do lado de quem usa, isso não parece "um servidor sobrecarregado"; parece uma página que não carrega, um aplicativo que trava, um pedido que nunca confirma. A causa técnica e o sintoma sentido por outra pessoa raramente se parecem.

Isso não é uma falha de projeto nem um sinal de código malfeito. É física: uma máquina só processa uma certa quantidade de coisa por segundo, e não existe máquina real com capacidade infinita. A pergunta que importa não é "como evito esse teto", porque ele sempre existe em algum tamanho; é "o que eu faço quando chegar perto dele".

### 8.2 Escalar Verticalmente: Um Carro Maior

A primeira resposta, e a mais simples, é trocar a máquina por uma mais forte: mais memória, mais processador, a mesma máquina só que maior. Chama-se escala vertical, e é exatamente como trocar o carro por um com motor maior, mesma ideia de sempre, só que com mais potência debaixo do capô.

É simples de fazer, não exige mudar como o projeto foi escrito, e resolve o problema por um bom tempo: às vezes basta apertar um botão num painel de controle e esperar alguns minutos. Mas tem dois limites que aparecem cedo ou tarde. Primeiro, existe sempre uma máquina mais forte que a sua atual, mas não existe uma máquina infinitamente forte; em algum ponto, o carro maior também para de existir à venda, ou o preço dele deixa de fazer sentido. Segundo, e mais sério: continua sendo um carro só. Se ele quebrar de madrugada, furar o pneu, precisar parar no posto para manutenção, todo mundo que dependia dele fica parado ao mesmo tempo, não importa quão potente ele fosse um segundo antes. Um carro maior nunca deixa de ser um carro só, com tudo que isso implica no dia em que ele falha.

### 8.3 Escalar Horizontalmente: Mais Carros na Frota

A segunda resposta é diferente na raiz: em vez de um carro maior, uma frota de carros do mesmo tamanho, cada um capaz de atender parte do movimento, com algo na entrada decidindo qual carro pega qual passageiro, o que costuma se chamar de balanceador de carga. Ele não sabe nem precisa saber o que aconteceu nas corridas anteriores; só olha quais carros estão livres agora e manda o próximo passageiro para um deles.

Chama-se escala horizontal, e ela resolve os dois limites do carro único de uma vez: a capacidade total cresce só de colocar mais um carro na frota, sem teto óbvio à vista enquanto existir espaço físico e dinheiro para mais máquinas; e se um carro quebra, os outros continuam rodando, então parar de vez fica muito mais raro, porque a falha de uma peça não é mais a falha do sistema inteiro.

O preço dessa solução não é só dinheiro, é complexidade. Agora existe mais de um carro rodando ao mesmo tempo, e eles precisam se comportar como se fossem um só, do ponto de vista de quem está sendo atendido: o mesmo passageiro pode ser pego por um carro diferente a cada viagem, sem perceber e sem se importar. Garantir isso exige uma mudança na forma de escrever o projeto, e é aí que mora o erro mais comum de quem tenta essa passagem pela primeira vez.

### 8.4 O Problema do Motorista Particular

Imagine uma frota de táxi em que cada motorista, além de dirigir, também decora os hábitos dos passageiros que já levou antes: este prefere o ar-condicionado num nível específico, aquele sempre desce na mesma esquina. Enquanto o mesmo motorista pega sempre o mesmo passageiro, tudo funciona liso, porque a lembrança está guardada na cabeça de quem precisa dela.

O problema aparece no dia em que esse motorista específico está de folga, preso no trânsito ou ocupado com outra corrida. O passageiro entra em qualquer outro táxi da mesma frota, e esse outro motorista não faz a menor ideia dos hábitos dele, porque essa lembrança nunca saiu da cabeça do primeiro motorista. A cidade inteira pode estar cheia de táxis livres; nenhum deles serve, porque a informação que importa está trancada dentro de um carro só.

Um servidor tem exatamente esse tipo de memória de motorista quando guarda, só para si, algo específico sobre um usuário: o que ele preencheu num formulário há dois passos, se ele já fez login nesta visita, o que tem no carrinho de compras. Se essa lembrança vive só na memória daquele processo, num daquele servidor específico, esse usuário só é bem atendido pelo mesmo servidor de sempre, exatamente como o passageiro só era bem atendido pelo mesmo motorista. E o balanceador da seção anterior não sabe disso, nem tem por que saber: o trabalho dele é encontrar um carro livre, não lembrar quem andou com quem da última vez. Ele manda o próximo pedido desse usuário para qualquer servidor disponível, e se calhar de ser outro, a lembrança simplesmente não está lá.

A solução não é ensinar o balanceador a reconhecer passageiros, isso nunca foi trabalho dele. É tirar a lembrança da cabeça de cada motorista individual e colocá-la numa central de despacho que qualquer um deles consegue consultar: um caderno comum, não a memória pessoal de ninguém. Aí, não importa qual motorista pegue aquele passageiro na próxima corrida; o primeiro gesto dele é abrir o caderno e ler o que precisa saber. Sistemas montados assim, em que nenhum servidor guarda sozinho uma lembrança que os outros não têm como acessar, são chamados de _**Stateless**_, e a expressão soa mais assustadora do que é.

### 8.5 A Fila em Vez da Corrida

Nem todo trabalho precisa ser feito na hora, na frente de quem pediu. Enviar um e-mail de confirmação, gerar uma miniatura de uma imagem enviada, processar um vídeo longo: nada disso precisa terminar antes de você devolver uma resposta para quem está esperando na tela.

A saída para esse tipo de tarefa é colocá-la numa fila, em vez de executá-la na hora, e deixar um grupo separado de trabalhadores cuidar dessa fila no próprio ritmo, enquanto a porta de entrada do seu projeto já responde "recebido, estamos cuidando disso" quase instantaneamente. É a diferença entre um restaurante em que o garçom cozinha o prato na sua frente antes de anotar o próximo pedido, e um em que o garçom anota e passa para a cozinha, livre para atender a próxima mesa enquanto o prato fica pronto.

Essa separação alivia a porta de entrada, que é normalmente a parte mais sensível a demora, e permite que o trabalho pesado escale de um jeito próprio, adicionando mais trabalhadores à fila sem precisar mexer em nada que o usuário toca diretamente. É também uma resposta natural à quinta propriedade do Capítulo V, a operação que pode demorar: em vez de fazer o usuário esperar o tempo todo, você aceita o pedido, promete cuidar dele, e avisa quando estiver pronto.

### 8.6 Não Perguntar Duas Vezes a Mesma Coisa

Boa parte da carga que chega até a central de despacho é, na prática, a mesma pergunta feita de novo e de novo por pessoas diferentes, ou pela mesma pessoa em curtos intervalos: qual o cardápio de hoje, qual o preço desse produto, quais as notícias mais lidas na última hora. Perguntar a mesma coisa cem vezes e esperar cem respostas idênticas da central é desperdiçar a capacidade dela com trabalho repetido.

A resposta é guardar a resposta de uma pergunta comum em algum lugar rápido de consultar, mais perto de quem pergunta, e servir dali enquanto a resposta continuar válida, só voltando à central quando ela mudar ou expirar. Isso se chama _**cache**_, e é provavelmente a técnica isolada que mais reduz carga real num sistema, porque ataca direto o gargalo mais difícil de multiplicar: em vez de fazer a central aguentar mais perguntas, você simplesmente evita que a maioria delas chegue até ela.

### 8.7 O Gargalo Final

Aqui mora a parte que costuma decepcionar quem esperava uma solução limpa: mesmo com uma frota inteira de carros _stateless_, filas para o trabalho que pode esperar e _cache_ para as perguntas repetidas, quase todo sistema ainda tem, no fim da rota, uma fonte de verdade única: o mesmo banco de dados, o mesmo lugar onde a informação de fato mora e é escrita pela primeira vez. Multiplicar carros não multiplica essa fonte; ela continua sendo um lugar só, com o próprio teto.

É como uma rodovia de dez pistas que termina numa única cabine de pedágio: não importa quantas pistas você abrir antes dela, o quanto passa por hora é limitado pela cabine, não pelas pistas. Existem técnicas para aliviar até esse gargalo, e _cache_ e fila já são duas delas; mas em algum ponto, para quantidades realmente grandes, a própria fonte de verdade precisa ser repensada, e isso é um problema mais específico e mais avançado do que cabe numa introdução. O que importa reter é que "escalar" quase nunca é um problema só, e sim uma sequência: primeiro o carro fica maior, depois vira frota, depois vem fila e _cache_ para poupar a central, e só então, bem mais raro, a própria central precisa mudar de forma.

### 8.8 Por Que Ainda Não É o Seu Problema

Tudo isso é real, e quase nada disso é urgente para o projeto que você vai construir depois deste livro. A esmagadora maioria dos primeiros projetos reais nunca chega perto do teto de uma única máquina, e existe até um nome carinhoso para quem monta uma frota inteira, com balanceador, fila e _cache_, para um projeto que ainda não tem ninguém usando: resolver um problema que ninguém tem ainda, só para o currículo parecer mais impressionante. É fácil se seduzir por essa vontade, porque as palavras soam sérias e o desenho da arquitetura fica bonito num quadro branco, mas o tempo gasto montando essa frota vazia é tempo que faria muito mais falta resolvendo o que o Capítulo V já pediu: as seis propriedades, funcionando, com gente de verdade usando.

Construir a frota antes de ter passageiro nenhum não é prudência, é procrastinação vestida de profissionalismo. Se o seu projeto crescer a ponto de precisar de fato deste capítulo inteiro, você vai perceber, porque vai doer de um jeito específico e visível: lentidão sob uso real, não desconforto teórico sobre o que pode acontecer um dia. Esse dia, quando chegar, é uma comemoração disfarçada de problema: significa que gente de verdade quer usar o que você fez, mais gente do que você imaginou no começo.

### 8.9 O Que Muda Desde Já

Dito isso, uma coisa deste capítulo vale a pena adotar hoje, de graça, sem construir frota, fila ou _cache_ nenhum: o hábito de não guardar informação de um usuário só na memória do processo que está rodando, e sim em algum lugar que qualquer parte do seu programa, presente ou futura, consiga consultar. Não é montar a central de despacho agora; é simplesmente não amarrar cada passageiro a um motorista específico desde o primeiro carro, mesmo quando esse primeiro carro é o único que existe.

Esse hábito custa quase nada para adotar cedo e custa uma reescrita inteira para corrigir depois, quando o projeto já tem gente de verdade dependendo dele e você descobre, do jeito ruim, que metade da informação dos seus usuários mora presa na cabeça de um único motorista que nunca deveria ter tido essa responsabilidade sozinho.

A palavra "escala" agora tem um significado concreto, não mais um alarme vago que se ouve por aí. Falta uma última peça antes de fechar este mapa: o que significa, de fato, entregar um projeto para alguém rodar, fora da sua garagem. É o assunto do próximo capítulo.
