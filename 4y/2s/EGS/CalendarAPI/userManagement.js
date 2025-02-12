const db = require('./database/database'); 

async function findOrCreateUser({ googleId, email, name }) {
    let query = 'SELECT * FROM users WHERE google_id = ?';
    try {
        const pool = db.getPool();
        const [users] = await pool.query(query, [googleId]);
        if (users.length > 0) {
            return users[0];
        } else {
            query = 'INSERT INTO users (google_id, email, name) VALUES (?, ?, ?)';
            const [result] = await pool.query(query, [googleId, email, name]);
            return {
                id: result.insertId,
                googleId,
                email,
                name
            };
        }
    } catch (error) {
        console.error('Database operation failed:', error);
        throw error;
    }
}

async function saveUserTokens({userId, accessToken, refreshToken, tokenExpiry, calendarId}) {

    let query = 'SELECT * FROM storeDB WHERE user_id = ?';
    try {
        const pool = db.getPool();
        const [existingUser] = await pool.query(query, [userId]);
        if (existingUser.length > 0) {
            // Se um registro já existir, atualize os tokens
            query = 'UPDATE storeDB SET access_token = ?, refresh_token = ?, token_expiry = ?  WHERE user_id = ?';
            const updateValues = [accessToken, refreshToken, tokenExpiry, userId];
            await db.query(query, updateValues);
        } else {
            // Se nenhum registro existir, insira um novo
            query = 'INSERT INTO storeDB (user_id, access_token, refresh_token, token_expiry) VALUES (?, ?, ?, ?)';
            const insertValues = [userId, accessToken, refreshToken, tokenExpiry ];
            await db.query(query, insertValues);
        }
    } catch (error) {
        console.error('Database operation failed:', error);
        throw error;
    }
}




module.exports = {
    findOrCreateUser,
    saveUserTokens,
};
