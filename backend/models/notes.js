import mongoose from "mongoose";

const noteSchema = new mongoose.Schema({

    title: {
        type: String,
        required: true,
        trim: true,
        maxlength: 200
    },
    url: {
        type: String,
        required: true,
    },

  // 2. Reference to the Parent Subject
    subject: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Subject', // This tells Mongoose to look in the 'Subject' collection
        required: true,
    },

    uploadedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },

    createdAt: {
        type: Date,
        default: Date.now,
    }
});

const Note = mongoose.model('Note', noteSchema);
export default Note;