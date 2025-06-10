const httpsFunctions = require('firebase-functions/v2/https');
// const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const logger = require('firebase-functions/logger');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');
const ajv = new Ajv({ strict: true });
addFormats(ajv);
initializeApp();

// <-- Add User -->
const userSchema = {
  type: 'object',
  required: ['email', 'name', 'weight', 'age', 'height', 'goals', 'cheatMeals', 'createdAt'],
  properties: {
    email: { type: 'string', format: 'email' },
    name: { type: 'string', minLength: 1 },
    weight: { type: 'integer', minimum: 100, maximum: 300 },
    height: { type: 'integer' },
    age: { type: 'integer' },
    goals: {
      type: 'object',
      required: ['caloric', 'fats', 'carbs', 'protein'],
      properties: {
        caloric: { type: 'integer' },
        fats: { type: 'integer' },
        carbs: { type: 'integer' },
        protein: { type: 'integer' },
      },
      additionalProperties: false,
    },
    cheatMeals: {
      type: 'array',
      items: {
        type: 'integer',
        minimum: 1,
        maximum: 7,
      },
      uniqueItems: true,
      maxItems: 2,
    },
    createdAt: { type: 'string', format: 'date-time' },
  },
  additionalProperties: false,
};
exports.addUser = httpsFunctions.onRequest({ region: 'us-east4' }, async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  const { userModel, uid } = req.body;

  if (!uid || !userModel) {
    res.status(400).send('Missing userModel or uid');
    logger.warn('Missing userModel or uid');
    return;
  }

  if (typeof uid !== 'string' || typeof userModel !== 'string') {
    res.status(400).send('Invalid userModel or uid type');
    logger.warn('Invalid userModel or uid type');
    return;
  }

  let jsonUserModel;
  try {
    jsonUserModel = JSON.parse(userModel);
  } catch (err) {
    logger.warn(err);
    return res.status(400).json({ result: 'Invalid JSON string' });
  }

  if (!ajv.validate(userSchema, jsonUserModel)) {
    logger.warn('Invalid userModel schema ' + ajv.errors);
    return res.status(400).json({
      result: 'Invalid userModel schema',
      errors: ajv.errors,
    });
  }

  try {
    const docRef = getFirestore().collection('Users').doc(uid);
    await docRef.set(jsonUserModel);
    const doc = await docRef.get();

    res.status(200).json({
      result: doc.exists ? 'Suceeded' : 'Failed',
      data: doc.data(),
    });
  } catch (error) {
    res.status(500).json({
      result: 'Error',
      error: error.message,
    });
    logger.error('Error:' + error.message);
  }
});
