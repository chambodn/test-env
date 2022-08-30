export function changedFilesByEnv(strSandboxChangedFiles, strDevChangedFiles,
    strPreChangedFiles, strProdChangedFiles) {

    const filesPerEnv = new Map();
    filesPerEnv.set("sandbox", strSandboxChangedFiles.split(","));
    filesPerEnv.set("dev", strDevChangedFiles.split(","));
    filesPerEnv.set("pre", strPreChangedFiles.split(","));
    filesPerEnv.set("prod", strProdChangedFiles.split(","));
    return filesPerEnv;
}

export function listOfIncorrectFiles(filesPerEnv, currentEnv) {
    filesPerEnv.delete(currentEnv); // filter env first
    const values = [...filesPerEnv.values()];
    //flatten array of arrays
    const list = Array.prototype.concat.apply([], values);
    return list.filter((elem) => elem.length > 0);
}