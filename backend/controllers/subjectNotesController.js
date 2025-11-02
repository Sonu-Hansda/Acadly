import path from "path";
import fs from "fs";
import { TryCatch } from "../middlewares/error.js";
import Subject from "../models/subject.js";
import Note from "../models/notes.js";
import { uploadFilesToCloudinary } from "../utils/features.js";
import { attachmentsMulter } from "../middlewares/multer.js";
import { ErrorHandler } from "../utils/utility.js";

// Upload notes (multiple files supported) to a subject. Files are uploaded to Cloudinary
const uploadNotes = TryCatch(async (req, res, next) => {
  const { subjectId } = req.params;

  const subject = await Subject.findById(subjectId);
  if (!subject) return next(new ErrorHandler("Subject not found", 404));

  const files = req.files || [];
  if (!files.length) return next(new ErrorHandler("No files provided", 400));

  // Use existing helper to upload files to cloudinary
  const results = await uploadFilesToCloudinary(files);

  const createdNotes = [];

  for (let i = 0; i < results.length; i++) {
    const file = files[i];
    const uploadResult = results[i];

    const note = await Note.create({
      title: req.body.titles?.[i] || file.originalname,
      url: uploadResult.url,
      subject: subject._id,
      uploadedBy: req.user?._id || null,
    });

    subject.notes.push(note._id);
    createdNotes.push(note);
  }

  await subject.save();

  return res.status(201).json({
    success: true,
    notes: createdNotes,
  });
});

const listNotes = TryCatch(async (req, res, next) => {
  const { subjectId } = req.params;
  const subject = await Subject.findById(subjectId).populate({
    path: "notes",
    select: "title url uploadedAt uploadedBy",
  });

  if (!subject) return next(new ErrorHandler("Subject not found", 404));

  return res.json({ success: true, notes: subject.notes });
});

const getNote = TryCatch(async (req, res, next) => {
  const { noteId } = req.params;
  const note = await Note.findById(noteId);
  if (!note) return next(new ErrorHandler("Note not found", 404));

  // If the note.url is a cloudinary URL, redirect or return it
  return res.json({ success: true, note });
});

export { attachmentsMulter as uploadMiddleware, uploadNotes, listNotes, getNote };
