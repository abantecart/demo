# AbanteCart Database Update Steps

This guide provides instructions for updating the AbanteCart database with demo data.

## Prerequisites

- Docker environment running (e.g., Laradock)
- AbanteCart installed locally

## Step 1: Install AbanteCart

Install AbanteCart with the latest demo version locally.

## Step 2: Load Database SQL File

Load `abc.sql` into your local database using Docker commands.

### Example for Local Docker

1. **Copy the SQL file to the Docker container:**

```bash
docker cp /Users/pavel/Documents/shoppingcart_development/github/demo/docker/abc.sql laradock-workspace-1:/tmp/
```

Expected output:
```
Successfully copied 1.55MB to laradock-workspace-1:/tmp/
```

2. **Access the Docker container:**

```bash
docker exec -it laradock-workspace-1 bash
```

3. **Import the SQL file from within the Docker bash:**

```bash
/var/www# mysql -h mariadb -u root -proot abc_demo < /tmp/abc.sql
```

**Note:** Adjust the following parameters based on your setup:
- `-h mariadb` - database host
- `-u root` - database username
- `-proot` - database password (no space between `-p` and password)
- `abc_demo` - database name

## Step 3: Run Upgrade in AbanteCart Admin

1. Log in to the AbanteCart admin panel
2. Navigate to **Extensions → Network Install**
3. Use the upgrade key: `abantecart_upgrade_14x`

## Step 4: Check the update on local site and export the database

## NOTE: Do not change any settings in admin after the update, just export the database as is.

```bash
docker exec -it laradock-workspace-1 mysqldump -h mariadb -u root -proot abc_demo --complete-insert > /tmp/abc.sql

cp /tmp/abc.sql .../github/demo/docker/abc.sql
```

## Step 5: Commit and Push Changes