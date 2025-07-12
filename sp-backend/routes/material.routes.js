const express = require("express");
const materialRouter = express.Router();

const materialController = require("../controllers/material-controller");

materialRouter.post("/add-material", materialController.addMaterial);

materialRouter.post("/edit-status", materialController.editStatus);

materialRouter.post("/get-materials", materialController.getBySubject);

module.exports = materialRouter;
