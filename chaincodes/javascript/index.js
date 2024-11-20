const { Contract } = require("fabric-contract-api");
const crypto = require("crypto");
const { parseData, validateData } = require("./util");
const { userSchema } = require("./dto/model");

class KVContract extends Contract {
  constructor() {
    super("KVContract");
  }

  async instantiate() {
    // function that will be invoked on chaincode instantiation
  }

  async put(ctx, data) {
    // parse input data
    const parsedData = JSON.parse(data);
    const isValid = validateData(parsedData, certificateSchema);
    if (!isValid.status) {
      return {
        status: 400,
        message: isValid.validate.errors,
      };
    }

    // generate date
    parsedData.timestamp = getTimestamp(ctx.stub.getTxTimestamp());

    // serialize data
    const stringData = JSON.stringify(parsedData);

    // generate hash
    const key = crypto.createHash("sha256").update(stringData).digest("hex");

    // create block
    await ctx.stub.putState(key, Buffer.from(stringData));

    return {
      status: 201,
      message: "data has been added",
      hash: key,
      timestamp: parsedData.data.timestamp,
    };
  }

  async get(ctx, key) {
    const buffer = await ctx.stub.getState(key);
    if (!buffer || !buffer.length) return { error: "NOT_FOUND" };
    return { success: buffer.toString() };
  }

  async putPrivateMessage(ctx, collection) {
    const transient = ctx.stub.getTransient();
    const message = transient.get("message");
    await ctx.stub.putPrivateData(collection, "message", message);
    return { success: "OK" };
  }

  async getPrivateMessage(ctx, collection) {
    const message = await ctx.stub.getPrivateData(collection, "message");
    const messageString = message.toBuffer
      ? message.toBuffer().toString()
      : message.toString();
    return { success: messageString };
  }

  async verifyPrivateMessage(ctx, collection) {
    const transient = ctx.stub.getTransient();
    const message = transient.get("message");
    const messageString = message.toBuffer
      ? message.toBuffer().toString()
      : message.toString();
    const currentHash = crypto
      .createHash("sha256")
      .update(messageString)
      .digest("hex");
    const privateDataHash = (
      await ctx.stub.getPrivateDataHash(collection, "message")
    ).toString("hex");
    if (privateDataHash !== currentHash) {
      return { error: "VERIFICATION_FAILED" };
    }
    return { success: "OK" };
  }
}

exports.contracts = [KVContract];
