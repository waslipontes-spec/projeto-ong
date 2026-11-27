
document.querySelector('#app').innerHTML = `
  <h1>Projeto ONG</h1>
  <h2>Status da API: <span id="status">Verificando...</span></h2>
  <p id="data"></p>
`;

async function verificarAPI() {
  const status = document.querySelector('#status');
  const data = document.querySelector('#data');

  try {
    const resposta = await fetch('/api/health');

    if (!resposta.ok) {
      throw new Error('Falha na comunicação com a API');
    }

    const resultado = await resposta.json();

    status.textContent = resultado.status;
    data.textContent = 'Data e hora: ' +
      new Date(resultado.timestamp).toLocaleString('pt-BR');

  } catch (erro) {
    status.textContent = 'erro';
    data.textContent = erro.message;
  }
}

verificarAPI();
