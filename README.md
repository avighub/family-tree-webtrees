# Family Tree - Webtrees

A containerised family tree management application using **Webtrees** with **MariaDB** database and Docker Compose orchestration.

## Project Overview

This project provides a complete genealogy and family tree management system powered by Webtrees, a free and open-source genealogy software. It's containerised using Docker for easy deployment and management across different environments.

### Key Features
- **Webtrees**: A powerful genealogy platform for managing family trees
- **MariaDB**: Robust relational database for storing genealogical data
- **Docker Compose**: Multi-container orchestration for simplified setup and deployment
- **Media Management**: Dedicated media storage for family photos and documents
- **Persistent Storage**: Data persistence across container restarts

## Quick Start
- Create a new dir as per your choice: `mkdir webtrees-app`
- Clone repository inside `webtrees-app`: `git clone https://github.com/avighub/family-tree-webtrees.git`
- One Simple Rule (Everything Else Follows)
  - The script decides where the website lives.
  - NOT the folder you run the script from.
- Once cloned, navigate to repo dir: `cd family-tree-webtrees`
- In `deploy-webtrees.sh`, update `APP_DIR`:
  - It is important to define based on where you created `webtrees-app`. Example : `APP_DIR="$HOME/webtrees-app/$ROUTER_NAME"`
- Copy `.env-example` to `.env`: `cp .env-example .env`
- Update passwords for `MARIADB_ROOT_PASSWORD` and `MARIADB_PASSWORD`
- Deploy and Start the app: `./deploy-webtrees.sh`
- Open the Webtrees setup wizard: `localhost:8080`
  - DB Config
    - Database server: db
    - Database port: 3306
    - Database name: webtrees
    - Database user: webtrees
    - Database password: your-password-from-env-file
