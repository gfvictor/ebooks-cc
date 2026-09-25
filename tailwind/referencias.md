\newpage
\pagestyle{plain}

### Considerações Finais

Se você chegou até aqui, aquele HTML cheio de classes do prefácio deixou de assustar. Você sabe por que o CSS tradicional cresce sem controle e por que nomear pelo que a classe faz resolve isso na raiz. Sabe ler `p-6` como `calc(var(--spacing) * 6)`, e sabe que por trás de cada cor e cada fonte existe um `@theme` que você pode ler, estender e fechar. Sabe aplicar um utilitário só numa tela grande, só no hover ou só no tema escuro, montar layouts com Flexbox e Grid sem sair do HTML, e decidir se uma lista de classes repetida vira componente, `cva` ou fica onde está.

Repare no que atravessou o livro inteiro: nada aqui substituiu o Livro I. O `@theme` são as custom properties do Capítulo VI dele. Os prefixos responsivos são as media queries do Capítulo V. O conflito entre `px-4` e `px-8` é a cascata do Capítulo II. O Tailwind não pediu que você esquecesse CSS; pediu que você parasse de reescrever a mesma decisão com um nome novo toda vez. Quem entende o que está embaixo usa o framework como atalho. Quem não entende fica refém dele no primeiro comportamento estranho.

O conselho continua o mesmo do livro anterior: abra o inspetor do navegador e confira. Todo utilitário deste livro gera uma regra CSS de verdade, e ler essa regra resolve mais dúvida do que qualquer tabela decorada.

### O Próximo Passo

O Livro III é sobre Next.js com App Router. O Capítulo VI deste livro já escreveu componentes em React, e o próximo passo é colocá-los dentro de uma aplicação de verdade: rotas, páginas, dados vindos de um servidor, formulários que salvam alguma coisa. Alguns ganchos já ficaram plantados pelo caminho, como o carregador de fontes e o `@theme inline` do Capítulo V, e eles voltam lá com o contexto completo. O `globals.css` que você aprendeu a escrever aqui é exatamente o arquivo que o Next.js vai importar no layout principal da aplicação.

\newpage

### Referências

BELL, Joe. _**cva: Class Variance Authority**_. Disponível em: https://cva.style. Acesso em: 23 set. 2026.

CASTILLO, Dany. _**tailwind-merge**_. Disponível em: https://github.com. Acesso em: 23 set. 2026.

EDWARDS, Luke. _**clsx**_. Disponível em: https://github.com. Acesso em: 23 set. 2026.

MOZILLA. _**MDN Web Docs: Using CSS custom properties**_. Disponível em: https://developer.mozilla.org. Acesso em: 17 set. 2026.

TAILWIND LABS. _**Tailwind CSS Docs**_. Disponível em: https://tailwindcss.com. Acesso em: 17 set. 2026.

TAILWIND LABS. _**Tailwind CSS v4.0**_. Disponível em: https://tailwindcss.com/blog. Acesso em: 17 set. 2026.

WATHAN, Adam. _**CSS Utility Classes and "Separation of Concerns"**_. Disponível em: https://adamwathan.me. Acesso em: 21 set. 2026.

WATHAN, Adam; SCHOGER, Steve. _**Refactoring UI**_. [S. l.]: Tailwind Labs, 2018.
