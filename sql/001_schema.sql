CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_name TEXT NOT NULL
);

CREATE TABLE pages (
    page_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    url TEXT NOT NULL
);

CREATE TABLE gsc_daily (
    id SERIAL PRIMARY KEY,
    page_id INT REFERENCES pages(page_id),
    date DATE,
    clicks INT,
    impressions INT,
    position FLOAT
);

CREATE TABLE ga4_daily (
    id SERIAL PRIMARY KEY,
    page_id INT REFERENCES pages(page_id),
    date DATE,
    sessions INT,
    conversions INT
);

CREATE TABLE crawl_issues (
    issue_id SERIAL PRIMARY KEY,
    page_id INT REFERENCES pages(page_id),
    issue_type TEXT
);