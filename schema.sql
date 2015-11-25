-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:

DROP TABLE IF EXISTS groceries, comments;

-- Define your schema here:

CREATE TABLE groceries (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body TEXT NOT NULL,
  grocery_id INTEGER REFERENCES groceries (id)
)
