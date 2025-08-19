

export const getBase64 = (file) => `data:${file.mimetype};base64,${file.buffer.toString("base64")}`;