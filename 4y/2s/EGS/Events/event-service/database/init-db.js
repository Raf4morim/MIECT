// Initialize the database 
const adminDB = db.getSiblingDB('admin');
adminDB.createCollection('Event_Service');
const db = db.getSiblingDB('Event_Service');

// Create collections
db.createCollection('apikeys');
db.createCollection('events');
db.createCollection('favorites');

// Insert data into the collections
db.apikeys.insertOne({
    _id: '687533bec180f8a988c925a11fc88373173fe0328be2737a578475754da26da1',
    appid: 'app_id_17bb81a7-8682-4d0a-b3aa-1efcfae103a2',
    active: true
});

db.events.insertMany([
    {
        _id: 'cac80a76-72a5-4845-a630-10fabe049caa',
        userid: '1',
        organizer: 'Portuguese Football Federation',
        category: 'sports',
        contact: 'fpf@support.com',
        price: 60.00,
        currency: 'EUR',
        favorites: 1,
        maxparticipants: 50095,
        currentparticipants: 50000,
        calendarid: '1',
        pointofinterestid: '5f8f4b3b9b3e6b1f3c1e4b1a'
    },
    {
        _id: '5034bfc8-e761-4426-9fa4-c1a276bf163f',
        userid: '1',
        organizer: 'UEFA Champions League',
        category: 'sports',
        contact: 'UCL@support.com',
        price: 90.00,
        currency: 'EUR',
        favorites: 1,
        maxparticipants: 50095,
        currentparticipants: 50095,
        calendarid: '1',
        pointofinterestid: '5f8f4b3b9b3e6b1f3c1e4b1a'
    },
    {
        _id: '4c6ce530-c1f2-424f-a261-2fabaf533679',
        userid: '1',
        organizer: 'Portuguese Football Federation',
        category: 'sports',
        contact: 'fpf@support.com',
        price: 40.50,
        currency: 'EUR',
        favorites: 1,
        maxparticipants: 65000,
        currentparticipants: 40000,
        calendarid: '1',
        pointofinterestid: '5f8f4b3b9b3e6b1f3c1e4b1b'
    },
    {
        _id: '41378065-359b-42f3-84e5-8b29dc20c532',
        userid: '1',
        organizer: 'Lisbon Municipal Zoo',
        category: 'culture',
        contact: 'zoo@support.com',
        price: 29.00,
        currency: 'EUR',
        favorites: 1,
        maxparticipants: 2500,
        currentparticipants: 900,
        calendarid: '1',
        pointofinterestid: '5f8f4b3b9b3e6b1f3c1e4b1c'
    },
    {
        _id: '21cd4b9a-8ef0-4824-9038-88eb038ae16d',
        userid: '1',
        organizer: 'Gulbenkian Foundation',
        category: 'culture',
        contact: 'museum@support.com',
        price: 100.00,
        currency: 'EUR',
        favorites: 1,
        maxparticipants: 100,
        currentparticipants: 35,
        calendarid: '1',
        pointofinterestid: '5f8f4b3b9b3e6b1f3c1e4b1d'
    },
    {
        _id: '8a53079e-8093-4022-8e76-10543e42c03e',
        userid: '1',
        organizer: 'Everything Is New',
        category: 'culture',
        contact: 'meo@support.com',
        price: 69.99,
        currency: 'EUR',
        favorites: 1,
        maxparticipants: 20000,
        currentparticipants: 15000,
        calendarid: '1',
        pointofinterestid: '5f8f4b3b9b3e6b1f3c1e4b1e'
    },
]);

db.favorites.insertMany([
    {
        eventid: 'cac80a76-72a5-4845-a630-10fabe049caa',
        userid: '1',
        favoritestatus: true
    },
    {
        eventid: '5034bfc8-e761-4426-9fa4-c1a276bf163f',
        userid: '1',
        favoritestatus: true
    },
    {
        eventid: '4c6ce530-c1f2-424f-a261-2fabaf533679',
        userid: '1',
        favoritestatus: true
    },
    {
        eventid: '41378065-359b-42f3-84e5-8b29dc20c532',
        userid: '1',
        favoritestatus: true
    },
    {
        eventid: '21cd4b9a-8ef0-4824-9038-88eb038ae16d',
        userid: '1',
        favoritestatus: true
    },
    {
        eventid: '8a53079e-8093-4022-8e76-10543e42c03e',
        userid: '1',
        favoritestatus: true
    }
]);
