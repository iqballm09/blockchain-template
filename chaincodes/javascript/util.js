const Ajv = require("ajv");
const ajv = new Ajv();

function getTimestamp(timestamp) {
  const seconds = timestamp.seconds.low;
  const nanos = timestamp.nanos;

  const milliseconds = seconds * 1000 + nanos / 1000000;
  const date = new Date(milliseconds);

  return date.toISOString();
}

const validateData = (json, schema) => {
  const validate = ajv.compile(schema);

  // Validate the data
  const status = validate(json);
  return { status, validate };
};

module.exports = { getTimestamp, validateData };
