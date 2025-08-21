import { body , validationResult} from "express-validator";
import { ErrorHandler } from "../utils/utility.js";

const registerValidator = () => [

    body("username" , "Please enter a valid username").notEmpty(),
    body("password" , "Please enter a valid password").notEmpty(),
    body("email" , "Please enter a valid email").isEmail(),
];

const loginValidator = () => [
    body("username" , "Please enter a valid username").notEmpty(),
    body("password" , "Please enter a valid password").notEmpty(),
];

const validateHandler = (req , res , next) => {
    const errors = validationResult(req);

    const errorMessages = errors.array().map(error => error.msg).join(", ");
    
    if(errors.isEmpty()){
        return next();
    }else{
        console.log("Validation errors:", errorMessages);
        next(new ErrorHandler(errorMessages , 400));
    }
}

export { registerValidator, validateHandler , loginValidator };