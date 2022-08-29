export function printStuff() { console.log('stuff') }
export function checkEnv() { console.log('env') }
export function changedFilesByEnv(strSandboxChangedFiles, strDevChangedFiles,
    strPreChangedFiles, strProdChangedFiles) {

    const filesPerEnv = new Map()
    filesPerEnv.set('sandbox', strSandboxChangedFiles.split(','))
    filesPerEnv.set('dev', strDevChangedFiles.split(','))
    filesPerEnv.set('pre', strPreChangedFiles.split(','))
    filesPerEnv.set('prod', strProdChangedFiles.split(','))
    return filesPerEnv
}
export function getIncorrectListOfChangedFiles() {
    if (changedFiles) {
        return changedFiles.split(',');
    }
    return [];
}