import jwt from "jsonwebtoken";
import { ErrorHandler } from "../utils/utility.js";
import { TryCatch } from "./error.js";


const isAuthenticated = TryCatch((req , res , next) => {

    // console.log("cookies:",req.cookies);
    const token = req.cookies[CAMPUSIFY_TOKEN];

    if(!token){
        return next(new ErrorHandler("Please login to access this route", 401));
    }

    const decodedData = jwt.verify(token , process.env.JWT_SECRET);
    req.user = decodedData._id ;

    next();
})

export { isAuthenticated };