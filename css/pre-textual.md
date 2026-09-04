\newpage
\pagenumbering{Roman}
\pagestyle{plain}

### Prefácio

Todo mundo acha que sabe CSS. Você escreve `margin: 0 auto`, o
elemento centraliza, e por um instante você se sente um gênio. Aí você
tenta centralizar uma `div` na vertical. Abre a documentação da MDN,
lê com atenção, testa cinco propriedades que pareciam certas, gasta
quarenta minutos - e no fim desiste, cola a resposta que a IA cuspiu e
segue a vida sem fazer ideia de por que aquilo funcionou (nem de por
que vai quebrar depois).

CSS não é difícil porque a sintaxe é complicada. A sintaxe é
ridiculamente simples: propriedade, dois pontos, valor, ponto e
vírgula. CSS é difícil porque ninguém te explicou as regras do jogo -
o modelo de caixa, o fluxo do documento, a cascata - e você passou
anos lutando contra o navegador em vez de trabalhar com ele.

Este livro é a conversa que deveriam ter tido com você antes de te
deixar soltar `float: left` em produção.

### O Que Você Vai Aprender

Este é o Livro I da coletânea **Fundamentos da Web Moderna**. Aqui a
gente constrói a base para tudo que vem depois (Tailwind, Next.js):

1. **O modelo de caixa e o fluxo do documento:** por que as coisas
   ficam onde ficam antes de você escrever uma linha de layout;
2. **Seletores, especificidade e a cascata:** por que aquele seu
   estilo "não pega" e por que `!important` não é a resposta;
3. **Flexbox e Grid:** os dois sistemas de layout que tornaram
   obsoletos vinte anos de hacks;
4. **Responsividade e unidades:** `rem`, `vw`, `clamp()`, media
   queries e a mentalidade _mobile-first_;
5. **Custom properties e transições:** deixar o CSS manutenível e com
   movimento sem chamar uma biblioteca.

### Metodologia de Estudo

Abra as DevTools do navegador agora e deixe abertas até o fim do
livro. Todo conceito aqui tem um experimento de trinta segundos que
você pode rodar direto no painel de estilos. Ler CSS sem mexer no
inspetor é como ler sobre natação: a teoria não te impede de afundar.
