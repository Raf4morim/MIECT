import { MongoClient, ObjectId } from 'mongodb';
import { connect, connectToApiKeys, closeConnection } from './database/db.js';
import { validateSearchInput } from './validators/inputValidation.js';
import { authenticateWithApiKey, generateApiKey } from './authUtils.js';
import dotenv from 'dotenv';
import bcrypt from 'bcrypt';
dotenv.config();

const hashPassword = async (password) => {
    const saltRounds = 10;
    return await bcrypt.hash(password, saltRounds);
}

// Function to connect to MongoDB and execute the query
const searchPointsOfInterest = async (_, { searchInput, apiKey }) => {
    await authenticateWithApiKey(_, _, _, { apiKey: apiKey });
    
    // Validate the search input
    validateSearchInput(searchInput);

    try {
        const collection = await connect();

        // Construct the filter based on the search input
        const filter = {};

        if (searchInput._id) {
            filter['_id'] = ObjectId.createFromHexString(searchInput._id);
        }

        if (searchInput.locationName) {
            // Case-insensitive regex to match the location name
            filter['locationName'] = {
                $regex: new RegExp(searchInput.locationName, 'i')
            };
        }

        if (searchInput.category) {
            // Case-insensitive to capital letters
            filter['category'] = {
                $regex: new RegExp(searchInput.category, 'i')
            };
        }
        
        // Add conditions based on the search input
        if (searchInput.location) {
            filter['location'] = {
                $near: {
                    $geometry: {
                        type: 'Point',
                        coordinates: searchInput.location.coordinates
                    },
                    $maxDistance: searchInput.radius
                }
            };
        }

        // Execute the query
        const result = await collection.find(filter).toArray();

        if (result.length === 0) {
            throw new Error('No points of interest found');
        }

        return result;
    } catch (error) {
        if (error.message === 'No points of interest found') {
            throw error;
        } else {
            console.error('Error executing MongoDB query:', error);
            throw new Error('Internal server error');
        }
    } finally {
        closeConnection();
    }
};

const resolvers = {
    Query: {
        searchPointsOfInterest,
        recoverApiKey: async (_, { clientName, password }) => {
            // check if client has an API key
            // if so, recover the API key

            let apiKey = null;
            try {
                const collection = await connectToApiKeys();

                const result = await collection.findOne({ clientName: clientName });
                if(!result) {
                    throw new Error('Client not found');
                }

                //Verify if the provided password matches the stored hashed password
                const storedHashedPassword = result.password;
                const passwordMatch = await bcrypt.compare(password, storedHashedPassword);
                if (!passwordMatch) {
                    throw new Error('Incorrect password');
                }

                return result.apiKey;
            } catch (error) {
                if (error.message === 'Client not found' || error.message === 'Incorrect password') {
                    throw error;
                } else {
                    console.error('Error recovering API key:', error);
                    throw new Error('Internal server error');
                }
            } finally {
                closeConnection();
            }
        }
    },
    Mutation: {
        createPointOfInterest: async (_, { input, apiKey }) => {
            await authenticateWithApiKey(_, _, _, { apiKey: apiKey });

            try {
                const collection = await connect();

                // Convert the name to a case-insensitive regex pattern
                const nameRegex = new RegExp('^' + input.name + '$', 'i');

                // Check if a point of interest with a similar name already exists (case-insensitive)
                const existingPointOfInterest = await collection.findOne({ name: { $regex: nameRegex } });

                // If an existing point of interest with the same name is found, return it
                if (existingPointOfInterest) {
                    return {
                        poi: existingPointOfInterest,
                        message: 'A point of interest with that name already exists, returning existing point of interest'
                    };
                }

                // Check if a point of interest is already within 100 meters of the new one
                const nearbyPointOfInterest = await collection.findOne({
                    location: {
                        $nearSphere: {
                            $geometry: {
                                type: 'Point',
                                coordinates: input.location.coordinates
                            },
                            $maxDistance: 100 
                        }
                    }
                });

                // If a nearby point of interest is found, return it
                if (nearbyPointOfInterest) {
                    return {
                        poi: nearbyPointOfInterest,
                        message: 'A point of interest already exists within 100 meters, returning existing point of interest'
                    };
                }

                const result = await collection.insertOne(input);

                const insertedId = result.insertedId;

                // Fetch the created point of interest using the inserted ID
                const createdPointOfInterest = await collection.findOne({ _id: insertedId });

                return {
                    poi: createdPointOfInterest,
                    message: 'Point of interest created successfully'
                };
            } catch (error) {
                throw new Error('Internal server error');
            } finally {
                closeConnection();
            }
        },
        updatePointOfInterest: async (_, { _id, input, apiKey }) => {
            await authenticateWithApiKey(_, _, _, { apiKey: apiKey });

            try {
                const collection = await connect();

                const result = await collection.findOneAndUpdate(
                    { _id: ObjectId.createFromHexString(_id) },
                    { $set: input },
                    { returnOriginal: false }
                );

                return result;
            } catch (error) {
                console.error('Error updating point of interest:', error);
                throw new Error('Internal server error');
            } finally {
                closeConnection();
            }
        },
        deletePointOfInterest: async (_, { _id, apiKey }) => {
            await authenticateWithApiKey(_, _, _, { apiKey: apiKey });
            try {
                const collection = await connect();

                const result = await collection.deleteOne({ _id: ObjectId.createFromHexString(_id) });
                if (result.deletedCount === 1) {
                    return 'Point of interest deleted successfully';
                } else {
                    throw new Error('Point of interest not found');
                }
            } catch (error) {
                if (error.message === 'Point of interest not found') {
                    throw error;
                } else {
                    console.error('Error deleting point of interest:', error);
                    throw new Error('Internal server error');
                }
            } finally {
                closeConnection();
            }
        },
        generateApiKey: async (_, { clientName, password }) => {
            // check if client already has an API key
            // if not, generate a new API key

            let apiKey = null;
            try {
                const collection = await connectToApiKeys();

                const result = await collection.findOne({ clientName: clientName });
                if (result) {
                    throw new Error('Client already has an API key');
                } 

                const hashedPassword = await hashPassword(password);
                
                apiKey = generateApiKey(clientName);
                await collection.insertOne({ clientName: clientName, apiKey: apiKey, password: hashedPassword });

                return apiKey;
            } catch (error) {
                if (error.message === 'Client already has an API key') {
                    throw error;
                } else {
                    console.error('Error generating API key:', error);
                    throw new Error('Internal server error');
                }
            } finally {
                closeConnection();
            }
        }
    },
};

export default resolvers;