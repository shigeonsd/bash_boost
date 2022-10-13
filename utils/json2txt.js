const data = require('./docs.json');

const variables = data['variables'];
const functions = data['functions'];

console.log("=== 変数 ===");
for (const key in variables) {
    variable = variables[key];
    console.log(variable['name'], "--",  variable['description']);
}

console.log("\n=== 関数 ===");
for (const key in functions) {
    func = functions[key];
    console.log(func['name']);
    // console.log(func['args']);
    console.log(func['description']);
}

