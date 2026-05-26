# SEO SQL Practice Project

Small PostgreSQL project with sample SEO data and reporting views.

## Run With Docker Compose

Start PostgreSQL and create the tables, data, and views:
```bash
docker compose up -d
```

Stop the database and delete volumes:
```bash
docker compose down -v
```

## Views
### `daily_page_performance`
```sql
SELECT * FROM daily_page_performance;
```

### `weekly_client_summary`
```sql
SELECT * FROM weekly_client_summary;
```

### `seo_opportunity_report`
```sql
SELECT * FROM seo_opportunity_report;
```
