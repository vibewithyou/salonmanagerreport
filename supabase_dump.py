#!/usr/bin/env python3
"""
Dump Supabase database to SQL file
Includes public schema, auth schema, and edge functions
"""
import sys
import os

# Try to import psycopg2, if not available install it
try:
    import psycopg2
except ImportError:
    print("Installing psycopg2...")
    os.system(f"{sys.executable} -m pip install psycopg2-binary")
    import psycopg2

# Database connection parameters
DB_HOST = "db.tshbudjnxgufagnvgqtl.supabase.co"
DB_NAME = "postgres"
DB_USER = "postgres"
DB_PASSWORD = "v2ku67nv2Ttx9xio"
DB_PORT = 5432
OUTPUT_FILE = r"C:\Users\Tobi\Documents\GitHub\salonmanager\backup.sql"

def connect_db():
    """Connect to Supabase database"""
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=DB_PORT,
            sslmode='require'
        )
        return conn
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        sys.exit(1)

def get_full_dump(conn):
    """Get SQL dump of public schema, auth schema, and edge functions"""
    cur = conn.cursor()
    
    try:
        sql_dump = "-- SalonManager Database Backup\n"
        sql_dump += f"-- Generated: {__import__('datetime').datetime.now()}\n"
        sql_dump += "-- Source: Supabase (PostgreSQL)\n"
        sql_dump += "-- Includes: public schema, auth schema, edge_functions, and storage\n\n"
        sql_dump += "SET client_encoding = 'UTF8';\n"
        sql_dump += "SET standard_conforming_strings = on;\n\n"
        
        # Get all relevant schemas
        schemas = ['public', 'auth', 'storage', 'pgsodium']
        
        for schema in schemas:
            print(f"\n📋 Processing schema: {schema}")
            
            # Get all tables in schema
            cur.execute("""
                SELECT tablename FROM pg_tables 
                WHERE schemaname = %s
                ORDER BY tablename
            """, (schema,))
            tables = [row[0] for row in cur.fetchall()]
            
            if not tables:
                print(f"  No tables found in {schema} schema")
                continue
            
            print(f"  Found {len(tables)} tables")
            
            # For each table
            for table in tables:
                print(f"    Dumping: {table}")
                
                # Get column info
                cur.execute("""
                    SELECT column_name, data_type, is_nullable, column_default
                    FROM information_schema.columns
                    WHERE table_schema = %s AND table_name = %s
                    ORDER BY ordinal_position
                """, (schema, table))
                columns = cur.fetchall()
                
                if columns:
                    col_defs = []
                    col_names = []
                    
                    for col_name, data_type, is_nullable, col_default in columns:
                        col_names.append(col_name)
                        col_def = f'"{col_name}" {data_type}'
                        
                        if col_default:
                            col_def += f" DEFAULT {col_default}"
                        
                        if is_nullable == 'NO':
                            col_def += " NOT NULL"
                        
                        col_defs.append(col_def)
                    
                    # Create table statement
                    sql_dump += f"CREATE TABLE {schema}.\"{table}\" (\n"
                    sql_dump += ",\n".join(f"  {col}" for col in col_defs)
                    sql_dump += "\n);\n\n"
                    
                    # Get data
                    cur.execute(f'SELECT * FROM {schema}."{table}"')
                    rows = cur.fetchall()
                    
                    if rows:
                        col_names_str = ', '.join(f'"{col}"' for col in col_names)
                        
                        for row in rows:
                            values = []
                            for val in row:
                                if val is None:
                                    values.append("NULL")
                                elif isinstance(val, bool):
                                    values.append('true' if val else 'false')
                                elif isinstance(val, str):
                                    # Escape single quotes
                                    escaped = val.replace("'", "''")
                                    values.append(f"'{escaped}'")
                                elif isinstance(val, bytes):
                                    # Handle binary data
                                    values.append(f"E'\\\\x{val.hex()}'")
                                else:
                                    values.append(str(val))
                            
                            values_str = ', '.join(values)
                            sql_dump += f"INSERT INTO {schema}.\"{table}\" ({col_names_str}) VALUES ({values_str});\n"
                        
                        sql_dump += "\n"
        
        # Get edge functions (stored procedures/functions)
        print(f"\n📋 Processing edge functions and stored procedures")
        cur.execute("""
            SELECT 
                n.nspname,
                p.proname,
                pg_get_functiondef(p.oid)
            FROM pg_proc p
            JOIN pg_namespace n ON p.pronamespace = n.oid
            WHERE n.nspname IN ('public', 'auth', 'storage')
            AND p.prokind = 'f'
            ORDER BY n.nspname, p.proname
        """)
        functions = cur.fetchall()
        
        if functions:
            sql_dump += "\n-- ============================================\n"
            sql_dump += "-- FUNCTIONS AND STORED PROCEDURES\n"
            sql_dump += "-- ============================================\n\n"
            
            for schema, func_name, func_def in functions:
                print(f"    Dumping function: {schema}.{func_name}")
                sql_dump += f"{func_def};\n\n"
        
        return sql_dump
        
    except Exception as e:
        print(f"❌ Error dumping schema: {e}")
        raise
    finally:
        cur.close()

def main():
    print("🔄 Connecting to Supabase...")
    conn = connect_db()
    print("✓ Connected!")
    
    print("📊 Dumping database...")
    dump = get_full_dump(conn)
    conn.close()
    
    # Write to file
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(dump)
    
    file_size = os.path.getsize(OUTPUT_FILE) / (1024*1024)
    print(f"\n✓ Dump saved to: {OUTPUT_FILE}")
    print(f"  Size: {file_size:.2f} MB")

if __name__ == "__main__":
    main()
