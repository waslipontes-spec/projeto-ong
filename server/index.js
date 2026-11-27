
import express from 'express';
import 'dotenv/config';

const app = express();
const PORT = process.env.API_PORT || 3000;

app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'API da ONG funcionando!',
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`API rodando em http://localhost:${PORT}`);
});
