const request = require('supertest');
const app = require('./app');

const { describe, test, expect } = require('@jest/globals');

describe('API Tests', () => {
    test('GET /health returns 200 OK', async () => {
        const res = await request(app).get('/health');
        expect(res.statusCode).toBe(200);
        expect(res.text).toBe('OK');
    });

    test('POST /submit returns correctly', async () => {
        const res = await request(app).post('/submit').send({ data: 'test-value' });
        expect(res.statusCode).toBe(200);
        expect(res.text).toBe('Received: test-value');
    });
});