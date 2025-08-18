import express from "express";
import { login, newUser } from "../controllers/user.js";
import { isAuthenticated } from "../middlewares/auth.js";
import { loginValidator, registerValidator, validateHandler } from "../lib/validators.js";
import { singleAvatar } from "../middlewares/multer.js";

const app = express.Router();

app.post("/signup" ,singleAvatar , registerValidator() , validateHandler ,  newUser);
app.post("/login" , loginValidator() , validateHandler , login);

export default app;