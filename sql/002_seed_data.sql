-- Clients
INSERT INTO clients (client_name) VALUES
('Client A'),
('Client B');

-- Pages
INSERT INTO pages (client_id, url) VALUES
(1, 'https://clienta.com/page1'),
(1, 'https://clienta.com/page2'),
(1, 'https://clienta.com/page3'),
(2, 'https://clientb.com/page1'),
(2, 'https://clientb.com/page2');

-- GSC data (last 3 days)
INSERT INTO gsc_daily (page_id, date, clicks, impressions, position) VALUES
(1, '2026-05-23', 10, 100, 5.2),
(1, '2026-05-24', 8, 120, 6.0),
(1, '2026-05-25', 6, 150, 7.5),

(2, '2026-05-23', 20, 200, 3.1),
(2, '2026-05-24', 18, 210, 3.5),
(2, '2026-05-25', 15, 220, 4.0),

(3, '2026-05-23', 5, 80, 9.0),
(3, '2026-05-24', 4, 90, 9.5),
(3, '2026-05-25', 3, 100, 10.0),

(4, '2026-05-23', 12, 110, 4.5),
(4, '2026-05-24', 11, 115, 4.8),
(4, '2026-05-25', 9, 130, 5.5),

(5, '2026-05-23', 7, 95, 6.5),
(5, '2026-05-24', 6, 100, 7.0),
(5, '2026-05-25', 5, 105, 7.8);

-- GA4 data
INSERT INTO ga4_daily (page_id, date, sessions, conversions) VALUES
(1, '2026-05-23', 50, 2),
(1, '2026-05-24', 45, 1),
(1, '2026-05-25', 40, 1),

(2, '2026-05-23', 80, 5),
(2, '2026-05-24', 75, 4),
(2, '2026-05-25', 70, 3),

(3, '2026-05-23', 30, 1),
(3, '2026-05-24', 28, 1),
(3, '2026-05-25', 25, 0),

(4, '2026-05-23', 60, 3),
(4, '2026-05-24', 58, 2),
(4, '2026-05-25', 55, 2),

(5, '2026-05-23', 35, 1),
(5, '2026-05-24', 33, 1),
(5, '2026-05-25', 30, 0);

-- Crawl issues
INSERT INTO crawl_issues (page_id, issue_type) VALUES
(1, 'missing_title'),
(3, 'duplicate_title'),
(5, 'missing_meta_description');