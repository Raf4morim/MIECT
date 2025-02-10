function enviarMensagem() {

    var category = document.getElementById("category").value;
    var name = document.getElementById("name").value;
    var quantidade = document.getElementById("quantidade").value;
    var preco = document.getElementById("preco").value;
    var campos = [];

    if (category != 1) {
        campos.push("Categoria");
    }

    if (name.length == 0) {
        campos.push("Nome");
    }

    if (!isPositiveInteger(quantidade)) {
        campos.push("Quantidade");
    }

    if (!isPositiveFloat(preco)) {
        campos.push("Preço");
    }

    if (campos.length == 0) {
        alert("Stock atualizado com sucesso!");
        window.location = "stock.html";
    } else {
        alert("Campos inválidos: " + campos.toString());
    }
}

function isPositiveInteger(str) {
    if (typeof str !== 'string') {
        return false;
    }

    const num = Number(str);

    if (Number.isInteger(num) && num > 0) {
        return true;
    }

    return false;
}

function isPositiveFloat(s) {
    return !isNaN(s) && Number(s) > 0;
}
