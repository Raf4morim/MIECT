import express from 'express';
import routeLogger from '../middleware/routeLogging.js';
import authValidator from '../middleware/authValidation.js';
import dataValidator from '../middleware/dataValidation.js';
import eventController from '../controllers/eventController.js';

// Create a new instance of the express router
const routerEvents = express.Router();

/**
 * @swagger
 * /e1/events:
 *   post:
 *     tags:
 *       - Events
 *     summary: Create a new event
 *     description: Creates a new event. At least one field from [pointofinterestid, pointofinterest] must be provided. 
 *                  If both are provided, pointofinterestid will be given priority and pointofinterest will be ignored.
 *                  If neither is provided, the request will be rejected.
 *                  If pointofinterestid is not provided but pointofinterest is, its data will be used to create a new point of interest. 
 *     security:
 *       - ApiKeyAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Event_Request'
 *     responses:
 *       201:
 *         $ref: '#/components/responses/Created_201'
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       409:
 *         $ref: '#/components/responses/Conflict_409'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 *       502:
 *         $ref: '#/components/responses/BadGateway_502'
 */
routerEvents.post('/events', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, dataValidator.isValidBody, async (req, res) => {
    await eventController.createEvent(req, res);
});

/**
 * @swagger
 * /e1/events:
 *   get:
 *     tags:
 *       - Events
 *     summary: Get all events
 *     description: Fetches all events, with optional query parameters. If not provided, calendarid with value 1 (superuser) will be used as default. For location based search, longitude, latitude and radius parameters must be provided.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: limit
 *         in: query
 *         description: Maximum number of events to return
 *         required: false
 *         schema:
 *           type: integer
 *           format: int32
 *           default: 25
 *           minimum: 1
 *           maximum: 50
 *       - name: offset
 *         in: query
 *         description: Number of events to skip for pagination
 *         required: false
 *         schema:
 *           type: integer
 *           format: int32
 *           default: 0
 *           minimum: 0
 *       - name: calendarid
 *         in: query 
 *         description: Events currently added in this calendar
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 1024
 *       - name: pointofinterestid
 *         in: query 
 *         description: Events associated with this point of interest
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 1024
 *       - name: userid
 *         in: query 
 *         description: Events created by this user
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 1024
 *       - name: name
 *         in: query
 *         description: Name of the event (can be a partial/full match). It is case-insensitive
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 256
 *       - name: organizer
 *         in: query
 *         description: Name of the event organizer (can be a partial/full match). It is case-insensitive
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 256
 *       - name: category
 *         in: query
 *         description: Category of the event (can be a partial/full match). It is case-insensitive
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 256
 *       - name: location
 *         in: query
 *         description: City/Country where the event is taking place (can be a partial/full match). It is case-insensitive
 *         required: false
 *         schema:
 *           type: string
 *           minLength: 1
 *           maxLength: 256
 *       - name: maxprice
 *         in: query
 *         description: Maximum price of the event, including. It is case-insensitive
 *         required: false
 *         schema:
 *           type: string
 *           pattern: '^(\d+\.\d{2})$' 
 *       - name: startdate
 *         in: query
 *         description: Events that start at this date (must be an exact match). If given, will make the system ignore the beforedate and/or afterdate query parameters should they exist. It is case-sensitive
 *         required: false
 *         schema:
 *           type: string
 *           format: date-time  
 *       - name: beforedate
 *         in: query
 *         description: Events that end before or at this date (must be an exact match). It is case-sensitive
 *         required: false
 *         schema:
 *           type: string
 *           format: date-time
 *       - name: afterdate
 *         in: query
 *         description: Events that start at and after this date (must be an exact match). It is case-sensitive
 *         required: false
 *         schema:
 *           type: string
 *           format: float
 *       - name: longitude
 *         in: query
 *         description: Used for location based search. Will be ignored if latitude and radius parameters are not provided
 *         required: false
 *         schema:
 *           type: string
 *           format: float
 *       - name: latitude
 *         in: query
 *         description: Used for location based search. Will be ignored if longitude and radius parameters are not provided
 *         required: false
 *         schema:
 *           type: string
 *           format: float
 *       - name: radius
 *         in: query
 *         description: Used for location based search (unit is meter). Will be ignored if longitude and latitude parameters are not provided
 *         required: false
 *         schema:
 *           type: string
 *           format: float
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Event_Response'
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 *       502:
 *         $ref: '#/components/responses/BadGateway_502'
 */
routerEvents.get('/events', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, dataValidator.isValidQuery, async (req, res) => {
    await eventController.readAllEvents(req, res);
});

/**
 * @swagger
 * /e1/events/{uuid}:
 *   get:
 *     tags:
 *       - Events
 *     summary: Get an event
 *     description: Fetches a single event.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event to fetch
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *                 $ref: '#/components/schemas/Event_Response'
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 *       502:
 *         $ref: '#/components/responses/BadGateway_502'
 */
routerEvents.get('/events/:uuid', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, dataValidator.isValidUUID, async (req, res) => {
    await eventController.readEvent(req, res);
});

/**
 * @swagger
 * /e1/events/{uuid}:
 *   put:
 *     tags:
 *       - Events
 *     summary: Update an event
 *     description: Updates an event with the provided data. At least one field from [pointofinterestid, pointofinterest] must be provided. If both are provided, pointofinterestid will be given priority and pointofinterest will be ignored. If neither is provided, the request will be rejected. If pointofinterestid is not provided but pointofinterest is, its data will be used to create a new point of interest. Can only be performed by the event creator.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event to update
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Event_Request'
 *     responses:
 *       200:
 *         description: OK
 *         headers:
 *           Location:
 *             description: URI where the updated resource can be found
 *             schema:
 *               type: string
 *       400:
 *         $ref: '#/components/responses/BadRequest_400'
 *       401:
 *         $ref: '#/components/responses/Unauthorized_401'
 *       403:
 *         $ref: '#/components/responses/Forbidden_403'
 *       404:
 *         $ref: '#/components/responses/NotFound_404'
 *       409:
 *         $ref: '#/components/responses/Conflict_409'
 *       500:
 *         $ref: '#/components/responses/InternalServerError_500'
 *       502:
 *         $ref: '#/components/responses/BadGateway_502'
 */
routerEvents.put('/events/:uuid', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, authValidator.isOperationAllowed, dataValidator.isValidUUID, dataValidator.isValidBody, async (req, res) => {
    await eventController.updateEvent(req, res);
});

/**
 * @swagger
 * /e1/events/{uuid}/favorite:
 *   patch:
 *     tags:
 *       - Events
 *     summary: Add/Remove a favorite from an event
 *     description: Adds/Removes a favorite from an event. When adding, it will add the event to the user calendar and update event favorite count. When removing, it will remove the event from the user calendar and update event favorite count.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event to update
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Favorite'
 *     responses:
 *       200:
 *         description: OK
 *         headers:
 *           Location:
 *             description: URI where the updated resource can be found
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
 *       502:
 *         $ref: '#/components/responses/BadGateway_502'
 */
routerEvents.patch('/events/:uuid/favorite', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey, dataValidator.isValidUUID, dataValidator.isValidFavorite, async (req, res) => {
    await eventController.favoriteEvent(req, res);
});

/**
 * @swagger
 * /e1/events/{uuid}:
 *   delete:
 *     tags:
 *       - Events
 *     summary: Delete an event
 *     description: Deletes an event. Can only be performed by the event creator.
 *     security:
 *       - ApiKeyAuth: []
 *     parameters:
 *       - name: uuid
 *         in: path
 *         description: UUID of the event to delete
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
 *       502:
 *         $ref: '#/components/responses/BadGateway_502'
 */
routerEvents.delete('/events/:uuid', routeLogger.request, routeLogger.response, authValidator.isValidAuthKey,  authValidator.isOperationAllowed, dataValidator.isValidUUID, async (req, res) => {
    await eventController.deleteEvent(req, res);
});

// Export the router
export default routerEvents;
