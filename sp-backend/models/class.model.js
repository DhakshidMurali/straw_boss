const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const classSchema = new Schema({
  name: { type: String, required: true },
  students: { type: Array },
  staff: { type: Array },
  works: { type: Array },
});

module.exports = mongoose.model("Class", classSchema);
