// o app.js é o arquivo principal do JS, o main
// nota: console.log() consegue ser visto no navegador ao ver o console durante a inspeção
import { Negociacao } from './models/negociacao.js';

const negociacao = new Negociacao(new Date(), 10, 100);
// console.log(negociacao);
// ao fazer isso, um novo atributo dinâmico 'quantidade' é criado, mas o JS mantém o valor privado intacto
// negociacao.quantidade = 10000;

// quando se trata de método get, podemos acessar como se fosse uma propriedade
console.log(negociacao.volume);