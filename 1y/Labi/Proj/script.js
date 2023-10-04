/*****************Menu Lateral******************/
$('.inovJS').click(function () {
    $('.menuLateral ul .submenu').toggleClass('mostra');
});
$('.painVerdJS').click(function () {
    $('.menuLateral ul ul .submenu1').toggleClass('mostra');
});
$('.btnAbre').click(function () {
    $('.menuLateral').toggleClass('mostra');
});
$('.btnFecha').click(function () {
    $('.menuLateral').toggleClass('mostra');
});
$('.inovJS').mouseover(function () {
    $('.menuLateral ul .seta').toggleClass('gira');
});
$('.painverdJS').mouseover(function () {
    $('.menuLateral ul .seta1').toggleClass('gira1');
});
$('.inovJS').mouseout(function () {
    $('.menuLateral ul .seta').toggleClass('gira');
});
$('.painVerdJS').mouseout(function () {
    $('.menuLateral ul .seta1').toggleClass('gira1');
});
/*Agora quando clicamos fora do menu lateral deixa de mostrar*/
const $menuLateral = $('.menuLateral');
$(document).mouseup(e => {
    if (!$menuLateral.is(e.target) && $menuLateral.has(e.target).length === 0) {
        $menuLateral.removeClass('mostra');
    }
});
/*****************Tema Escuro******************/
function myFunction() {
    var element = document.body;
    element.classList.toggle("dark-mode");
}
/*****************Seleçao do audio******************/
$(document).ready(function () {
    $('#select').on('change', function () {
        var selectValor = '#' + $(this).val();

        $('#pai').children('audio').hide();
        $('#pai').children(selectValor).show();
    });
});
/*****************Parte do slide******************/
var counter = 1;
setInterval(function () {
    document.getElementById('radio' + counter).checked = true;
    counter++;
    if (counter > 4) {
        counter = 1;
    }
}, 5000);
/*****************Ler Mais******************/
function leiaMais() {
    var pontos = document.getElementById("pontos");
    var maisTexto = document.getElementById("mais");
    var btnLeiaMais = document.getElementById("btnLeiaMais");

    if (pontos.style.display === "none") {
        pontos.style.display = "inline";
        maisTexto.style.display = "none";
        btnLeiaMais.innerHTML = "Leia Mais";
    } else {
        pontos.style.display = "none";
        maisTexto.style.display = "inline";
        btnLeiaMais.innerHTML = "Leia Menos";
    }
}
/*****************Botão Return******************/
//chamando a função ao rolar a tela.
window.onscroll = function () {
    scrollFunc();
};
//função para exibir o botão apenas depois de rolar a tela
function scrollFunc() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        document.getElementById("btnTop").style.display = "block";
    } else {
        document.getElementById("btnTop").style.display = "none";
    }
}
function backtoTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}
/*****************Expande Imagens******************/
let imagens = document.querySelectorAll('.imgToExp');
let fundo = document.querySelector('.fundo');
let fundoImg = document.querySelector('#expandImg');
let btnClose = document.querySelector('#btnClose');

//variavel para armazenar o elemento de cada imagem
let srcVal = "";

for (let i = 0; i < imagens.length; i++) {
    imagens[i].addEventListener('click', function () {
        srcVal = imagens[i].getAttribute('src');
        fundoImg.setAttribute('src', srcVal);
        fundo.classList.toggle('fundoAtivo');
    });
}
btnClose.addEventListener('click', function () {
    fundo.classList.toggle('fundoAtivo');
});
