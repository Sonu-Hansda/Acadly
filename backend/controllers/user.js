// import { compare } from "bcrypt";
// import { TryCatch } from "../middlewares/error.js";
// import { User } from "../models/user.js";
// import { sendToken, uploadFilesToCloudinary } from "../utils/features.js";
// import { ErrorHandler } from "../utils/utility.js";


// const newUser = TryCatch(async (req ,res , next) => {

//     const {email , username , password} = req.body;
//     const profilePicture = req.file ;

//     if(!profilePicture){
//         return next(new ErrorHandler("Please upload a profile picture", 400));
//     }

//     try {
//         const result = await uploadFilesToCloudinary([profilePicture]);
//         console.log("Cloudinary result:", result);

//         if (!result || result.length === 0) {
//             return next(new ErrorHandler("Failed to upload profile picture", 500));
//         }

//         const profilePictureData = {
//             public_id: result[0].public_id,
//             url: result[0].url,
//         };

//         console.log("Profile picture data:", profilePictureData);

//         const user = await User.create({
//             email,
//             username,
//             password,
//             profilePicture: profilePictureData,
//         });

//         sendToken(res, user, 201, "User created successfully");
//     } catch (error) {
//         console.error("Error in newUser:", error);
//         return next(new ErrorHandler("Failed to create user", 500));
//     }

// })


// const login = TryCatch(async(req , res , next) => {

//     const {username , password} = req.body ;

//     const user = await User.findOne({username}).select("+password");
        
//     if(!user){
//         return next(new ErrorHandler("Invalid Username or password" , 404));
//     }

//     const isPasswordMatched = await compare(password , user.password);

//     if(!isPasswordMatched){
//         return next(new ErrorHandler("Invalid Password or username" , 404));
//     }

//     sendToken(res , user , 200 , `Welcome back , ${user.username}`);
// });

// export { newUser  , login};



import { compare } from "bcrypt";
import { TryCatch } from "../middlewares/error.js";
import { User } from "../models/user.js";
import { sendToken, uploadFilesToCloudinary } from "../utils/features.js";
import { ErrorHandler } from "../utils/utility.js";

const newUser = TryCatch(async (req, res, next) => {
    const { email, username, password } = req.body;
    const profilePicture = req.file;

    if (!profilePicture) {
        return next(new ErrorHandler("Please upload a profile picture", 400));
    }

    try {
        const result = await uploadFilesToCloudinary([profilePicture]);

        if (!result || result.length === 0) {
            return next(new ErrorHandler("Failed to upload profile picture", 500));
        }

        const profilePictureData = {
            public_id: result[0].public_id,
            url: result[0].url,
        };

        const user = await User.create({
            email,
            username,
            password,
            profilePicture: profilePictureData,
        });

        sendToken(res, user, 201, "User created successfully");

    } catch (error) {
        if (error.name === 'ValidationError') {
            const validationErrors = Object.values(error.errors).map(err => err.message);
            return next(new ErrorHandler(`Validation Error: ${validationErrors.join(', ')}`, 400));
        }
        
        if (error.code === 11000) {
            const duplicateField = Object.keys(error.keyValue)[0];
            return next(new ErrorHandler(`${duplicateField} already exists`, 400));
        }
        
        if (error.message.includes('cloudinary')) {
            return next(new ErrorHandler("Failed to upload image", 500));
        }
        
        return next(new ErrorHandler(error.message || "Failed to create user", 500));
    }
});

const login = TryCatch(async (req, res, next) => {
    const { username, password } = req.body;

    const user = await User.findOne({ username }).select("+password");
        
    if (!user) {
        return next(new ErrorHandler("Invalid Username or password", 404));
    }

    const isPasswordMatched = await compare(password, user.password);

    if (!isPasswordMatched) {
        return next(new ErrorHandler("Invalid Password or username", 404));
    }

    sendToken(res, user, 200, `Welcome back, ${user.username}`);
});

export { newUser, login }