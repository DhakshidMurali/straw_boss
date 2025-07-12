const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const workSchema = new Schema({
  creatorName: { type: String, required: true },
  creatorId: { type: String, required: true },
  type: { type: String, required: true },
  title: { type: String, required: true },
  questions: { type: Array, required: true },
  unCompleted: { type: Array },
  completed: {
    type: Array,
  },
  lastDate: { type: String, required: true },
  class: { type: String, required: true },
  options: { type: Array },
  correctOptions: { type: Array },
});

module.exports = mongoose.model("Work", workSchema);
