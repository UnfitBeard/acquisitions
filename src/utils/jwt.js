import jwt from 'jsonwebtoken';
import logger from '#config/logger.js';

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-should-be-here';
const EXPIRATION_TIME = '1d';
const jwtsign = {
  sign: payload => {
    try {
      return jwt.sign(payload, JWT_SECRET, { expiresIn: EXPIRATION_TIME });
    } catch (error) {
      logger.error('Failed to sign JWT token', error);
      throw new Error('JWT error');
    }
  },
  verify: token => {
    try {
      return jwt.verify(token, JWT_SECRET);
    } catch (error) {
      logger.error('Failed to verify JWT token', error);
      throw new Error('JWT error');
    }
  },
};

export default jwtsign;
