const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => res.status(200).send('OK'));

// Dynamic route
app.get('/user/:id', (req, res) => {
    res.send(`User ID: ${req.params.id}`);
});

// Input form/endpoint
app.post('/submit', (req, res) => {
    const data = req.body.data;
    if(!data) return res.status(400).send('No data provided');
    res.send(`Received: ${data}`);
});

if (require.main === module) {
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
}

app.listen(PORT, () => {
    console.log(`SERVER_START: Application listening on port ${PORT}`);
});

module.exports = app;