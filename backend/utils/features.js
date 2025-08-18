import {v2 as cloudinary} from "cloudinary";
import { v4 as uuid } from "uuid";
import { getBase64 } from "../lib/helper.js";
import mongoose from "mongoose";
import jwt from "jsonwebtoken";


const cookieOptions = {
        maxAge: 15*24*60*60*1000,
        sameSite: "none",
        httpOnlt: true,
        secure: true,
}


const connectDB = ( uri ) => {
    mongoose.connect(uri ,{
        dbName: "Campusify",
    }).then(() => {
        console.log("MongoDB connected");
    }).catch((err) => {
        throw err;
    })
}

const sendToken= (res, user , code , message) => {
    const token = jwt.sign({_id: user._id}, process.env.JWT_SECRET);

    return res.status(code).cookie("campusify-token" , token , cookieOptions).json({
        success: true,
        user,
        message,
    });
};

const uploadFilesToCloudinary = async(files = []) => {

    const uploadPromises = files.map((file) => {
        return new Promise((resolve , reject) => {
            cloudinary.uploader.upload(
                getBase64(file) ,
                {
                resource_type: "auto",
                public_id: uuid(),
            } , (error , result) => {
                if(error){
                    return reject(error);
                }
                else{
                    resolve(result);
                }
            })
        })
    });

    try {
        const results = await Promise.all(uploadPromises);
        const formattedResults = results.map((result) => ({
            public_id: result.public_id,
            url: result.secure_url,
        }));

        return formattedResults;
    } catch (error) {
        throw new Error("Error while uploading files to cloudinary" , error);
    }

}

export { connectDB, uploadFilesToCloudinary , sendToken};