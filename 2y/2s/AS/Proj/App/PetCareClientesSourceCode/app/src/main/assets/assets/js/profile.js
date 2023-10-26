function validate() {

    var nome = document.getElementById("nome").value;
    var sexo = document.getElementById("sexo").value;
    var peso = document.getElementById("peso").value;
    var idade = document.getElementById("idade").value;
    var raça = document.getElementById("raça").value;
    var mensagem = "";

    if (nome.length == 0) {
        mensagem += "Por favor insira um nome!<br>";
    }
    if (sexo != 1) {
        mensagem += "Selecione o sexo do animal!<br>";
    }
    if (!isPositiveFloat(peso)) {
        mensagem += "Peso deve apenas conter algarismos!<br>";
    } else {
        if (peso.length == 0) {
            mensagem += "Insira um peso!<br>";
        }
    }
    if (!/^\d+$/.test(idade) && idade.length != 0) {
        mensagem += "Idade deve apenas conter algarismos!<br>";
    } else {
        if (idade.length == 0) {
            mensagem += "Insira uma idade!<br>";
        }
    }
    if (raça.length == 0) {
        mensagem += "Por favor insira uma raça!<br>";
    }

    if (mensagem == "") {
        window.location = "perfil.html";
    }
    document.getElementById("message").innerHTML = mensagem;
}

function isPositiveFloat(s) {
    return !isNaN(s) && Number(s) > 0;
}