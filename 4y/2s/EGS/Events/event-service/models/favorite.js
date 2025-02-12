import mongoose from 'mongoose';

// Define the Favorite schema
const favoriteSchema = new mongoose.Schema({
    eventid:            { type: String, required: true, unique: false, immutable: true },
    userid:             { type: String, required: true, unique: false, immutable: true },
    favoritestatus:     { type: Boolean, required: true, unique: false, immutable: false }
},
{
    collection: 'favorites'
});

// Create the Favorite model
const Favorite = mongoose.model('Favorite', favoriteSchema);

// Export the Favorite model
export default Favorite;
