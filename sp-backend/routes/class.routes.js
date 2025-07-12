const express = require("express");
const classRouter = express.Router();

const classController = require("../controllers/class-controller");

classRouter.post("/create-class", classController.createClass);

module.exports = classRouter;
