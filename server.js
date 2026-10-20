const express = require('express');

const app = express();
const port = process.env.PORT || 8080;

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    service: 'azure-devops-ci-cd-sample',
    timestamp: new Date().toISOString(),
  });
});

app.get('/', (req, res) => {
  res.status(200).send(`
    <html>
      <head>
        <title>Azure Pipelines Demo</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; background: #f4f7fb; color: #1f2a37; }
          .card { max-width: 700px; margin: auto; background: white; padding: 32px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.08); }
          code { background: #eef4ff; padding: 2px 6px; border-radius: 4px; }
        </style>
      </head>
      <body>
        <div class="card">
          <h1>Azure Pipelines CI/CD Demo</h1>
          <p>Application deployed successfully using Azure Container Registry and Azure App Service.</p>
          <p>Build ID: <code>${process.env.BUILD_BUILDID || 'local'}</code></p>
          <p>Environment: <code>${process.env.ENVIRONMENT || 'development'}</code></p>
          <p>Health endpoint: <code>/health</code></p>
        </div>
      </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
