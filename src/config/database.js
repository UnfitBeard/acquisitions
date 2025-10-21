import 'dotenv/config';

import { neon } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';

const db = drizzle(sql);
const sql = neon(process.env.DATABASE_URL);

export { db, sql };
