const express = require("express");

const app = express();
const port = process.env.PORT || 3000;

app.disable("x-powered-by");

app.use((req, res, next) => {
	const startTime = Date.now();

	res.on("finish", () => {
		const durationMs = Date.now() - startTime;
		console.log(
			`${req.method} ${req.originalUrl} ${res.statusCode} ${durationMs}ms`
		);
	});

	next();
});

app.get("/", (_req, res) => {
	res.status(200).json({ status: "running" });
});

app.get("/health", (_req, res) => {
	res.status(200).json({ health: "ok" });
});

app.use((req, res) => {
	res.status(404).json({ error: "not_found" });
});

app.use((err, _req, res, _next) => {
	console.error("Unhandled error:", err);
	res.status(500).json({ error: "internal_server_error" });
});

if (require.main === module) {
	const server = app.listen(port, () => {
		console.log(`App listening on port ${port}`);
	});

	process.on("SIGTERM", () => {
		console.log("SIGTERM received, shutting down");
		server.close(() => {
			console.log("HTTP server closed");
			process.exit(0);
		});
	});
}

module.exports = app;
