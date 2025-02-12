// Switch to admin database to create poi_database
const adminDB = db.getSiblingDB('admin');

// Create poi_database
adminDB.createCollection("poi_database");

// Switch to poi_database
const db = db.getSiblingDB('poi_database');

db.POIs.drop();
db.apiKeys.drop();

// Create collections
db.createCollection("POIs");
db.createCollection("apiKeys");

// Create default API key
db.apiKeys.insertOne({
  clientName: "Tigas",
  apiKey: "Tigas:4712b0a1d771938c04e5cba078b0a889",
  password: "$2b$10$vUemVm248PUDU3oH/GSQruO4fMZR1mJitcum4XtJbvgykc6m2pqTC"
});

// Create a geospatial index on the 'location' field in the 'POIs' collection
db.POIs.createIndex({ location: "2dsphere" });

// Insert documents into POIs collection
db.POIs.insertMany([
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b1a"),
    name: "Estádio José Alvalade",
    location: {
      type: "Point",
      coordinates: [-9.1631749, 38.7610731]
    },
    locationName: "Lisboa, Portugal",
    street: "Rua Professor Fernando da Fonseca",
    postcode: "1501-806",
    description: "Estádio José Alvalade is a football stadium in Lisbon, Portugal, home of Sporting Clube de Portugal. It was built adjacent to the site of the older stadium. The stadium is named after José Alvalade, the founder and first club member of Sporting CP in the early twentieth century.",
    category: "landmarks",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/2/29/Lisboa,_Estádio_Alvalade_XXI_(3).jpg",
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b1b"),
    name: "Estádio da Luz",
    location: {
      type: "Point",
      coordinates: [-9.1848976, 38.7470905]
    },
    locationName: "Lisboa, Portugal",
    street: "Avenida Eusébio da Silva Ferreira",
    postcode: "1500-313",
    description: "Estádio da Luz, officially named Estádio do Sport Lisboa e Benfica, is a multi-purpose stadium located in Lisbon, Portugal. It is used mostly for association football matches, hosting the home games of Portuguese club Benfica, its owner.",
    category: "landmarks",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Estadio_Benfica_April_2013-1.jpg/1920px-Estadio_Benfica_April_2013-1.jpg",
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b1c"),
    name: "Jardim Zoológico de Lisboa",
    location: {
      type: "Point",
      coordinates: [-9.1801003, 38.7435081]
    },
    locationName: "Lisboa, Portugal",
    street: "Praça Marechal Humberto Delgado",
    postcode: "1549-004",
    description: "Jardim Zoologico de Lisboa is a zoological garden in Lisbon, Portugal, founded in 1884. It hosts about 2000 animals of more than 300 species, and welcomes around 800000 visitors each year.",
    category: "nature",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/2/28/Jardim_Zoologico_Lisboa_1.JPG",
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b1d"),
    name: "Museu Calouste Gulbenkian",
    location: {
      type: "Point",
      coordinates: [-9.1512964, 38.7389091]
    },
    locationName: "Lisboa, Portugal",
    street: "Avenida de Berna 45A",
    postcode: "1067-001",
    description: "Calouste Gulbenkian Museum houses one of the world's most important private art collections. It includes works from Ancient Egypt to the early 20th century.",
    category: "culture",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/4/4e/Museu_Calouste_Gulbenkian_(Main_Entrance).jpg",
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b1e"),
    name: "MEO Arena",
    location: {
      type: "Point",
      coordinates: [-9.0963241, 38.7717411]
    },
    locationName: "Lisboa, Portugal",
    street: "Rossio dos Olivais",
    postcode: "1990-231",
    description: "MEO Arena is a multi-purpose indoor arena in Lisbon, Portugal. The arena is among the largest indoor arenas in Europe and the largest in Portugal with a capacity of 20000 people and was built in 1998 for Expo 98.",
    category: "culture",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Pavilhao_Atlantico_EXPO_98_Atlantico-Pavillon_im_Parque_das_Nações_Lissabon_Portugal_Foto_Wolfgang_Pehlemann_P1080148.jpg/1920px-Pavilhao_Atlantico_EXPO_98_Atlantico-Pavillon_im_Parque_das_Nações_Lissabon_Portugal_Foto_Wolfgang_Pehlemann_P1080148.jpg",
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b2a"),
    name: "Praia da Marinha",
    location: {
      type: "Point",
      coordinates: [-8.406331708, 37.08749965]
    },
    locationName: "Algarve, Portugal",
    postcode: "8400-407",
    description: "Praia da Marinha is one of the most emblematic and beautiful beaches in the Algarve region. It features stunning cliffs, crystal-clear waters, and golden sand.",
    category: "Nature",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/b/bd/Praia_da_Marinha_(2012-09-27)%2C_by_Klugschnacker_in_Wikipedia_(86).JPG",
    event_ids: ["event1", "event2"]
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b2b"),
    name: "Jardim Botânico de Coimbra",
    location: {
      type: "Point",
      coordinates: [-8.420713, 40.205148]
    },
    locationName: "Coimbra, Portugal",
    street: null,
    postcode: null,
    description: "The Coimbra Botanical Garden is a beautiful botanical garden located in the heart of Coimbra. It features a diverse collection of plants and trees from around the world.",
    category: "Nature",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/8/8b/Karinecyril_coimbra_jardin_1.jpg",
    event_ids: ["event3"]
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b2c"),
    name: "Rio Mondego",
    location: {
      type: "Point",
      coordinates: [-8.429349, 40.20552]
    },
    locationName: "Coimbra, Portugal",
    description: "The Mondego River is the longest river entirely within Portuguese territory. It flows through Coimbra, offering picturesque views and recreational activities.",
    category: "Nature",
    thumbnail: "https://upload.wikimedia.org/wikipedia/commons/8/83/Coimbra_e_o_rio_Mondego_(6167200429).jpg",
    event_ids: ["event4", "event5"]
  },
  {
    _id: ObjectId("5f8f4b3b9b3e6b1f3c1e4b2d"),
    name: "Restaurante Espeto do Sul",
    location: {
      type: "Point",
      coordinates: [-8.649476, 40.635707]
    },
    locationName: "Aveiro, Portugal",
    street: "R. de São Sebastião 97",
    postcode: "3810-187",
    description: "O sabor único do genuíno rodízio brasileiro conquista Aveiro, sendo o mais típico restaurante brasileiro onde cada refeição é uma festa!",
    category: "Food",
    thumbnail: "https://media-cdn.tripadvisor.com/media/photo-s/21/5c/7e/87/prato-de-rodizio.jpg",
    event_ids: ["event6"]
  }
]);