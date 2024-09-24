### Hexlet tests and linter status:
[![Actions Status](https://github.com/Avanera/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Avanera/rails-project-66/actions)

Deployed application link: https://rails-project-66-49rm.onrender.com

A project that helps automatically monitor the quality of repositories on GitHub. It tracks changes and runs them through built-in analyzers. Then it generates reports and sends them to the user.

## Prerequisites

Ruby version: 3.2.2
Rails version: 7.1.4
Development/Test Database: sqlite3
Production Database: PostgreSQL

## System Dependencies

Node.js and Yarn are required for managing frontend assets.

## Configuration

1. Clone the repository:
```bash
git clone https://github.com/Avanera/rails-project-66.git
cd rails-project-66
```
2. Install required gems, install JavaScript dependencies:
```bash
make setup
```

## Database Setup

1. Create the database:
```bash
rails db:create
```
2. Run the migrations:
```bash
rails db:migrate
```
3. Seed the database:
```bash
rails db:seed
```

## Running the Application

1. Start the Rails server:
```bash
make start
```
2. Navigate to http://localhost:3000 to view the application.

## How to Run the Test Suite

The project uses minitest and power_assert for testing. To run the tests:
```bash
make test
```

## Linting

- Rubocop: Ensure your code adheres to the style guide.
- Slim Lint: Check your Slim templates for any issues.
```bash
make lint
```

## Deployment Instructions for Render

Go to the [Render instance of the project](https://dashboard.render.com/web/srv-crpfacl2ng1s7395f5dg).

Click 'Manual Deploy' -> Select 'Deploy Latest Commit'

In case you need to deploy a new instance on Render read the instructions [here](https://docs.render.com/deploy-rails)
