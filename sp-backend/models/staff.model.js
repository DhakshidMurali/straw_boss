const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const staffSchema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  class: { type: Array },
  phone: { type: String },
  gmail: { type: String },
});

module.exports = mongoose.model("Staff", staffSchema);
