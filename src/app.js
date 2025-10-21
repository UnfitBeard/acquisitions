import express from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app = express();

app.get('/', (req, res) => {
  res.status(200).send('Hello from acquisitions');
});

export default app;
