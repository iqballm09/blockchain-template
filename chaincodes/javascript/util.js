const Ajv = require("ajv");
const ajv = new Ajv();

function getTimestamp(timestamp) {
  const seconds = timestamp.seconds.low;
  const nanos = timestamp.nanos;

  const milliseconds = seconds * 1000 + nanos / 1000000;
  const date = new Date(milliseconds);

  return date.toISOString();
}

const parseData = (data, schema) => {
  const parse = ajv.compileParser(schema);
  const json = parse(data);
  if (json === undefined) {
    return { status: false, data: undefined, log: parse };
  } else {
    return { status: true, data: json, log: undefined };
  }
};

const serializeData = (data, schema) => {
  const serialize = ajv.compileSerializer(schema);
  return serialize(data);
};

module.exports = { parseData, getTimestamp, serializeData };
