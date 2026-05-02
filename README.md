## 🛠 Tech Stack
*   **App Framework**: Node.js (Express)
*   **Testing**: Jest, Supertest
*   **Linting**: ESLint
*   **CI/CD**: GitHub Actions
*   **Automation/IaC**: Bash Scripting
*   **Process Management**: PM2
*   **Environment**: Local Production (Blue-Green Simulation)

---

## 📊 Workflow Diagram

```mermaid
graph TD;
    A[Code Push to Dev/Main] --> B[GitHub Actions CI];
    B --> C{Lint & Tests Pass?};
    C -->|No| D[Pipeline Fails];
    C -->|Yes| E[Infrastructure Prep iac-setup.sh];
    E --> F[Deploy to Inactive Env deploy.sh];
    F --> G{Health Check};
    G -->|Pass| H[Switch Traffic & Stop Old Env];
    G -->|Fail| I[Abort & Rollback rollback.sh];
    H --> J[Monitor health.log];
```

---

## 🚀 Step-by-Step Instructions

### 1. Infrastructure as Code (Environment Preparation)
The environment setup is fully automated. Running this script installs the necessary process manager (PM2) and creates the local production directory structure (`~/local-production/blue` and `~/local-production/green`).

**Command:**
```bash
bash iac-setup.sh
```

> **Proof of IaC Execution:**
> 
> *<img width="512" height="193" alt="devops scrn 2" src="https://github.com/user-attachments/assets/b1cf1538-0dd4-4ae9-915f-be41f8e4aa12" />*

### 2. Continuous Integration (CI) Pipeline
Every push to the `main` or `dev` branches triggers the GitHub Actions pipeline. The pipeline automates the environment setup, dependency installation, code linting with ESLint, and unit testing with Jest.

> **Proof of Successful CI Pipeline:**
> 
> *<img width="1880" height="672" alt="devops scrn 1" src="https://github.com/user-attachments/assets/c83b23f3-e95e-4a34-b8e7-858d86522b2d" />
*

### 3. Continuous Deployment (Blue-Green Simulation)
Deployment is handled by `deploy.sh`. It identifies the current active environment, deploys the latest code to the "idle" environment, and performs a pre-flight health check. Only if the health check passes does it switch traffic and shut down the previous version.

*   **Blue Port**: 3001
*   **Green Port**: 3002

**Command:**
```bash
bash deploy.sh
```

> **Proof of Deployment & Running App:**
> 
> *<img width="1233" height="497" alt="devops scrn 3" src="https://github.com/user-attachments/assets/e1991d47-3e3d-48cc-92d5-5f2d449e4281" />*
> ----
> *<img width="1232" height="636" alt="devops scrn 4" src="https://github.com/user-attachments/assets/a553c2b8-4cce-4b95-bdb1-b520934d9e2e" />*

### 4. Rollback Mechanism
If a deployment fails the health check, or needs to be manually reverted, the `rollback.sh` script instantly restarts the previous stable environment and updates the traffic pointer.

**Command:**
```bash
bash rollback.sh
```

> **Proof of Rollback:**
> 
> *<img width="1236" height="480" alt="devops scrn 5" src="https://github.com/user-attachments/assets/e6796746-63b6-4440-9c93-6b264e5f5327" />*

### 5. Monitoring & Health Checks
The `monitor.sh` script runs a background loop that pings the active environment's `/health` endpoint every 5 seconds. All results are logged with timestamps and status codes to `health.log`.

**Command:**
```bash
bash monitor.sh
```

> **Proof of Monitoring Logs:**
> 
> *<img width="617" height="170" alt="devops scrn 6" src="https://github.com/user-attachments/assets/1191c35e-beca-4fa7-a322-a08deb785d9f" />*
> ----
> *<img width="612" height="111" alt="devops scrn 7" src="https://github.com/user-attachments/assets/c180748e-107f-4d2f-b13c-535536f74510" />*
