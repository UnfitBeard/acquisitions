import express, { urlencoded } from 'express';
import dotenv from 'dotenv';
import logger from '#config/logger.js';
import helmet from 'helmet';
import morgan from 'morgan';
import cors from 'cors';
import cookieParser from 'cookie-parser';

dotenv.config();

const app = express();

app.use(cors());
app.use(helmet());
app.use(express.json());
app.use(urlencoded());
app.use(cookieParser());

app.use(
  morgan('combined', {
    stream: { write: message => logger.info(message.trim()) },
  })
);

app.get('/', (req, res) => {
  logger.info('Hello from acquisitions');
  res.status(200).send('Hello from acquisitions');
});

export default app;
