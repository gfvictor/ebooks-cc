\newpage
\pagenumbering{Roman}
\pagestyle{plain}

### Prefácio

Você terminou o Livro I. Sabe o que é o modelo de caixa, sabe por que a cascata resolve empate por especificidade e ordem, sabe montar um layout com Flexbox e Grid sem pedir ao Claude ou Gemini "como centralizar uma div" pela enésima vez. Parabéns - você tem CSS de verdade na cabeça agora.

Só que, na prática, você vai abrir um projeto profissional qualquer e ver um HTML cheio de classes parecidas com `flex items-center justify-between gap-4 rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white`. Sua primeira reação vai ser choque: "isso não é o oposto de tudo que a gente aprendeu sobre separar estilo de estrutura?" É uma reação honesta, e este livro existe para responder a ela direito, em vez de mandar você simplesmente confiar no hype.

Tailwind é um framework utilitário: em vez de criar uma classe `.botao-primario` e definir o que ela significa numa folha separada, você compõe o visual direto na marcação, com classes pequenas, previsíveis e já prontas. Parece regressão até você perceber que é o oposto: você não perde o controle do CSS que aprendeu no Livro I, só para de reescrever a mesma decisão de design com um nome novo toda vez.

### O Que Você Vai Aprender

Este é o Livro II da coletânea **Fundamentos da Web Moderna**. Ele assume que você já domina o Livro I - tudo aqui continua sendo CSS de verdade, só que escrito de outro jeito:

1. **Por que utilitário primeiro:** o problema real que o Tailwind resolve, e os contra-argumentos honestos contra ele;
2. **Anatomia de uma classe:** a escala de espaçamento, cores e tipografia por trás de cada utilitário;
3. **Responsividade e estados:** breakpoints, `hover:`, `focus:`, `disabled:`, `group`/`peer` e tema escuro;
4. **Layout na prática:** Flexbox e Grid com Tailwind, e o papel do `container`;
5. **Tema e tokens de design:** a `@theme` da v4, as variáveis CSS por trás dela, e quando usar (ou não) `@apply`;
6. **Componentização:** quando extrair um componente em vez de empilhar utilitário, com uma palavra sobre `clsx` e `cva`.

### Metodologia de Estudo

Instale o Tailwind num projeto de teste, ou abra o playground oficial, e deixe aberto ao lado deste livro. Cada utilitário que aparecer aqui, você digita, vê o resultado, e - o mais importante - abre o inspecionar do navegador para ver que CSS de verdade está saindo dali. Se o Livro I te ensinou a ler a cascata, este te ensina a escrever nela mais rápido, não a ignorá-la.
