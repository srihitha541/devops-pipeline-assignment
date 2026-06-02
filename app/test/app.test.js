const test = require("node:test");
const assert = require("node:assert/strict");
const app = require("../app");

async function startTestServer() {
	const server = app.listen(0);
	await new Promise((resolve) => server.once("listening", resolve));
	return server;
}

test("GET / returns running status", async (t) => {
	const server = await startTestServer();
	t.after(() => server.close());

	const { port } = server.address();
	const response = await fetch(`http://127.0.0.1:${port}/`);
	const body = await response.json();

	assert.equal(response.status, 200);
	assert.deepEqual(body, { status: "running" });
});

test("GET /health returns ok", async (t) => {
	const server = await startTestServer();
	t.after(() => server.close());

	const { port } = server.address();
	const response = await fetch(`http://127.0.0.1:${port}/health`);
	const body = await response.json();

	assert.equal(response.status, 200);
	assert.deepEqual(body, { health: "ok" });
});
