import { S3Client, PutObjectCommand, GetObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import config from "../config/config.js";

// Create credentials structure
const cred = {
    credentials: {
        accessKeyId: config.amazonS3.accessKeyId,
        secretAccessKey: config.amazonS3.secretAccessKey,
    },
    region: config.amazonS3.region,
    endpoint: config.amazonS3.url,
    forcePathStyle: config.amazonS3.forcePathStyle
}

// Upload a file to the storage service
const uploadFile = async (fileData, newFileName) => {
    try {
        // Generate the file name
        const fileName = 'event_' + newFileName + '.jpeg';

        // Upload the file
        const client = new S3Client(cred);
        await client.send(new PutObjectCommand({
            Body: fileData.buffer,
            Bucket: config.amazonS3.bucket,
            Key: fileName
        }));

    } catch (error) {
        throw error;
    }
};

// Download a file from the storage service
const downloadFile = async (newFileName) => {
    try {
        // Generate the file name
        const fileName = 'event_' + newFileName + '.jpeg';

        // Download the file data
        const client = new S3Client(cred);
        const result = await client.send(new GetObjectCommand({
            Bucket: config.amazonS3.bucket,
            Key: fileName,
        }));

        // Convert the file data to a buffer and return it
        const chunks = [];
        for await (const chunk of result.Body) {
            chunks.push(chunk);
        }
        const buffer = Buffer.concat(chunks);

        return {
            buffer: buffer,
            name: fileName,
            type: 'image/jpeg'
        };

    } catch (error) {
        throw error;
    }
};

// Delete a file from the storage service
const deleteFile = async (fileName) => {
    try {
        // Generate the file name
        const fileToDelete = 'event_' + fileName + '.jpeg';

        // Delete the file
        const client = new S3Client(cred);
        await client.send(new DeleteObjectCommand({
            Bucket: config.amazonS3.bucket,
            Key: fileToDelete,
        }));

    } catch (error) {
        throw error;
    }
};

// Export
const amazonS3 = {
    uploadFile,
    downloadFile,
    deleteFile
};

export default amazonS3;
