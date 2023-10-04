var map = new L.Map("mapaUA", { center: [40.633258, -8.659097], zoom: 15 });
var osmUrl = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
var osmAttrib = "Map data OpenStreetMap contributors";
var osm = new L.TileLayer(osmUrl, { attribution: osmAttrib });
map.addLayer(osm);

var pontos = [
    L.marker([40.633258, -8.659097]),
];
for (i in pontos) {
    pontos[i].addTo(map);
}
/*****************Rating******************/
const btn = document.querySelector(".button");
const post = document.querySelector(".post");
const widget = document.querySelector(".star-widget");
const editBtn = document.querySelector(".edit");
btn.onclick = () => {
    widget.style.display = "none";
    post.style.display = "block";
    editBtn.onclick = () => {
        widget.style.display = "block";
        post.style.display = "none";
    }
    return false;
}