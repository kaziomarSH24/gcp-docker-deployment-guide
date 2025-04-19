
# 📘 GCP Deployment Guide using Docker

This guide will walk you through deploying a Dockerized Laravel + React application to a Google Cloud Platform (GCP) Compute Engine VM from scratch.

---

## 📖 Table of Contents

- [📘 GCP Deployment Guide using Docker](#-gcp-deployment-guide-using-docker)
  - [📖 Table of Contents](#-table-of-contents)
  - [📌 Step 1: Create a VM Instance on GCP](#-step-1-create-a-vm-instance-on-gcp)
  - [🔧 Step 2: Install Docker and Docker Compose](#-step-2-install-docker-and-docker-compose)
  - [📅 Step 3: Clone Your Repository](#-step-3-clone-your-repository)
  - [🐳 Step 4: Start Docker Containers](#-step-4-start-docker-containers)
  - [🛠️ Step 5: Permission Fix for Laravel](#️-step-5-permission-fix-for-laravel)
  - [📊 Step 6: Composer Common Issues Fix](#-step-6-composer-common-issues-fix)
    - [Issue: "fatal: detected dubious ownership in repository"](#issue-fatal-detected-dubious-ownership-in-repository)
    - [Issue: "ext-bcmath is missing"](#issue-ext-bcmath-is-missing)
  - [🧪 Step 7: Test Everything](#-step-7-test-everything)
  - [📦 Optional Tools](#-optional-tools)
  - [☁️ Static IP Configuration (If External IP is Not Working)](#️-static-ip-configuration-if-external-ip-is-not-working)
  - [✅ Done](#-done)

---

## 📌 Step 1: Create a VM Instance on GCP

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **Compute Engine > VM instances**
3. Click **Create Instance**
4. Set the following:
   - **Name**: `mytsv-instance`
   - **Region**: As per your preference
   - **Machine type**: e.g., `e2-medium`
   - **Boot disk**: Ubuntu 22.04 LTS
   - **Allow HTTP and HTTPS traffic** (tick both)
5. Click **Create**

Once VM is ready, connect via SSH.

---

## 🔧 Step 2: Install Docker and Docker Compose

To install Docker and Docker Compose on your Ubuntu VM, follow the official documentation:

🔗 [Install Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

Then, install Docker Compose using the following commands:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version
```

---

## 📅 Step 3: Clone Your Repository

```bash
sudo apt install git -y
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

---

## 🐳 Step 4: Start Docker Containers

```bash
docker compose up -d --build
```

If needed, access the container:

```bash
docker exec -it mytsv-app bash
```

---

## 🛠️ Step 5: Permission Fix for Laravel

```bash
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
docker-compose restart nginx
```

---

## 📊 Step 6: Composer Common Issues Fix

### Issue: "fatal: detected dubious ownership in repository"
Fix:
```bash
git config --global --add safe.directory /var/www
```

### Issue: "ext-bcmath is missing"
Fix inside the container:
```bash
apt-get update && apt-get install -y libbcmath-dev
docker-php-ext-install bcmath
```

If issue persists:
```bash
composer update / composer install
```

---

## 🧪 Step 7: Test Everything

- Visit the external IP of your VM on port `80`
- Make sure your Laravel backend and React frontend are accessible

---

## 📦 Optional Tools

```bash
# Check disk usage
df -h

# Install nano (if needed)
sudo apt install nano -y
```

---

## ☁️ Static IP Configuration (If External IP is Not Working)

If your External IP is not working or changes on restart, follow these steps:

1. Go to **VPC Network > IP addresses** from the [Google Cloud Console](https://console.cloud.google.com/)
2. Click on **RESERVE STATIC ADDRESS**
3. Set the following:
   - **Name**: `mytsv-static-ip`
   - **Type**: `Regional`
   - **Region**: (same as your VM)
   - **Attached to**: your VM instance (`mytsv-instance`)
4. Click **Reserve**

Now use the newly assigned static IP to access your application.

---

## ✅ Done

You have successfully deployed your **Laravel + React** application using **Docker** on **GCP**! 🎉
