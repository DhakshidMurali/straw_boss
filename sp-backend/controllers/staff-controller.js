const Staff = require("../models/staff.model");
const Class = require("../models/class.model");
const HttpError = require("../models/http.error");

const createStaff = async (req, res, next) => {
  let staffDetails = req.body;
  let isNewStaff;
  try {
    isNewStaff = await Staff.findOne({ email: staffDetails.email });
  } catch {
    const error = new HttpError(
      "Signing up failed, please try again later.",
      500
    );
    return next(error);
  }

  if (isNewStaff) {
    const error = new HttpError(
      "User exists already, please login instead.",
      500
    );
    return next(error);
  }

  try {
    const salt = await bcrypt.genSalt(10);
    staffDetails.password = await bcrypt.hash(staffDetails.password, salt);
  } catch (err) {
    const error = new HttpError(
      "Signing up failed, please try again later.",
      500
    );
    return next(error);
  }

  const createdStaff = Staff(staffDetails);

  try {
    await createdStaff.save();
  } catch (err) {
    const error = new HttpError(
      "Signing up failed, please try again later.",
      500
    );
    return next(error);
  }
  res.status(201).json({
    code: "200",
    userId: createdStaff.id,
    email: createdStaff.email,
    message: "Staff Added",
  });
};

const staffJoinClass = async (req, res, next) => {
  let staffDetails = req.body;
  let isClass;
  let staff;
  console.log(staffDetails);
  try {
    isClass = await Class.findOne({ name: staffDetails.className });
    staff = await Staff.findById(staffDetails.id);
    let classes = staff.class;
    if (!classes.includes(isClass.id) & !isClass.staff.includes(staff.id)) {
      staff.class.push(isClass.id);

      isClass.staff.push(staff.id);

      isClass.save();

      staff.save();
    }
  } catch {
    console.log("asdzcx");
    const error = new HttpError(
      "Signing up failed, please try again later.",
      500
    );
    return next(error);
  }

  res.status(200).json({
    code: "200",
    message: "Joined Class",
  });
};

exports.staffJoinClass = staffJoinClass;

exports.createStaff = createStaff;
