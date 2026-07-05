
-- =====================================================
-- Orchestra Inventory Database Setup
-- Run with: psql -f 01_setup.sql
-- =====================================================


\echo 'Building Orchestra Inventory Database...'

\echo 'Creating Tables...'
\i 02_tables.sql  --  defines core schema

\echo 'Creating Functions...'
\i 03_functions.sql

\echo 'Creating Triggers'
\i 04_triggers.sql

\echo 'Creating Indexes...'
\i 05_indexes.sql

\echo 'Creating Seed Data'
\i 06_seed_data.sql

\echo 'Creating Views'
\i 07_views.sql

\echo 'Orchestra Inventory Database build complete.'