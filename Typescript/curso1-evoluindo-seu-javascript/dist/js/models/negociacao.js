export class Negociacao{ // 'export' permite que o conteúdo dessa classe seja acessado fora do módulo
    #data; // quando colocamos # significa que é um atributo privado.
    #quantidade;
    #valor;

    constructor(data, quantidade, valor){
        this.#data = data;
        this.#quantidade = quantidade;
        this.#valor = valor;
    }

    get data() { // o método get permite que acessemos valores privados da classe como leitura
        return this.#data
    }

    get quantidade() {
        return this.#quantidade
    }

    get valor() {
        return this.#valor
    }

    get volume() {
        return this.#quantidade * this.#valor;
    }
}