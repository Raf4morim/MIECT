import config from "../config/config.js";
import axios from 'axios';

// Create calendar associated to user
const createUserCalendar = async (userId, maxRetries = 2, retryDelay = 250, timeout = 7500) => {
    try {
        const response = await axios.post(config.calendarService.baseUrl + ':' + config.calendarService.port + '/calendars/users/' + userId,
        {},
        {
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': config.calendarService.apikey
            },
            timeout: timeout,
            signal: newAbortSignal(timeout)
        });

        return processRes(response);

    } catch (error) {
        const err = processErr(error, maxRetries);
        if (err === 'RETRY') {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return createUserCalendar(userId, maxRetries - 1, retryDelay + 250, timeout);
        }
        else if (err === 'ERR_MAX_RETRIES') {
            throw new Error('Maximum retries reached on createUserCalendar', error);
        }
        else if (err === 'ERR_NOT_FOUND') {
            return 'ERR_NOT_FOUND';
        }
        else if (err === 'ERR_GATEWAY') {
            return 'ERR_GATEWAY';
        }
        else {
            throw error;
        }
    }
};

// Add event to calendar
const addEventToCalendar = async (calendarId, eventData, maxRetries = 2, retryDelay = 250, timeout = 7500) => {
    try {
        const response = await axios.post(config.calendarService.baseUrl + ':' + config.calendarService.port + '/calendars/events/' + calendarId,
        {
            ...eventData
        },
        {
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': config.calendarService.apikey
            },
            timeout: timeout,
            signal: newAbortSignal(timeout)
        });

        return processRes(response);

    } catch (error) {
        const err = processErr(error, maxRetries);
        if (err === 'RETRY') {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return addEventToCalendar(calendarId, eventData, maxRetries - 1, retryDelay + 250, timeout);
        }
        else if (err === 'ERR_MAX_RETRIES') {
            throw new Error('Maximum retries reached on addEventToCalendar', error);
        }
        else if (err === 'ERR_NOT_FOUND') {
            return 'ERR_NOT_FOUND';
        }
        else if (err === 'ERR_GATEWAY') {
            return 'ERR_GATEWAY';
        }
        else {
            throw error;
        }
    }
};

// Get events from calendar with optional search parameters
const getEventsFromCalendar = async (calendarId, searchParams, maxRetries = 2, retryDelay = 250, timeout = 7500) => {
    try {
        const params = new URLSearchParams();
        for (const key in searchParams) {
            params.append(key, searchParams[key]);
        }

        const response = await axios.get(config.calendarService.baseUrl + ':' + config.calendarService.port + '/calendars/' + calendarId + '?' + params,
        {
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': config.calendarService.apikey
            },
            timeout: timeout,
            signal: newAbortSignal(timeout)
        });

        return processRes(response);

    } catch (error) {
        const err = processErr(error, maxRetries);
        if (err === 'RETRY') {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return getEventsFromCalendar(calendarId, searchParams, maxRetries - 1, retryDelay + 250, timeout);
        }
        else if (err === 'ERR_MAX_RETRIES') {
            throw new Error('Maximum retries reached on getEventsFromCalendar', error);
        }
        else if (err === 'ERR_NOT_FOUND') {
            return 'ERR_NOT_FOUND';
        }
        else if (err === 'ERR_GATEWAY') {
            return 'ERR_GATEWAY';
        }
        else {
            throw error;
        }
    }
};

// Update event in calendar
const updateEventInCalendar = async (calendarId, eventId, eventData, maxRetries = 2, retryDelay = 250, timeout = 7500) => {
    try {
        const response = await axios.patch(config.calendarService.baseUrl + ':' + config.calendarService.port + '/calendars/' + calendarId + '/' + eventId,
        {
            ...eventData
        },
        {
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': config.calendarService.apikey
            },
            timeout: timeout,
            signal: newAbortSignal(timeout)
        });

        return processRes(response);

    } catch (error) {
        const err = processErr(error, maxRetries);
        if (err === 'RETRY') {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return updateEventInCalendar(calendarId, eventId, eventData, maxRetries - 1, retryDelay + 250, timeout);
        }
        else if (err === 'ERR_MAX_RETRIES') {
            throw new Error('Maximum retries reached on updateEventInCalendar', error);
        }
        else if (err === 'ERR_NOT_FOUND') {
            return 'ERR_NOT_FOUND';
        }
        else if (err === 'ERR_GATEWAY') {
            return 'ERR_GATEWAY';
        }
        else {
            throw error;
        }
    }
};

// Remove event from calendar
const removeEventFromCalendar = async (calendarId, eventId, maxRetries = 2, retryDelay = 250, timeout = 7500) => {
    try {
        const response = await axios.delete(config.calendarService.baseUrl + ':' + config.calendarService.port + '/calendars/' + calendarId + '/' + eventId,
        {
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': config.calendarService.apikey
            },
            timeout: timeout,
            signal: newAbortSignal(timeout)
        });

        return processRes(response);

    } catch (error) {
        const err = processErr(error, maxRetries);
        if (err === 'RETRY') {
            await new Promise(resolve => setTimeout(resolve, retryDelay));
            return removeEventFromCalendar(calendarId, eventId, maxRetries - 1, retryDelay + 250, timeout);
        }
        else if (err === 'ERR_MAX_RETRIES') {
            throw new Error('Maximum retries reached on removeEventFromCalendar', error);
        }
        else if (err === 'ERR_NOT_FOUND') {
            return 'ERR_NOT_FOUND';
        }
        else if (err === 'ERR_GATEWAY') {
            return 'ERR_GATEWAY';
        }
        else {
            throw error;
        }
    }
};

// Process the response received from the service
const processRes = (res) => {
    if (res.status === 200 || res.status === 201 || res.status === 204) {
        return res.data;
    }
    else {
        return 'ERR_GATEWAY';
    }
}

// Process the errors received from the service and thrown by axios
const processErr = (error, maxRetries) => {
    if (axios.isAxiosError(error)) {
        if (!error.response || error.code === 'ECONNABORTED') {
            if (maxRetries > 0) {
                return 'RETRY';
            }
            else {
                return 'ERR_MAX_RETRIES';
            }
        }
        else if (error.response && error.response.status === 404) {
            return 'ERR_NOT_FOUND';
        }
        else {
            return 'ERR_GATEWAY';
        }
    }
    return error;
};

// Create an abort signal with a timeout
const newAbortSignal = (timeoutMs) => {
    const abortController = new AbortController();
    setTimeout(() => abortController.abort(), timeoutMs);
    return abortController.signal;
};

// Export
const calendarService = {
    createUserCalendar,
    addEventToCalendar,
    getEventsFromCalendar,
    updateEventInCalendar,
    removeEventFromCalendar
};

export default calendarService;
