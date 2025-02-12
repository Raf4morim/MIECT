// Create a new document in the database
const createDocument = async (model, data, maxRetries = 1, retryDelay = 1000) => {
    try {
        const newDocument = await model.create(data);
        return newDocument;
    }
    catch (error) {
        if (maxRetries > 0) {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return createDocument(model, data, maxRetries - 1, retryDelay + 250);
        }
        else {
            throw error;
        }
    }
};

// Read a single document from the database
const readDocument = async (model, id, maxRetries = 1, retryDelay = 1000) => {
    try {
        const document = await model.findById(id);
        return document;
    }
    catch (error) {
        if (maxRetries > 0) {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return readDocument(model, id, maxRetries - 1, retryDelay + 250);
        }
        else {
            throw error;
        }
    }
};

// Read all documents from the database, accepting optional query parameters
const readAllDocuments = async (model, query = {}, limit = 25, offset = 0, maxRetries = 1, retryDelay = 1000) => {
    try {
        let allDocuments;
        if (Object.keys(query).length === 0) {
            allDocuments = await model.find().limit(limit).skip(offset);
        }
        else {
            allDocuments = await model.find(query).limit(limit).skip(offset);
        }
        return allDocuments;
    }
    catch (error) {
        if (maxRetries > 0) {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return readAllDocuments(model, query, limit, offset, maxRetries - 1, retryDelay + 250);
        }
        else {
            throw error;
        }
    }
};

// Update a single document in the database
const updateDocument = async (model, id, data, maxRetries = 1, retryDelay = 1000) => {
    try {
        const updatedDocument = await model.findByIdAndUpdate(id, data, { new: true });
        return updatedDocument;
    }
    catch (error) {
        if (maxRetries > 0) {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return updateDocument(model, id, data, maxRetries - 1, retryDelay + 250);
        }
        else {
            throw error;
        }
    }
};

// Delete a single document from the database
const deleteDocument = async (model, id, maxRetries = 1, retryDelay = 1000) => {
    try {
        const deletedDocument = await model.findByIdAndDelete(id);
        return deletedDocument;
    }
    catch (error) {
        if (maxRetries > 0) {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return deleteDocument(model, id, maxRetries - 1, retryDelay + 250);
        }
        else {
            throw error;
        }
    }
};

// Delete multiple documents from the database according to fields
const deleteManyDocuments = async (model, fields, maxRetries = 1, retryDelay = 1000) => {
    try {
        const deletedDocuments = await model.deleteMany(fields);
        return deletedDocuments;
    } catch (error) {
        if (maxRetries > 0) {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return deleteManyDocuments(model, fields, maxRetries - 1, retryDelay + 250);
        } else {
            throw error;
        }
    }
};

// Export
const dbOperation = {
    createDocument,
    readDocument,
    readAllDocuments,
    updateDocument,
    deleteDocument,
    deleteManyDocuments
};

export default dbOperation;
