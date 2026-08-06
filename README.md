# Database-Project

## Database Setup

Create a `.env` file in the project root:

```env
DB_HOST=classmysql.engr.oregonstate.edu
DB_USER=cs340_USER
DB_PASSWORD=YOUR_PASSWORD
```

Replace `cs340_USER` and `YOUR_PASSWORD` with your own database credentials.

Install dependencies:

```bash
npm install
```

Set up the database:

```bash
npm run setup
```

This runs `DDL.sql` and `PL.sql` to create the tables, sample data, and stored procedures.