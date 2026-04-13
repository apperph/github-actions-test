# Spec-Driven Rails App Development and Deployment (End-to-End Documentation)

## Overview
This document outlines the complete end-to-end process of developing, building, containerizing, and deploying a Ruby on Rails 8 application using Docker and Kamal on an Amazon Lightsail instance.

---

## 1. Project Setup

### 1.1 Create Rails Application

```bash
rails new spec_driven_app --database=sqlite3
cd spec_driven_app
```

### 1.2 Initial Configuration

- Ruby version: 3.3.6
- Rails version: 8.x
- Database: SQLite (for testing)
- Environment: Production-ready Docker setup

### 1.3 Install Dependencies

```bash
bundle install
```

---

## 2. Version Control

### 2.1 Initialize Git

```bash
git init
git add .
git commit -m "Initial Rails 8 app"
```

### 2.2 Create GitHub Repository

```bash
git remote add origin https://github.com/apperph/github-actions-test.git
git branch -M main
git push -u origin main
```

**Important:**

Never commit `.kamal/secrets` or `.env`

Add to `.gitignore`:

```gitignore
.kamal/secrets
.env
```

---

## 3. Deployment Setup (AWS Lightsail)

### 3.1 Create Lightsail Instance

- OS: Ubuntu
- Region: Singapore (ap-southeast-1)
- Instance Type: Upgraded (to avoid memory issues)
- Static IP: 13.213.250.166

### 3.2 Configure Firewall

| Port | Purpose |
|------|---------|
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |

### 3.3 SSH Setup

Download the `.pem` key and configure:

```bash
chmod 400 ~/Downloads/rails-test-key.pem
```

Add to SSH config:

```bash
nano ~/.ssh/config
```

```sshconfig
Host rails-test-lightsail
  HostName 13.213.250.166
  User ubuntu
  IdentityFile ~/Downloads/rails-test-key.pem
```

Test connection:

```bash
ssh rails-test-lightsail
```

---

## 4. Docker Setup

Ensure Docker is running locally:

```bash
docker info
```

If Docker is not running:

```bash
open -a Docker
```

---

## 5. Deployment with Kamal

### 5.1 Install Kamal

```bash
gem install kamal
```

### 5.2 Initialize Kamal

```bash
kamal init
```

### 5.3 Configure `config/deploy.yml`

```yaml
service: spec_driven_app
image: ghcr.io/apperph/github-actions-test

servers:
  web:
    - 13.213.250.166

registry:
  server: ghcr.io
  username: YOUR_USERNAME
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  clear:
    RAILS_ENV: production
    PORT: 80
```

### 5.4 Setup Server

```bash
bin/kamal setup
```

### 5.5 Deploy Application

```bash
bin/kamal deploy
```

---

## 6. Debugging & Issues Encountered

### Issue 1: SSH Authentication Failed

**Error:**  
Authentication failed for user ubuntu

**Fix:**
- Ensure correct `.pem` path
- Check permissions:
  ```bash
  chmod 400 key.pem
  ```

### Issue 2: Docker Not Running

**Error:**  
Cannot connect to Docker daemon

**Fix:**
```bash
open -a Docker
```

### Issue 3: Lightsail Instance Timeout

**Error:**  
Operation timed out

**Fix:**
- Start instance in AWS console
- Verify port 22 is open

### Issue 4: Deployment Lock Error

**Error:**  
Deploy lock already in place

**Fix:**
```bash
bin/kamal lock release
```

### Issue 5: Container Unhealthy

**Error:**  
target failed to become healthy

**Cause:** Low memory (512 MB instance)

**Fix:**
- Upgrade Lightsail instance
- Redeploy

### Issue 6: GHCR Connection Timeout

**Error:**  
context deadline exceeded

**Fix:**
```bash
docker login ghcr.io
```

### Issue 7: GitHub Secret Leak

**Error:**  
Push blocked due to exposed token

**Fix:**
- Remove `.kamal/secrets` from Git
- Rotate GitHub token
- Amend commit

---

## 7. Important Notes

### Infrastructure
- Public IP: 13.213.250.166
- SSH Host: rails-test-lightsail
- Registry: ghcr.io/apperph/github-actions-test

### Key Commands

- **Deploy:**  
  ```bash
  bin/kamal deploy
  ```

- **Logs:**  
  ```bash
  bin/kamal app logs
  ```

- **SSH:**  
  ```bash
  ssh rails-test-lightsail
  ```

- **Docker Logs:**  
  ```bash
  docker logs <container_id>
  ```

### Common Pitfalls
- Double `ghcr.io` in image path
- Docker not running locally
- Secrets committed to repo
- Instance too small (memory)

---

## 8. Best Practices / Lessons Learned

### Infrastructure
- Use at least 1GB+ RAM for Rails apps
- Always attach a static IP

### Security
- Never commit:
  - `.env`
  - `.kamal/secrets`
- Rotate tokens immediately if exposed

### Deployment
- Always run `docker login ghcr.io` on the server before deploy
- Check container health:
  ```bash
  docker ps
  ```

### Debugging Tips
- If deploy hangs → check logs immediately
- If SSH fails → check instance + firewall
- If container unhealthy → inspect logs

### Workflow Recommendation

Future improvement:  
PM edits business spec → GitHub commit → GitHub Actions builds image → Kamal deploys automatically

---

## Final Status

- ✅ Rails 8 App Running
- ✅ Dockerized
- ✅ Deployed via Kamal
- ✅ Hosted on AWS Lightsail
- ✅ Zero-downtime deployment working

## Access the App

**URL:** http://13.213.250.166
```

This is the full file — no broken parts.  
Just copy from `# Spec-Driven Rails App Deployment...` to the end and save it.

If you're still having trouble copying, tell me your device (Windows/Mac/Android) and I'll give you the easiest method for your device.
