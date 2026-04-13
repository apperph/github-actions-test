# Spec-Driven Rails App Development and Deployment (End-to-End Guide)

## Overview
This document provides a complete end-to-end guide for building, testing, and deploying a spec-driven Ruby on Rails 8 application using Docker, Kamal, and Amazon Lightsail, with automated CI/CD via GitHub Actions.

Workflow:
```
Edit business spec → Commit → GitHub Actions (validate + test) → Deploy via Kamal → App updates
```

---

## 1. Project Setup

[Placeholder: Complete step-by-step project initialization including Rails 8 setup, initial configuration, database setup, and basic application structure. This section will cover creating the Rails app, configuring essential files, setting up the business spec system, and preparing the project for spec-driven development.]

### Create Rails App

```bash
rails new spec_driven_app --database=sqlite3
cd spec_driven_app
```

### Run App Locally

```bash
bin/dev
```

---

## 2. Version Control (Git + GitHub)

### Initialize Git

```bash
git init
git add .
git commit -m "Initial commit - spec driven Rails app"
```

### Connect to GitHub

```bash
git remote add origin git@github.com:apperph/github-actions-test.git
git branch -M main
git push -u origin main
```

---

## 3. Deployment Setup (Lightsail)

### SSH into Server

```bash
ssh -i ~/Downloads/rails-test-key.pem ubuntu@<LIGHTSAIL_IP>
```

### Notes
- Default user: `ubuntu`
- Ensure Docker is installed
- Open port 80

---

## 4. Kamal Deployment Setup

### Install Kamal

```bash
bundle add kamal
```

### Deploy Config (`config/deploy.yml`)

```yaml
service: spec_driven_app
image: ghcr.io/apperph/github-actions-test
servers:
  web:
    - 13.213.250.166
proxy:
  ssl: false
  host: 13.213.250.166
registry:
  server: ghcr.io
  username: apperph
  password:
    - KAMAL_REGISTRY_PASSWORD
builder:
  arch: amd64
env:
  clear:
    PORT: 80
    RAILS_ENV: production
  secret:
    - RAILS_MASTER_KEY
ssh:
  user: ubuntu
  keys_only: true
  config: true
```

---

## 5. Spec-Driven Logic

### Business Spec File

```bash
config/specs/business.yml
```

---

## 6. Rake Tasks

### Validate + Sync

```ruby
namespace :specs do
  task validate: :environment do
    # validations
  end
  task sync: :environment do
    # apply logic
  end
end
```

---

## 7. GitHub Actions CI/CD

### Workflow File
`.github/workflows/deploy.yml`

### Pipeline Flow
1. Validate spec
2. Run tests
3. Deploy via Kamal

### Key Commands Used in Workflow

#### SSH Setup

```bash
mkdir -p ~/.ssh
echo "${{ secrets.LIGHTSAIL_SSH_KEY }}" > ~/.ssh/lightsail_key
chmod 600 ~/.ssh/lightsail_key
ssh-keygen -R "${{ vars.LIGHTSAIL_HOST }}" || true
ssh-keyscan "${{ vars.LIGHTSAIL_HOST }}" >> ~/.ssh/known_hosts
```

**Important:**
- Do NOT use `-H` in `ssh-keyscan`
- Avoid hashed known_hosts (causes HostKeyMismatch)

---

## 8. Git Workflow (VERY IMPORTANT)

### Always Sync Before Push

```bash
git pull --rebase origin main
```

### Push Changes

```bash
git add .
git commit -m "Your message"
git push origin main
```

### If Push Rejected

```bash
git pull --rebase origin main
git push origin main
```

### Resolve Conflicts

```bash
git status
# edit files
git add <file>
git rebase --continue
```

---

## 9. GitHub Secrets & Variables Configuration

This section explains how to securely configure credentials required for deployment.

### Where to Configure
Go to your GitHub repository:
Settings → Secrets and variables → Actions

You will see two sections:
- Secrets
- Variables

### A. GitHub Secrets (Sensitive Data)

#### 1. LIGHTSAIL_SSH_KEY
**What this is**  
Your private SSH key (.pem) used to access the Lightsail instance.

**How to get it (from your local machine)**  
If you already SSH like this:

```bash
ssh -i ~/Downloads/rails-test-key.pem ubuntu@13.213.250.166
```

Then open the key:

```bash
cat ~/Downloads/rails-test-key.pem
```

**What to copy**  
Copy everything, including:

```
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
```

**Add to GitHub**
1. Go to Secrets → New repository secret
2. Name: `LIGHTSAIL_SSH_KEY`
3. Paste the entire key
4. Click Add secret

#### 2. RAILS_MASTER_KEY
**What this is**  
Rails uses this to decrypt credentials.

**Get it locally**

```bash
cat config/master.key
```

**Add to GitHub**
- Name: `RAILS_MASTER_KEY`
- Value = contents of master.key

#### 3. GHCR_TOKEN
**What this is**  
Token for pushing/pulling Docker images from GitHub Container Registry.

**Create token**
1. Go to GitHub → Settings → Developer Settings → Personal Access Tokens
2. Create new token with scopes:
   - `write:packages`
   - `read:packages`

**Add to GitHub**
- Name: `GHCR_TOKEN`
- Value = your token

### B. GitHub Variables (Non-sensitive)

#### 1. LIGHTSAIL_HOST
**What this is**  
Your Lightsail public IP

Example: `13.213.250.166`

**Add to GitHub**
1. Go to Variables → New repository variable
2. Name: `LIGHTSAIL_HOST`
3. Value: `13.213.250.166`

---

## 10. Important Notes

### Spec Updates
Whenever editing `config/specs/business.yml`, you must:
1. Validate
2. Commit
3. Push

### Validate Locally

```bash
bundle exec rake specs:validate
```

### Run Tests

```bash
bundle exec rails test
```

### Deploy Trigger

#### Automatic (preferred)

```bash
git commit -m "Update spec"
git push origin main
```

#### Manual Trigger
GitHub UI:
1. Go to **Actions**
2. Select **Rails CI/CD Deploy**
3. Click **Run workflow**

#### Force Trigger

```bash
git commit --allow-empty -m "Trigger deploy"
git push origin main
```

---

## 11. Manual Updates in GitHub (No Terminal)

### Editing Business Spec
1. Go to repository
2. Navigate to `config/specs/business.yml`
3. Click **Edit**
4. Modify values
5. Scroll down → Commit changes

### Result
- Triggers GitHub Actions
- Runs validation + tests
- Deploys automatically

---

## 12. Final Architecture

```
PM edits YAML (GitHub UI or local)
        ↓
GitHub Actions
  - validate
  - test
        ↓
Kamal deploy
        ↓
Lightsail server
        ↓
Updated Rails app
```

---

## 13. Best Practices / Lessons Learned
- Always `git pull --rebase` before push
- Avoid secrets in repo
- Never re-run old workflows
- Use fresh commits to trigger deploy
- Keep tests aligned with specs
- Avoid hashed SSH known_hosts
- Validate specs before pushing
 