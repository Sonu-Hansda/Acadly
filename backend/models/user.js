import {hash} from 'bcrypt';
import mongoose , {model , Schema} from 'mongoose';

const userShema = new Schema({
    email: {
        type: String,
        required: true,
        unique: true,
    },
    username:{
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
        select: false, // Exclude password from queries by default
    },
    profilePicture: {
        public_id:{
            type: String,
        },
        url:{
            type: String,
        }
    },
    
},{timestamps: true});

userShema.pre("save" , async function(next){

    if(!this.isModified("password")) return next();

    this.password = await hash(this.password , 10);
    
})

export const User = model('User', userShema);