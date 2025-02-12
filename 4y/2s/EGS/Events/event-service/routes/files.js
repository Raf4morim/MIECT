import express from 'express';
import routeLogger from '../middleware/routeLogging.js';
import authValidator from '../middleware/authValidation.js';
import dataValidator from '../middleware/dataValidation.js';
import fileValidator from '../middleware/fileValidation.js';
import fileController from '../controllers/fileController.js';

// Create a new instance of the express router
const routerFiles = express.Router();

/**
 * @swagger
 * /e1/files/{uuid}:
 *   post:
 *     tags:
 *       - Files
 *     summary: Upload a file
 *     description: Uploads to the storage a file associated with a specific event. Can only be performed by the event creator.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event associated with the file
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid 
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               file:
 *                 description: Allows 1 file per request. MIME type must be image/jpeg with a maximum size of 10MB
 *                 type: string
 *                 format: binary
 *               userid:
 *                 type: string
 *                 example: 1
 *     responses:
 *       201:
 *         $ref: '#/components/responses/Created_201'
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       403:
 *         $ref: '#/components/responses/Forbidden_403'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       413:
 *         $ref: '#/components/responses/PayloadTooLarge_413'
 *       415:
 *         $ref: '#/components/responses/UnsupportedMediaType_415'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 */
routerFiles.post('/files/:uuid', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, dataValidator.isValidUUID, fileValidator.isValidFile, authValidator.isOperationAllowed, async (req, res) => {
    await fileController.uploadFile(req, res);
});

/**
 * @swagger
 * /e1/files/{uuid}:
 *   get:
 *     tags:
 *       - Files
 *     summary: Get a file
 *     description: Fetches the download URL of the file associated with a specific event.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event associated with the file
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           image/jpeg:
 *             schema:
 *               type: string
 *               format: binary
 *         headers:
 *           Content-Disposition:
 *             description: Indicates the content is a downloadable attachment, providing a filename for the attachment
 *             schema:
 *               type: string
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 */
routerFiles.get('/files/:uuid', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, dataValidator.isValidUUID, async (req, res) => {
    await fileController.downloadFile(req, res);
});

/**
 * @swagger
 * /e1/files/{uuid}:
 *   delete:
 *     tags:
 *       - Files
 *     summary: Delete a file
 *     description: Deletes the file associated with a specific event. Can only be performed by the event creator.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event associated with the file
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userid:
 *                 type: string
 *                 example: 1
 *     responses:
 *       204:
 *         $ref: '#/components/responses/NoContent_204'
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       403:
 *         $ref: '#/components/responses/Forbidden_403'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 */
routerFiles.delete('/files/:uuid', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, authValidator.isOperationAllowed, dataValidator.isValidUUID, async (req, res) => {
    await fileController.deleteFile(req, res);
});

// Export the router
export default routerFiles;
