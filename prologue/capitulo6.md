\newpage

# Capítulo VI

\vspace{-1em}

## Modelar Antes de Digitar

\vspace{1em}

O capítulo anterior prometeu isto: antes de escrever a primeira linha de código que depende de dados relacionados, você para e modela essa relação. Este capítulo cumpre a promessa.

O instinto mais comum, assim que uma ideia parece clara na cabeça, é abrir o editor e começar a digitar. Para tarefas pequenas isso funciona. Para qualquer coisa que guarda mais de um tipo de informação e as relaciona (a segunda propriedade do capítulo anterior), digitar primeiro é como construir a casa antes de ter a planta: você levanta as paredes onde parece fazer sentido no momento, e só descobre depois, com a família já morando lá, que a cozinha devia ter ficado do outro lado. Mudar uma planta no papel é apagar uma linha; mudar uma parede com gente morando atrás dela é reforma de verdade.

Modelar é o nome do que vem antes: decidir, em papel, num quadro ou na sua cabeça mesmo, quais coisas o seu projeto precisa guardar, o que se sabe sobre cada uma, e como elas se referem umas às outras. Nada disso exige uma ferramenta específica nem uma tecnologia de banco de dados. É puro raciocínio, e é o mesmo raciocínio em qualquer direção que você tenha escolhido.

### 6.1 O Que É uma Entidade

Uma entidade é uma coisa que o seu projeto precisa lembrar, e que você vai mencionar mais de uma vez. Num sistema de agendamento, um cliente é uma entidade, um horário é outra. Num jogo, um jogador e um item de inventário. Numa rede social, uma pessoa e uma publicação.

O teste prático para reconhecer uma entidade é simples: se você consegue imaginar uma lista dela ("todos os clientes", "todos os itens") e imaginar precisar achar um específico dentro dessa lista, é uma entidade. Nem tudo que parece substantivo na frase merece virar uma: num sistema de agendamento, "o dia de hoje" não é entidade, porque você não lista dias nem procura um dia específico entre outros guardados, ele só existe como referência de tempo passando.

Errar essa fronteira custa caro nos dois sentidos. Entidade de menos empilha informações incompatíveis numa coisa só, e mais cedo ou mais tarde você acaba tendo que separar de novo o que devia ter nascido separado, com a dor de já existir dado real misturado ali dentro. Entidade demais fragmenta informação que deveria estar junta, e cada consulta simples vira um quebra-cabeça de juntar pedaços espalhados. Boa parte do trabalho de modelar começa em algo quase besteira: ler a descrição do que você quer construir e sublinhar os substantivos que importam de verdade, não todos. É um exercício menor do que parece, e ainda assim a maioria dos iniciantes pula direto para o código sem nunca ter feito essa lista.

### 6.2 Atributos: O Que Você Escolhe Saber

Cada entidade tem atributos: os pedaços de informação que você guarda sobre ela. Um cliente tem nome, telefone, data de cadastro. Um item de inventário tem nome, peso, poder de ataque.

O ponto que passa despercebido é que essa lista é uma escolha, não um espelho da realidade. Uma pessoa de carne e osso tem uma quantidade sem fim de fatos verdadeiros sobre ela: altura, cor dos olhos, o que comeu no café da manhã. O seu projeto não guarda a pessoa; guarda só os fatos que precisa para fazer o que promete fazer. Um sistema de agendamento precisa do telefone do cliente para confirmar o horário; não precisa da cor dos olhos dele. Escolher os atributos certos é decidir, com precisão, o que o seu projeto realmente precisa saber, nem mais nem menos, o mesmo hábito de nomear com clareza que o Capítulo III já havia descrito. Um atributo mal escolhido, de sobra ou de menos, custa caro mais tarde: informação que falta força um retrabalho; informação que sobra vira peso morto que alguém, um dia, vai ter que explicar por que existe.

### 6.3 "Ainda Não Sei": O Valor Que Falta

Nem todo atributo tem sempre uma resposta. Um cliente pode se cadastrar antes de informar o telefone; um pedido pode não ter, ainda, uma data de entrega confirmada. Modelar direito significa decidir, atributo por atributo, se a ausência de valor é uma possibilidade normal do mundo real ou um erro que não deveria acontecer.

Essa decisão parece pequena e não é. Se você trata "telefone ainda não informado" como um erro, o seu sistema recusa cadastros legítimos de gente que só quer completar o perfil depois. Se você trata "data de entrega" como algo que pode faltar sem problema, mas alguma parte do seu programa, em algum lugar, assume sem checar que ela sempre existe, você criou um buraco que só aparece quando alguém finalmente cai nele, normalmente em produção, na frente de um cliente, não no seu teste tranquilo em casa. Cada atributo do seu modelo merece essa pergunta simples, feita uma vez e por escrito: isto pode legitimamente não existir ainda, ou a ausência dele é sempre sinal de que algo deu errado antes?

### 6.4 Relações: Como as Coisas Se Referem Umas às Outras

Aqui mora a parte que realmente separa um modelo bem pensado de um malfeito. Quase nenhuma entidade vive sozinha; a maioria se conecta a outras, e o jeito dessa conexão importa mais do que parece à primeira vista.

Pense num guarda-roupa: uma pessoa pode ter vários pares de sapato, mas cada par pertence a uma pessoa só. Essa é uma relação de um para muitos, e ela é de longe a mais comum: um cliente com muitos agendamentos, um autor com muitos livros, um personagem com muitos itens. Agora pense numa turma de escola: um aluno frequenta várias matérias, e cada matéria tem vários alunos matriculados. Essa é uma relação de muitos para muitos, mais rara e mais traiçoeira, porque não dá para simplesmente dizer "esta matéria pertence a este aluno" sem mentira, já que ela pertence a vários ao mesmo tempo.

A pergunta que resolve qual tipo de relação você tem na frente é sempre a mesma, feita nos dois sentidos: "quantos pares de sapato uma pessoa pode ter?" e "quantas pessoas um par de sapato pode ter?". As respostas às duas perguntas, juntas, dizem o tipo de relação, e o tipo de relação decide como você vai estruturar tudo o que vier depois.

Relações também levantam uma segunda pergunta, que o capítulo anterior já tinha insinuado: o que acontece quando você apaga um dos lados? Se um cliente é removido, os agendamentos dele desaparecem junto, ficam órfãos apontando para alguém que não existe mais, ou a remoção do cliente é simplesmente proibida enquanto ele tiver agendamento pendente? Nenhuma das três respostas é sempre certa; a certa depende do que faz sentido para o seu projeto específico. O erro comum não é escolher mal entre as três, é nunca ter feito a pergunta, e descobrir o comportamento por acidente, na primeira vez que alguém de verdade apaga alguma coisa com relações penduradas nela.

### 6.5 Identidade: Distinguir o Igual do Igual

Duas pessoas podem se chamar Ana Silva. Um sistema que identifica clientes pelo nome vai, mais cedo ou mais tarde, confundir as duas. Toda entidade de verdade precisa de um jeito de ser identificada sem ambiguidade, mesmo quando tudo o mais nela é idêntico a outra.

Esse problema não é novo nem exclusivo de programa. A sociedade já resolveu a mesma questão de outras formas, bem antes de existir computador: duas pessoas podem se chamar igual, mas não têm o mesmo número de documento; dois alunos podem ter o mesmo nome, mas não a mesma matrícula. Um sistema não inventa esse conceito, só empresta a mesma solução que documentos e instituições já usam há muito mais tempo: quando o nome não basta para garantir que você fala de uma coisa só, você cria um identificador cuja única função é nunca se repetir, o que se costuma chamar de chave.

É a chave, não o nome, que uma entidade usa para se referir à outra. Quando um agendamento aponta para um cliente, ele não guarda o nome do cliente escrito de novo; guarda a chave dele. Isso parece um detalhe técnico pequeno, mas é o que garante que renomear alguém, corrigir um erro de digitação ou lidar com duas Anas Silva nunca quebre a relação entre as coisas. A chave é o nome verdadeiro que a entidade tem para o resto do sistema; o nome de verdade, o que aparece na tela, é só mais um atributo, e atributos, como visto acima, podem mudar.

### 6.6 Duplicar É Trapaça com Você Mesmo

Uma tentação comum, principalmente para quem vem do hábito de guardar informação em planilhas, é copiar o mesmo dado em mais de um lugar por conveniência: guardar o nome do cliente dentro de cada agendamento dele, em vez de só guardar a referência ao cliente e buscar o nome quando precisar mostrar.

Isso funciona até o cliente pedir para corrigir o nome. Agora existe uma cópia certa e um punhado de cópias antigas espalhadas, e nada no sistema sabe, sozinho, que elas deveriam estar sincronizadas. Duas informações que deveriam ser a mesma coisa, guardadas em dois lugares diferentes, têm o hábito de discordar entre si mais cedo ou mais tarde, e descobrir qual das duas está certa, depois do fato, é bem mais difícil do que nunca ter duplicado a informação. A regra prática é simples de enunciar e um pouco mais difícil de seguir na hora do aperto: cada fato deveria morar num único lugar, e todo outro lugar que precisar dele deveria apontar para lá, não copiar dali.

### 6.7 Por Que Relacional Primeiro, Mesmo Fora do SQL

Existem várias formas de guardar dados no fim das contas, e nem todas usam tabelas relacionais. Algumas guardam tudo dentro de um único documento solto, sem exigir que você declare relações de antemão. É tentador achar que essas formas livram você de pensar em entidades, atributos e relações. Não livram: só escondem a pergunta até mais tarde, quando ela aparece de um jeito mais difícil de resolver.

O valor de pensar de forma relacional, mesmo que o seu projeto no fim guarde os dados de outro jeito, é que ela obriga você a responder logo, e por escrito, as perguntas que qualquer outro modelo também vai cobrar mais cedo ou mais tarde: quais são as entidades, o que cada uma sabe sobre si mesma, como elas se referem umas às outras, o que fazer quando um valor falta, o que fazer quando um lado da relação some. Um modelo solto deixa você adiar essas respostas, e adiar não é o mesmo que não precisar responder. Pensar relacional primeiro é uma disciplina de clareza que você carrega para qualquer forma de guardar dados depois, do mesmo jeito que aprender a ler um mapa de verdade ajuda mesmo quando o carro tem um sistema de navegação cuidando da rota.

### 6.8 O Modelo Também Envelhece

Nenhum modelo sai perfeito na primeira tentativa, e mesmo o que sai certo hoje vai precisar mudar amanhã, porque o projeto real muda de ideia, ganha um requisito novo, encontra um caso que ninguém previu. Isso é normal e esperado, não um sinal de que você modelou errado lá atrás.

O que muda entre alguém experiente e alguém iniciante não é a ausência dessa mudança; é como ela é feita. Mudar um modelo que já guarda dado de verdade é diferente de mudar um rascunho no papel: existe informação viva que depende da forma antiga, e a transição de uma forma para a outra precisa ser pensada, não só executada às pressas, torcendo para nada quebrar. A prática madura registra cada mudança de modelo como um passo explícito e reversível, do mesmo jeito que o Capítulo IV descreveu o controle de versão para o código; aqui a mesma ideia se aplica à forma dos dados. Este livro não entra em como fazer isso na prática, porque o **como** pertence à ferramenta que você escolher mais adiante. O que importa reter agora é que mudar um modelo merece o mesmo cuidado deliberado que mudar código, e nunca deveria ser um ajuste informal, feito na pressa, direto onde os dados de verdade moram.

### 6.9 O Rascunho Antes do Código

A prática concreta que fecha este capítulo cabe numa folha de papel ou num quadro branco: desenhe uma caixa para cada entidade, escreva dentro dela os atributos que importam, marque quais podem legitimamente faltar, e puxe uma linha entre as caixas que se relacionam, anotando o tipo de relação e o que acontece se um dos lados for removido. Não é um diagrama formal nem exige uma ferramenta específica. É só tornar visível, antes de escrever qualquer código, uma estrutura que a sua cabeça só consegue segurar direito quando está desenhada na frente dos olhos.

Esse rascunho custa vinte minutos e evita semanas de retrabalho. Ele também é a primeira coisa que faz **um projeto real parecer diferente de um projeto de treino**: um projeto de treino raramente tem entidade suficiente para precisar do desenho; o seu, se seguiu o capítulo anterior, tem.

Com as entidades no papel e as relações entre elas decididas, o próximo passo natural seria escrever o código que as guarda. Mas antes disso, muito projeto real depende de conversar com algo que está fora do seu controle. É o assunto do próximo capítulo.
