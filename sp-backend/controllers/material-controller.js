const path = require("path");
const Material = require("../models/material.model");
const Subject = require("../models/subject.model");
const HttpError = require("../models/http.error");

const addMaterial = async (req, res, next) => {
  let materialDetails = req.body;
  let isNewMaterial;
  try {
    isNewMaterial = await Material.findOne({
      name: materialDetails.materialName,
    });
  } catch {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  if (isNewMaterial) {
    const error = new HttpError("Material exists already.", 500);
    return next(error);
  }
  const createdMaterial = Material(materialDetails);
  let subject;
  try {
    subject = await Subject.findOne({
      subjectName: materialDetails.subjectName,
    });
    subject.materialLink.push(createdMaterial.id);
    subject.save();
  } catch {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }
  if (!subject) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  try {
    await createdMaterial.save();
  } catch (err) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }
  res.status(201).json({
    materialId: createdMaterial.id,
    code: "200",
    message: "Material Added",
  });
};

const editStatus = async (req, res, next) => {
  const materialDetails = req.body;
  let material;
  try {
    material = await Material.findById(materialDetails.id);
  } catch {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  if (!material) {
    const error = new HttpError("Not Available.", 500);
    return next(error);
  }

  if (!materialDetails.status) {
    let subject = await Subject.findOne({
      subjectName: materialDetails.subjectName,
    });
    let index = subject.materialLink.filter((material) =>
      console.log(material)
    );
    subject.materialLink.splice(index, 1);

    subject.save();

    await Material.findByIdAndDelete(materialDetails.id);
    return res.status(200).send({
      status: "200",
      message: "Material status Updated",
    });
  }

  try {
    material.accepted = materialDetails.status;
    material.save();
  } catch {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }
  res.status(200).send({
    status: "200",
    message: "Material status Updated",
  });
};

const getBySubject = async (req, res, next) => {
  const { role, subjectName } = req.body;

  let materials;

  try {
    materials = await Material.find({
      subjectName: subjectName,
    });
  } catch {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  if (role === "student") {
    materials = materials.filter((material) => material.accepted === true);
  }
  res.status(200).send({
    status: "200",
    message: "Retrieved materials",
    data: materials,
  });
};

exports.addMaterial = addMaterial;

exports.editStatus = editStatus;

exports.getBySubject = getBySubject;
