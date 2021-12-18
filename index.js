#!/usr/bin/env node
const yargs = require("yargs/yargs");
const {hideBin} = require("yargs/helpers");
require("livescript");

const argv = hideBin(process.argv);
yargs(argv.length ? argv : ["ls", "-s"])
  .commandDir("commands", {
    extensions: ["ls"]
  })
  .alias("h", "help")
  .alias("v", "version")
  .parse();
