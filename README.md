# Influencer Marketplace — A Fiverr-Style Platform for Creators

A Ruby on Rails monolith application that replicates the core functionality of Fiverr, customized specifically for influencers and content creators. It includes a matching engine to connect businesses with the right influencers, secure payment integrations, and a complete Docker setup for seamless deployment.

---

## 🚀 Features

- 🛒 **Fiverr-style Marketplace**  
  Post, browse, and purchase gigs — just like Fiverr.

- 👥 **Tailored for Influencers**  
  Designed specifically to help influencers and content creators monetize their services.

- 🔍 **Business-to-Influencer Matching Algorithm**  
  Smart matchmaking engine that connects brands with the most suitable creators based on niche, engagement, and pricing.

- 📦 **Dockerized Setup**  
  Easily run the entire stack locally or in production using Docker and Docker Compose.

- 📨 **Messaging System**  
  Real-time chat between businesses and influencers using Action Cable (WebSockets).

- 🔐 **Authentication & Authorization**  
  User roles (influencer, business), email/password login.

- 📊 **Dashboards**  
  Custom dashboards for influencers and businesses to manage gigs, orders, earnings, and collaborations.

---

## 🧰 Tech Stack

- **Framework:** Ruby on Rails
- **Database:** PostgreSQL
- **Background Jobs:** Sidekiq with Redis
- **Frontend:** ERB + Stimulus.js (optional: Hotwire/Turbo)
- **Real-Time:** Action Cable
- **Containerization:** Docker & Docker Compose
- **Authentication:** Devise

---

## 🐳 Local Development (with Docker)

### Prerequisites

- Docker
- Docker Compose

### Getting Started

```bash
# Clone the repo
git clone https://github.com/your-username/influencer-marketplace.git
cd influencer-marketplace

# Build and run the containers
docker-compose up --build

# Set up the database
docker-compose run web rake db:create db:migrate db:seed
```
