import mongoose from "mongoose";

const subjectSchema = new mongoose.Schema({

  title: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  professor: {
    type: String,
    required: true,
  },
  credits: {
    type: Number,
    required: true,
  },

  // 2. Array of References to Notes (for quick access and population)
  notes: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Note' // This tells Mongoose that the IDs in this array belong to 'Note' documents
  }],

  // 3. Timestamps
  createdAt: {
    type: Date,
    default: Date.now,
  }
});

const Subject = mongoose.model('Subject', subjectSchema);
module.exports = Subject;