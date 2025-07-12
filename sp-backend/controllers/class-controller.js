const Class = require("../models/class.model");
const HttpError = require("../models/http.error");

const createClass = async (req, res, next) => {
  let classDetails = req.body;
  let isNewClass;
  try {
    isNewClass = await Class.findOne({ name: classDetails.name });
  } catch {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  if (isNewClass) {
    const error = new HttpError("Class exists already.", 500);
    return next(error);
  }

  const createdClass = Class(classDetails);

  try {
    await createdClass.save();
  } catch (err) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }
  res.status(201).json({
    classId: createdClass.id,
    code: "200",
    message: "Class Added",
  });
};

exports.createClass = createClass;
