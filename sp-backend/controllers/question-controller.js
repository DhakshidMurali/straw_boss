const Question = require("../models/question.model");
const HttpError = require("../models/http.error");

const createQuestion = async (req, res, next) => {
  let details = req.body;
  let newQuestion;

  try {
    // newQuestion = await Question.findOne({ question: details.toLowerCase() });
  } catch (err) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }
  if (newQuestion) {
    const error = new HttpError("Question already exist.", 500);
    return next(error);
  }

  createdQuestion = Question(details);
  try {
    createdQuestion.save();
  } catch (err) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  res.status(201).json({
    code: "200",
    questionId: createdQuestion.id,
  });
};

const addComment = async (req, res, next) => {
  questionDetails = req.body;
  let question;

  try {
    question = await Question.findById(questionDetails.questionId);
  } catch (err) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  try {
    question.comments.push({
      comment: questionDetails.comment,
      time: questionDetails.time,
    });

    question.save();
  } catch (err) {
    const error = new HttpError("Please try again later.", 500);
    return next(error);
  }

  res.status(201).json({
    code: "200",
    questionId: question.id,
    message: "Question Added",
  });
};

exports.createQuestion = createQuestion;
exports.addComment = addComment;
