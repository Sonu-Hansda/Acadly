import express from "express";
import userRoutes from "./routes/user.js";
import subjectNotesRoutes from "./routes/subjectNotes.js";
import cookieParser from "cookie-parser";
import { connectDB } from "./utils/features.js";
import {v2 as cloudinary } from "cloudinary";
import dotenv from "dotenv";
import { errorMiddleware } from "./middlewares/error.js";
// import cors from "cors";

dotenv.config({
  path: "./.env"
})

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});

const app = express();
const port = 3000;

connectDB(process.env.MONGO_URI);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
// app.use(cors(corsOptions));


app.use("/api/v1/user" ,  userRoutes)
app.use("/api/v1" , subjectNotesRoutes)

app.get("/", (req, res) => {
  res.send("Hello World!");
});


app.use(errorMiddleware);

app.listen(port, () => {
  console.log(`app is running on port ${port}`);
});
