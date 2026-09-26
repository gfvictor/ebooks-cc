\newpage
\pagenumbering{Roman}
\pagestyle{plain}

### Prefácio

Você terminou o Livro II. Sabe escrever o visual de uma interface inteira sem sair do HTML, sabe montar o seu próprio `@theme` e, no último capítulo, extraiu um botão para um componente React com variantes declaradas. Só que esse botão ainda não mora em lugar nenhum. Ele não pertence a uma página com endereço próprio, não busca dado de servidor nenhum, e não salva nada quando alguém clica nele.

É aqui que entra um framework de aplicação. React sozinho desenha componentes; ele não decide que endereço cada página tem, onde os dados são buscados, nem como o formulário chega até o banco. Durante anos, cada projeto respondia a essas perguntas do seu jeito, montando meia dúzia de bibliotecas avulsas. O Next.js responde a todas de uma vez, com convenções: a pasta vira rota, o arquivo vira página, e o componente decide se roda no servidor ou no navegador.

A primeira impressão costuma ser de mágica, e mágica é justamente o que este livro quer desmontar. Cada convenção do Next.js existe para resolver um problema real, e quando você entende o problema, a convenção deixa de parecer arbitrária. É a mesma abordagem dos livros anteriores: nada de decorar receita, tudo com o porquê por trás.

### O Que Você Vai Aprender

Este é o Livro III da coletânea **Fundamentos da Web Moderna**. Ele assume o CSS do Livro I, o Tailwind do Livro II e uma base de JavaScript: variáveis, funções, objetos, `import`/`export` e a noção de componente que o Capítulo VI do Livro II apresentou.

1. **O que o Next.js resolve:** renderização no servidor, no navegador e em tempo de build, e por que o App Router mudou o jogo;
2. **Roteamento por arquivos:** `page`, `layout`, rotas dinâmicas, grupos de rotas, `loading` e `error`;
3. **Server Components e Client Components:** o que roda onde, `'use client'` e onde traçar a fronteira;
4. **Buscando dados:** `fetch` no servidor, cache e revalidação, páginas estáticas e streaming com `Suspense`;
5. **Mutações com Server Actions:** formulários que salvam de verdade, revalidação e validação de entrada;
6. **Do projeto ao ar:** metadados, `next/image`, `next/font`, variáveis de ambiente e deploy.

### Metodologia de Estudo

Crie um projeto novo com `npx create-next-app@latest` e deixe-o rodando ao lado deste livro. O instalador faz algumas perguntas: aceite o Tailwind e o App Router, e recuse o TypeScript por enquanto. Não porque ele seja dispensável, mas porque ele merece um livro inteiro, o Livro IV, e aprender dois assuntos novos ao mesmo tempo só dobra a confusão.

Cada capítulo traz arquivos curtos e completos. Crie cada um no seu projeto, abra o endereço no navegador, e depois abra também o terminal onde o servidor está rodando. Boa parte do que o Next.js faz acontece lá, e não no navegador; um `console.log` que aparece no terminal em vez do console do navegador ensina mais sobre Server Components do que qualquer diagrama.
