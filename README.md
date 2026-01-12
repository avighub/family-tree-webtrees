# Family Tree - Webtrees

A containerized family tree management application using **Webtrees** with **MariaDB** database and Docker Compose orchestration.

## Project Overview

This project provides a complete genealogy and family tree management system powered by Webtrees, a free and open-source genealogy software. It's containerized using Docker for easy deployment and management across different environments.

### Key Features
- **Webtrees**: A powerful genealogy platform for managing family trees
- **MariaDB**: Robust relational database for storing genealogical data
- **Docker Compose**: Multi-container orchestration for simplified setup and deployment
- **Media Management**: Dedicated media storage for family photos and documents
- **Persistent Storage**: Data persistence across container restarts

## Quick Start

- Create a new dir inside root: `mkdir srv`
- Clone repository inside `srv` : `https://github.com/avighub/family-tree-webtrees.git`
- Rename/Copy `.env-example` to `.env`
  - Update passwords for `MARIADB_ROOT_PASSWORD` and `MARIADB_PASSWORD`
- Start the apps : `docker compose up -d`
- Open the Webtrees setup wizard: `localhost:8080`
  - DB Config
    - Database server : db
    - Database port: 3306
    - Database name: webtrees
    - Database user: webtrees
    - Database password: your-password-from-env-file
