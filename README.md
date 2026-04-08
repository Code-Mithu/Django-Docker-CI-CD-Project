# 🚀 Django Docker CI/CD Project

![Python](https://img.shields.io/badge/Python-3.12-blue?style=flat-square&logo=python)
![Django](https://img.shields.io/badge/Django-green?style=flat-square&logo=django)
![Docker](https://img.shields.io/badge/Docker-Ready-blue?style=flat-square&logo=docker)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=flat-square&logo=github-actions)
![Ubuntu](https://img.shields.io/badge/Server-Ubuntu-E95420?style=flat-square&logo=ubuntu)

A production-style Django deployment pipeline utilizing Docker, Gunicorn, and GitHub Actions for continuous integration and automated server deployment. 

This repository serves as a complete blueprint for transitioning from manual server uploads to a fully automated GitOps workflow.

---

## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Architecture & Workflow](#-architecture--workflow)
3. [Technology Stack](#-technology-stack)
4. [Quick Start Guide](#-quick-start-guide-local-development)
5. [Project Structure](#-project-structure)
6. [CI/CD Pipeline Configuration](#-cicd-pipeline-configuration)
7. [Initial Server Setup](#-initial-server-setup)
8. [Troubleshooting & Commands](#-troubleshooting--common-commands)
9. [Best Practices & Future Scope](#-best-practices--future-scope)

---

## 📌 Project Overview
This project demonstrates a modern, real-world DevOps workflow designed for scalability and reliability. Key features include:
* **Containerized Environment:** Ensures the application runs identically on a local development machine and the production server.
* **Automated CI/CD:** Eliminates manual file transfers (like `wget` or FTP) by triggering deployments directly from Git pushes.
* **Secure Remote Orchestration:** Uses secure SSH keys stored in GitHub Secrets to execute commands safely on the remote Ubuntu server.
* **Reproducible Infrastructure:** All system dependencies are mapped out in `Dockerfile` and `docker-compose.yml`.

---

## 🏗️ Architecture & Workflow

**Deployment Flow:** Code Change → Git Push → GitHub Actions → SSH Connection → Server Pulls Code → Docker Rebuilds Containers → Live Update

```text
                ┌──────────────┐
                │   Dev PC     │
                └──────┬───────┘
                       │ git push origin main
                       ▼
                ┌──────────────┐
                │   GitHub     │
                └──────┬───────┘
                       │ triggers ci.yml
                       ▼
         ┌────────────────────────────┐
         │ GitHub Actions Runner      │
         └────────────┬───────────────┘
                      │ Secure SSH Connection
                      ▼
            ┌────────────────────┐
            │ Server (Ubuntu)    │
            └─────────┬──────────┘
                      │ docker compose up -d --build
                      ▼
           ┌────────────────────────┐
           │ Django + Gunicorn      │
           └────────────────────────┘
````

-----

## 🧱 Technology Stack

| Component | Technology Used | Purpose |
| :--- | :--- | :--- |
| **Backend Framework** | Django (Python 3.12) | Core application logic and API |
| **Application Server** | Gunicorn | WSGI HTTP Server for Python web applications |
| **Containerization** | Docker & Compose | Environment isolation and orchestration |
| **Automation (CI/CD)** | GitHub Actions | Automated testing and deployment pipeline |
| **Version Control** | Git & GitHub | Source code management |
| **Operating System** | Ubuntu 24.04 LTS | Production server environment |

-----

## ⚡ Quick Start Guide (Local Development)

Follow these steps to get the project running locally in under 2 minutes.

### Prerequisites

Make sure your local machine has the following installed:

  * Docker
  * Docker Compose
  * Git

### Step 1: Clone the Repository

```bash
git clone [https://github.com/Code-Mithu/Django-Docker-CI-CD-Project.git](https://github.com/Code-Mithu/Django-Docker-CI-CD-Project.git)
cd Django-Docker-CI-CD-Project
```

### Step 2: Build & Start the Application

```bash
docker compose up -d --build
```

### Step 3: Apply Database Migrations

```bash
docker compose exec web python manage.py migrate
```

### Step 4: Create a Superuser (Optional)

```bash
docker compose exec web python manage.py createsuperuser
```

### Step 5: Access the Application

Open your web browser and navigate to: [http://localhost:8000](https://www.google.com/search?q=http://localhost:8000)

*(Note: To stop the application, run `docker compose down` in your terminal).*

-----

## 📂 Project Structure

```text
Django-Docker-CI-CD-Project/
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions pipeline configuration
├── config/                  # Main Django project configuration directory
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── .dockerignore            # Files for Docker to ignore during build
├── .gitignore               # Files for Git to ignore
├── docker-compose.yml       # Docker services and networking setup
├── Dockerfile               # Instructions to build the Django image
├── manage.py                # Django execution script
├── requirements.txt         # Python package dependencies
└── README.md                # Project documentation
```

-----

## 🔁 CI/CD Pipeline Configuration

The continuous integration and deployment pipeline is handled by GitHub Actions. It listens for any code pushed to the `main` branch.

### How it Works:

1.  **Checkout:** Grabs the latest code from the repository.
2.  **Setup:** Initializes the Python environment.
3.  **Test:** Installs dependencies and runs standard Django system checks.
4.  **Deploy:** Uses SSH to log into the production server.
5.  **Update:** Pulls the newest code onto the server.
6.  **Restart:** Rebuilds and restarts the Docker containers with the fresh code.

### Required GitHub Secrets

For the pipeline to securely access your Ubuntu server, you must configure the following secrets in your GitHub repository (`Settings → Secrets and variables → Actions`):

| Secret Name | Description | Example Value |
| :--- | :--- | :--- |
| `HOST` | Your server's public IP address | `192.168.1.100` |
| `USER` | Your server's SSH username | `mithu` |
| `SSH_KEY` | Your server's private SSH key (PEM format) | `-----BEGIN OPENSSH PRIVATE KEY-----...` |

-----

## 🖥️ Initial Server Setup

Before GitHub Actions can deploy automatically, you must clone the repository onto your server for the first time.

1.  SSH into your Ubuntu server.
2.  Clone the repository into the user's home directory:

<!-- end list -->

```bash
cd ~
git clone [https://github.com/Code-Mithu/Django-Docker-CI-CD-Project.git](https://github.com/Code-Mithu/Django-Docker-CI-CD-Project.git) myproject
cd myproject
```

3.  Start the containers manually the first time:

<!-- end list -->

```bash
docker compose up -d --build
```

-----

## 🛠️ Troubleshooting & Common Commands

**Check if containers are running properly:**

```bash
docker ps
```

**View live logs for the Django application:**

```bash
docker logs myproject-web-1 --tail 50 -f
```

**Fix "Port already in use" errors:**

```bash
sudo lsof -i :8000
```

**Perform a completely clean reset (Deletes database volumes\!):**

```bash
docker compose down -v
docker system prune -f
docker compose up -d --build
```

-----

## ⚠️ Best Practices & Future Scope

### Security Warnings

**Never** commit the following files to GitHub:

  * `.env` files containing actual passwords or secret keys.
  * `venv/` (Virtual environments).
  * `db.sqlite3` (Your production database).

### Planned Architecture Upgrades

  * **Database Switch:** Migrate from SQLite to PostgreSQL for production readiness.
  * **Reverse Proxy:** Implement a Dockerized Nginx container to handle web traffic and static files.
  * **SSL Certificates:** Integrate Let's Encrypt for automatic HTTPS.
  * **Static File Management:** Configure WhiteNoise or an AWS S3 bucket for media/static handling.

-----

## 👨‍💻 Author

**Code-Mithu**
*Backend Developer | DevOps Enthusiast*

*This project is provided for educational and demonstration purposes regarding CI/CD and containerization.*

```
```
