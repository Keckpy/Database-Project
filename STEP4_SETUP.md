# Step 4 RESET and DELETE Setup

1. Import `database/DDL.sql` in phpMyAdmin. This creates `sp_reset_database` and loads the sample data.
2. Import `database/PL.sql` in phpMyAdmin. This creates `sp_delete_specimen_test`.
3. Start the web application.
4. Open **SpecimenTests** and delete one row.
5. Return to **Home** and click **RESET Database**. The five sample SpecimenTests rows should return.

The command below also calls the installed RESET procedure:

```bash
npm run reset
```
