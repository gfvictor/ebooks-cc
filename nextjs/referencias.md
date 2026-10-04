\newpage
\pagestyle{plain}

### Considerações Finais

Se você chegou até aqui, o Next.js deixou de parecer mágica. Você sabe que toda página precisa responder onde o HTML é montado, e conhece as três respostas e o custo de cada uma. Sabe que a pasta vira endereço, que o layout é a moldura que fica, e que `loading.js` e `error.js` existem para as partes do site que esperam e falham. Sabe que todo componente nasce no servidor, e que `'use client'` é uma fronteira a ser empurrada para as pontas, não um interruptor para a página inteira. Sabe buscar dados direto no componente, decidir por quanto tempo guardá-los, enviar dados de volta com uma Server Action que confere tudo antes de salvar, e publicar o resultado sem vazar nenhum segredo.

O prefácio prometeu que cada convenção do framework existia para resolver um problema real, e o livro tentou cumprir isso capítulo a capítulo. A promessa vale também para o que vier depois: o Next.js vai mudar, como já mudou várias vezes, e algumas sintaxes deste livro vão envelhecer. As perguntas por trás delas, não. Onde isso roda? Quem pode ver? Por quanto tempo esse dado vale? O que acontece quando a fonte falha? Quem tem permissão para fazer isso? Quem sabe fazer essas perguntas lê a documentação de qualquer versão nova em uma tarde.

E a Vitrine foi só a demonstração. O que fica de verdade é o projeto que você construiu ao lado dela, com as suas próprias decisões. Se ele ainda não existe, este é o momento de começá-lo, com o livro aberto como consulta, e não como roteiro.

### O Próximo Passo

O Livro IV é sobre TypeScript. Volte à página do produto da seção 6.9 e repare em quanta coisa ali depende de memória e boa vontade: nada garante que `produto` tenha um `nome`, que `preco` seja um número, ou que a API devolva o formato que o código espera. Se a API mudar um campo de nome amanhã, a Vitrine só descobre quando um visitante abrir a página quebrada. O TypeScript move essa descoberta para o momento em que você escreve o código. E o Zod do Capítulo V, que aqui só validou um formulário, reaparece lá como a ponte entre o que o código promete e o que os dados de fora realmente entregam.

\newpage

### Referências

GOOGLE. _**Web Vitals**_. Disponível em: https://web.dev. Acesso em: 1 out. 2026.

MCDONNELL, Colin. _**Zod Documentation**_. Disponível em: https://zod.dev. Acesso em: 30 set. 2026.

META. _**React Documentation**_. Disponível em: https://react.dev. Acesso em: 27 set. 2026.

META. _**The Open Graph Protocol**_. Disponível em: https://ogp.me. Acesso em: 1 out. 2026.

MOZILLA. _**MDN: HTTP caching**_. Disponível em: https://developer.mozilla.org. Acesso em: 29 set. 2026.

TYPICODE. _**json-server**_. Disponível em: https://github.com. Acesso em: 30 set. 2026.

VERCEL. _**Next.js Documentation**_. Disponível em: https://nextjs.org. Acesso em: 26 set. 2026.

VERCEL. _**Vercel Documentation**_. Disponível em: https://vercel.com. Acesso em: 28 set. 2026.
