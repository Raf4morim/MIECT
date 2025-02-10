function validar() {
    var utilizador = document.getElementById("utilizador").value;
    var password = document.getElementById("password").value;
    var mensagem = "";
    if (utilizador.length == 0) {
        mensagem += "Nome de utilizador inválido!<br>";
    }
    if (password.length < 8) {
        mensagem += "Palavra-chave deve ter pelo menos 8 carateres!<br>";
    }

    if (mensagem == "") {
        window.location = "stock.html";
    }

    document.getElementById("message").innerHTML = mensagem;
}