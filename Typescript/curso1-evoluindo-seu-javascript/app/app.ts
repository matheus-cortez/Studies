// o app.js é o arquivo principal do JS, o main
// nota: console.log() consegue ser visto no navegador ao ver o console durante a inspeção
import { Negociacao } from './models/negociacao.ts';

const negociacao = new Negociacao(new Date(), 10, 100);
// console.log(negociacao);
// ao fazer isso, um novo atributo dinâmico 'quantidade' é criado, mas o JS mantém o valor privado intacto
// negociacao.quantidade = 10000;
// em typescript, isso não seria possível de ser colocado em produção, enquanto que em JS
// só perceberíamos o equívoco em run-time.

// quando se trata de método get, podemos acessar como se fosse uma propriedade
console.log(negociacao.volume);

// a partir daqui, pensaremos em typescript. ao compilar o arquivo TS, nosso código em JS
// irá aprecer em dist.
