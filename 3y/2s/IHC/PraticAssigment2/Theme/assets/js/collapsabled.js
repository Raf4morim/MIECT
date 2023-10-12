var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var contentVerMais = this.nextElementSibling;
    if (contentVerMais.style.maxHeight){
      contentVerMais.style.maxHeight = null;
    } else {
      contentVerMais.style.maxHeight = contentVerMais.scrollHeight + "px";
    } 
  });
}