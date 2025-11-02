import express from "express";
import { uploadMiddleware, uploadNotes, listNotes, getNote } from "../controllers/subjectNotesController.js";

const router = express.Router();

// Upload multiple notes to a subject. Form field for files: 'files' (matches attachmentsMulter)
router.post("/subjects/:subjectId/notes", uploadMiddleware, uploadNotes);

// List notes for a subject
router.get("/subjects/:subjectId/notes", listNotes);

// Get single note metadata (url)
router.get("/notes/:noteId", getNote);

export default router;
