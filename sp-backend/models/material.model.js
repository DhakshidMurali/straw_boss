const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const materialSchema = new Schema(
  {
    materialName: { type: String, required: true },
    subjectName: { type: String, required: true },
    materialLink: { type: String, required: true },
    uploadedBy: { type: Object, required: true },
    accepted: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Material", materialSchema);
