import request from "supertest";
import app from "../src/index";



describe("GET /version", () => {
    it("should return the version of the API", async () => {
        const response = await request(app).get("/version");
        expect(response.status).toBe(200);
        expect(response.body).toEqual({ version: "1.0.0" });
    });
});
describe("GET /temperature", () => {
    it("should return the current average temperature", async () => {
        const response = await request(app).get("/temperature");
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty("temperature");
        expect(typeof response.body.temperature).toBe("number");
    });
});