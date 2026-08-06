import express, { Request, Response } from "express";

const app = express();
app.use(express.json());


app.get("/version", (_req: Request, res: Response) => {
  res.json({ version: "1.0.0" });
});

// Return current average temperature based on all senseBox data
app.get("/temperature", (_req: Request, res: Response) => {
  const temperature = Math.floor(Math.random() * 30) + 10;
    res.json({ temperature });
});

export default app;


const port = Number(process.env.PORT ?? 4000);

app.listen(port, () => {
  console.log(`HiveBox API listening on http://localhost:${port}`);
});
