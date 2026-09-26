/**
 * Module 12 checkpoint: transfer amount from one account to another
 * inside a single Postgres transaction using parameterized SQL.
 *
 * Usage:
 *   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/learn \
 *     node transfer.js alice bob 25
 */
import pg from 'pg';

const [, , fromName, toName, amountRaw] = process.argv;

if (!fromName || !toName || amountRaw === undefined) {
  console.error('Usage: node transfer.js <from> <to> <amount>');
  process.exit(1);
}

const amount = Number(amountRaw);
if (!Number.isFinite(amount) || amount <= 0) {
  console.error('amount must be a positive number');
  process.exit(1);
}

const connectionString =
  process.env.DATABASE_URL ||
  'postgresql://postgres:postgres@localhost:5432/learn';

const pool = new pg.Pool({ connectionString, max: 5 });

async function transfer(from, to, amt) {
  if (from === to) {
    throw new Error('from and to must differ');
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    const debit = await client.query(
      `UPDATE app_lab.accounts
          SET balance = balance - $1
        WHERE name = $2 AND balance >= $1
        RETURNING name, balance`,
      [amt, from]
    );
    if (debit.rowCount !== 1) {
      throw new Error(`insufficient funds or unknown account: ${from}`);
    }

    const credit = await client.query(
      `UPDATE app_lab.accounts
          SET balance = balance + $1
        WHERE name = $2
        RETURNING name, balance`,
      [amt, to]
    );
    if (credit.rowCount !== 1) {
      throw new Error(`unknown account: ${to}`);
    }

    await client.query('COMMIT');
    return { from: debit.rows[0], to: credit.rows[0] };
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

async function main() {
  const result = await transfer(fromName, toName, amount);
  console.log('OK', result);
  const { rows } = await pool.query(
    'SELECT name, balance FROM app_lab.accounts ORDER BY name'
  );
  console.table(rows);
}

main()
  .catch((err) => {
    console.error('FAILED:', err.message);
    process.exitCode = 1;
  })
  .finally(() => pool.end());
